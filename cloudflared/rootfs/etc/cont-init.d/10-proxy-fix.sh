#!/usr/bin/with-contenv bashio

set -euo pipefail

CONFIG_FILE="/config/configuration.yaml"
PATCHED=0

auto_trust_local_proxy="$(bashio::config 'auto_trust_local_proxy')"
auto_restart_core_after_proxy_patch="$(bashio::config 'auto_restart_core_after_proxy_patch')"
additional_trusted_proxies="$(bashio::config 'additional_trusted_proxies')"

if [[ "${auto_trust_local_proxy}" != "true" ]]; then
    bashio::log.info "Automatic trusted_proxies patching is disabled."
    exit 0
fi

if [[ ! -f "${CONFIG_FILE}" ]]; then
    bashio::log.fatal "Home Assistant configuration file not found at ${CONFIG_FILE}"
    bashio::exit.nok
fi

trim_lines() {
    sed 's/#.*$//' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//' | sed '/^$/d'
}

with_temp_file() {
    local target="$1"
    local temp_file
    temp_file="$(mktemp)"
    cat > "${temp_file}"
    mv "${temp_file}" "${target}"
}

http_block_exists() {
    awk '
        /^http:[[:space:]]*$/ { found=1; exit }
        END { exit !found }
    ' "${CONFIG_FILE}"
}

use_x_forwarded_for_exists() {
    awk '
        /^http:[[:space:]]*$/ { in_http=1; next }
        in_http && /^[^[:space:]]/ { in_http=0 }
        in_http && /^[[:space:]]+use_x_forwarded_for:[[:space:]]*true[[:space:]]*$/ { found=1; exit }
        END { exit !found }
    ' "${CONFIG_FILE}"
}

trusted_proxies_block_exists() {
    awk '
        /^http:[[:space:]]*$/ { in_http=1; next }
        in_http && /^[^[:space:]]/ { in_http=0 }
        in_http && /^[[:space:]]+trusted_proxies:[[:space:]]*$/ { found=1; exit }
        END { exit !found }
    ' "${CONFIG_FILE}"
}

proxy_exists() {
    local proxy="$1"
    awk -v proxy="${proxy}" '
        /^http:[[:space:]]*$/ { in_http=1; next }
        in_http && /^[^[:space:]]/ { in_http=0; in_trusted=0 }
        in_http && /^[[:space:]]+trusted_proxies:[[:space:]]*$/ { in_trusted=1; next }
        in_trusted && /^[[:space:]]+[^-[:space:]]/ { in_trusted=0 }
        in_trusted {
            line=$0
            sub(/^[[:space:]]*-[[:space:]]*/, "", line)
            sub(/[[:space:]]*$/, "", line)
            gsub(/^["'"'"']|["'"'"']$/, "", line)
            if (line == proxy) { found=1; exit }
        }
        END { exit !found }
    ' "${CONFIG_FILE}"
}

append_http_block() {
    cat >> "${CONFIG_FILE}" <<'EOF'

http:
  use_x_forwarded_for: true
  trusted_proxies:
EOF
    PATCHED=1
}

ensure_use_x_forwarded_for() {
    if use_x_forwarded_for_exists; then
        return
    fi

    awk '
        {
            print
            if ($0 ~ /^http:[[:space:]]*$/ && !inserted) {
                print "  use_x_forwarded_for: true"
                inserted=1
            }
        }
    ' "${CONFIG_FILE}" | with_temp_file "${CONFIG_FILE}"
    PATCHED=1
}

ensure_trusted_proxies_block() {
    if trusted_proxies_block_exists; then
        return
    fi

    awk '
        {
            print
            if ($0 ~ /^[[:space:]]+use_x_forwarded_for:[[:space:]]*true[[:space:]]*$/ && !inserted) {
                print "  trusted_proxies:"
                inserted=1
            }
        }
    ' "${CONFIG_FILE}" | with_temp_file "${CONFIG_FILE}"
    PATCHED=1
}

ensure_proxy() {
    local proxy="$1"

    if proxy_exists "${proxy}"; then
        return
    fi

    awk -v proxy="${proxy}" '
        /^http:[[:space:]]*$/ { in_http=1 }
        in_http && /^[^[:space:]]/ { in_http=0 }
        {
            print
            if (in_http && $0 ~ /^[[:space:]]+trusted_proxies:[[:space:]]*$/ && !inserted) {
                print "    - " proxy
                inserted=1
            }
        }
    ' "${CONFIG_FILE}" | with_temp_file "${CONFIG_FILE}"
    PATCHED=1
}

declare -a proxies=(
    "127.0.0.1"
    "::1"
)

while IFS= read -r extra_proxy; do
    proxies+=("${extra_proxy}")
done < <(printf '%s\n' "${additional_trusted_proxies}" | tr ',' '\n' | trim_lines)

if ! http_block_exists; then
    append_http_block
fi

ensure_use_x_forwarded_for
ensure_trusted_proxies_block

for proxy in "${proxies[@]}"; do
    ensure_proxy "${proxy}"
done

if [[ "${PATCHED}" -eq 1 ]]; then
    bashio::log.warning "Updated /config/configuration.yaml to trust local reverse proxies."
    if [[ "${auto_restart_core_after_proxy_patch}" == "true" ]]; then
        bashio::log.warning "Restarting Home Assistant Core to apply proxy configuration."
        if ! curl -fsS -X POST \
            -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" \
            -H "Content-Type: application/json" \
            "http://supervisor/core/restart" >/dev/null; then
            bashio::log.error "Failed to restart Home Assistant Core automatically. Please restart it manually."
        fi
    else
        bashio::log.warning "Restart Home Assistant Core manually to apply proxy configuration changes."
    fi
else
    bashio::log.info "trusted_proxies configuration already satisfied."
fi
