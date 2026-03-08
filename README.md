# Cloudflared Home Assistant Add-on Repository

这是一个面向 Home Assistant OS 的 `cloudflared` 加载项仓库，用于通过 Cloudflare Tunnel 安全暴露 Home Assistant，以及宿主机上的其他本地服务。

这个仓库的目标用户主要是中文用户，尤其是使用 HAOS、国产盒子、冬瓜 HAOS、以及国内网络环境下部署 Cloudflare Tunnel 的用户。

## 仓库地址

把下面这个地址添加到 Home Assistant 的自定义加载项仓库：

```text
https://github.com/traceless929/ha-cloudflared-addon
```

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

## 适用场景

- 不开放路由器端口，直接暴露 Home Assistant
- 暴露宿主机上的其他本地 Web 服务
- 处理某些 HAOS 环境里常见的 `400 Bad Request`
- 处理国内网络环境下 `QUIC` 不稳定、GitHub 下载过慢等问题

## 仓库结构

- `repository.yaml`：Home Assistant 加载项仓库元数据
- `cloudflared/`：Cloudflared 加载项源码目录
- `README.md`：仓库级说明文档

## 文档入口

- 仓库总览：`README.md`
- 加载项说明：`cloudflared/README.md`
- 安装、配置与排障：`cloudflared/DOCS.md`

## License / 许可证

This project is released under the MIT License.

本项目基于 MIT License 发布。

## Contributing / 参与改进

See `CONTRIBUTING.md` for contribution guidelines.

贡献说明请参考 `CONTRIBUTING.md`。

## English Summary

This repository provides a Home Assistant add-on for running Cloudflare Tunnel in remotely managed token mode. It is designed for Home Assistant OS users who need host-network access, optional `trusted_proxies` auto-fix, and practical workarounds for common network issues such as unstable QUIC connections.
