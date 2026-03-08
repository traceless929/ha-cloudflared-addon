# Contributing

Thanks for your interest in improving this repository.

感谢你愿意改进这个仓库。

## Scope

This repository focuses on a Home Assistant add-on for running Cloudflare Tunnel in a way that works well for HAOS users, especially users in mainland China and users running host-network-based setups.

本仓库聚焦于一个适合 HAOS 用户使用的 Cloudflare Tunnel 加载项，尤其关注中国大陆网络环境和宿主机网络访问场景。

## Guidelines

- Prefer small, focused changes.
- Keep documentation Chinese-first, with English as a supplement.
- Avoid hardcoding personal device IPs, private tokens, or one-off debugging data.
- Be conservative with any feature that edits Home Assistant configuration automatically.
- Preserve compatibility with both `aarch64` and `amd64` when possible.

## Before Opening a Pull Request

- Make sure add-on shell scripts pass `bash -n`
- Update `CHANGELOG.md` when behavior changes in a user-visible way
- Keep `README.md` and `cloudflared/DOCS.md` aligned with the actual behavior

## Security

Do not commit real Cloudflare tokens, credentials, or private hostnames that are not meant to be public.
