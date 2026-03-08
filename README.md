# Cloudflared Home Assistant Add-on Repository

面向 Home Assistant OS 的 Cloudflare Tunnel 加载项仓库。

这个项目的目标很直接：

- 不开放路由器端口，直接把 Home Assistant 挂到 Cloudflare Tunnel
- 让加载项可以访问宿主机上的其他本地端口
- 尽量减少国内用户在 HAOS、国产盒子、冬瓜 HAOS 等环境下的踩坑成本

如果你遇到过下面这些问题，这个仓库就是为你准备的：

- `400 Bad Request`
- `trusted_proxies 127.0.0.1`
- `QUIC` 不稳定
- GitHub 下载慢
- 想暴露 Home Assistant 之外的本机服务

## 仓库地址

把下面这个地址添加到 Home Assistant 的自定义加载项仓库：

```text
https://github.com/traceless929/ha-cloudflared-addon
```

添加后，你会在 Home Assistant 的 add-on store 里看到本仓库提供的加载项。

## 包含的加载项

### Cloudflared Tunnel

`cloudflared_host_tunnel` 是一个 Home Assistant 加载项，使用 Cloudflare 远程托管 Tunnel Token 模式运行 `cloudflared`。

主要能力：

- 基于官方 `cloudflare/cloudflared` Docker 镜像构建
- 支持 `Tunnel Token` 远程托管模式
- 支持 `host_network: true`，可访问 Home Assistant 宿主机上的其他本地端口
- 提供可选的 `trusted_proxies` 自动修复能力
- 重点兼容 `127.0.0.1` / `::1` 反代来源场景
- 支持在 `QUIC` 不稳定时切换 `HTTP/2`

一句话理解：

它不是帮你替代 Cloudflare Dashboard，而是把 HAOS 侧的 `cloudflared` 客户端封装成一个更适合国内用户安装、配置和排障的加载项。

## 适用场景

- 不开放路由器端口，直接暴露 Home Assistant
- 暴露宿主机上的其他本地 Web 服务
- 处理某些 HAOS 环境里常见的 `400 Bad Request`
- 处理国内网络环境下 `QUIC` 不稳定、GitHub 下载过慢等问题

特别适合：

- Home Assistant OS 用户
- 国产盒子用户
- 冬瓜 HAOS 用户
- 想把 Cloudflare Tunnel 做成“一次配好、以后少折腾”的用户

## 仓库结构

- `repository.yaml`：Home Assistant 加载项仓库元数据
- `cloudflared/`：Cloudflared 加载项源码目录
- `README.md`：仓库级说明文档

## 文档入口

- 仓库总览：`README.md`
- 加载项说明：`cloudflared/README.md`
- 安装、配置与排障：`cloudflared/DOCS.md`

如果你是第一次用，建议直接从 `cloudflared/DOCS.md` 开始看。

## License / 许可证

This project is released under the MIT License.

本项目基于 MIT License 发布。

## Contributing / 参与改进

See `CONTRIBUTING.md` for contribution guidelines.

贡献说明请参考 `CONTRIBUTING.md`。

## English Summary

This repository provides a Home Assistant add-on for running Cloudflare Tunnel in remotely managed token mode. It is designed for Home Assistant OS users who need host-network access, optional `trusted_proxies` auto-fix, and practical workarounds for common network issues such as unstable QUIC connections.
