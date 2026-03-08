# Changelog

All notable changes to this project will be documented in this file.

本项目的重要变更都会记录在这里。

The format loosely follows Keep a Changelog and uses semantic-style versioning for add-on releases.

本文件参考 Keep a Changelog 风格编写，并使用接近语义化的版本表达方式。

## 0.2.0

### Added

- Optional automatic `trusted_proxies` repair for `127.0.0.1` and `::1`
- Optional automatic Home Assistant Core restart after proxy patching
- Chinese-first documentation and `zh-Hans` translations
- Release assets such as `icon.png`, `logo.png`, and repository-level metadata

### Changed

- Switched to copying `cloudflared` from the official `cloudflare/cloudflared` image
- Sanitized repository metadata and removed device-specific content
- Reworked docs for public GitHub release and mainland China deployment scenarios

### 新增

- 可选自动修复 `127.0.0.1` 和 `::1` 的 `trusted_proxies`
- 可选在代理配置修复后自动重启 Home Assistant Core
- 中文优先文档和 `zh-Hans` 翻译
- `icon.png`、`logo.png` 和仓库级发布元数据等资源

### 变更

- 改为从官方 `cloudflare/cloudflared` 镜像复制 `cloudflared` 二进制
- 完成仓库脱敏，移除设备专用内容
- 重写文档，使其更适合 GitHub 公开发布和国内环境部署

## 0.1.0

### Added

- Initial working version for Home Assistant OS
- Verified host network access and Cloudflare Tunnel token mode

### 新增

- 面向 Home Assistant OS 的首个可运行版本
- 已验证宿主机网络访问能力和 Cloudflare Tunnel Token 模式
