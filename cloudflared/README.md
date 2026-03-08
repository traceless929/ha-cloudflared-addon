# Cloudflared Tunnel Add-on

这个目录包含 Home Assistant 加载项 `cloudflared_host_tunnel` 的完整实现。

## 这个加载项做什么

这个 add-on 以远程托管 Tunnel 模式运行 `cloudflared`，适合希望通过 Cloudflare Tunnel 访问 Home Assistant 以及宿主机其他本地服务的 Home Assistant OS 用户。

它的核心目标不是替代 Cloudflare Dashboard，而是把 HAOS 侧的 `cloudflared` 客户端封装成一个更适合国内用户安装和排障的加载项。

## 特性

- 通过 `Tunnel Token` 启动 Cloudflare Tunnel
- 使用 `host_network: true` 访问 Home Assistant 和宿主机其他本地端口
- 可选自动修复 `127.0.0.1` / `::1` 的 `trusted_proxies`
- 可选在修复代理配置后自动重启 Home Assistant Core
- 通过 `additional_args` 传递高级 `cloudflared` 参数
- 复用官方 `cloudflare/cloudflared` 镜像中的二进制

## 目录结构

- `config.yaml`：add-on 元数据、配置项和 schema
- `build.yaml`：构建参数
- `Dockerfile`：运行镜像定义
- `rootfs/etc/cont-init.d`：启动前校验和可选代理修复脚本
- `rootfs/etc/services.d/cloudflared/run`：`cloudflared` 服务启动入口
- `DOCS.md`：面向用户的安装与排障文档
- `CHANGELOG.md`：版本变更记录
- `translations/`：配置项名称与说明

## 设计边界

- 本 add-on 不会替你创建 Cloudflare Public Hostname
- 默认不会自动修改 Home Assistant 配置
- 自动修补 `configuration.yaml` 属于高影响行为，因此必须显式开启
- Cloudflare 公网域名、服务路由和 Zero Trust 配置仍应在 Cloudflare Dashboard 中管理

## 适合哪些用户

- 想用 Cloudflare Tunnel 暴露 Home Assistant 的 HAOS 用户
- 需要顺带暴露宿主机其他本地服务的用户
- 在国内网络环境中遇到 GitHub 下载慢、`QUIC` 不稳定问题的用户
- 使用冬瓜 HAOS 或类似系统，遇到 `trusted_proxies 127.0.0.1` 问题的用户

## English Summary

This add-on wraps `cloudflared` for Home Assistant OS users who need host-network access, optional reverse proxy auto-fix, and a practical deployment model for Cloudflare Tunnel using a remotely managed token.
