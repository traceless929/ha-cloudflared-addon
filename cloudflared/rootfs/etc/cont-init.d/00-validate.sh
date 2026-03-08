#!/usr/bin/with-contenv bashio

set -euo pipefail

token="$(bashio::config 'tunnel_token')"
auto_trust_local_proxy="$(bashio::config 'auto_trust_local_proxy')"
auto_restart_core_after_proxy_patch="$(bashio::config 'auto_restart_core_after_proxy_patch')"

if [[ -z "${token}" ]]; then
    bashio::log.fatal "The 'tunnel_token' option is required."
    bashio::exit.nok
fi

bashio::log.info "Host networking is enabled for this add-on."
bashio::log.info "Configure Tunnel Public Hostname service URLs in Cloudflare Dashboard."
bashio::log.info "Examples: http://127.0.0.1:8123 or http://127.0.0.1:5000"

if [[ "${auto_trust_local_proxy}" == "true" ]]; then
    bashio::log.warning "Automatic trusted_proxies patching is enabled."
    bashio::log.warning "This add-on may update /config/configuration.yaml to trust 127.0.0.1 and ::1."
fi

if [[ "${auto_restart_core_after_proxy_patch}" == "true" ]]; then
    bashio::log.warning "Automatic Home Assistant Core restart after proxy patch is enabled."
fi
