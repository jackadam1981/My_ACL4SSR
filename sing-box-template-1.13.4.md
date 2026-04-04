# sing-box 1.13.4 模板说明

这个仓库原本只有 Clash/ACL4SSR 方向的模板。现在补了一套面向 `sing-box 1.13.4` 的配置模板和本地 rule-set 生成逻辑：

- 主配置：`sing-box-template-1.13.4.json`
- 生成脚本：`tools/generate_sing_rule_sets.py`
- 生成目录：`sing-rule-set/*.json`

## 这份模板的定位

这是一份偏客户端侧的基础模板，默认提供：

- `mixed` 入站，监听 `127.0.0.1:7890`
- `clash_api` 控制端口 `127.0.0.1:9090`
- `selector` / `urltest` 代理组
- `sing-box 1.13.x` 可用的新 DNS server 结构
- 本仓已有自定义规则的 sing-box source rule-set v4 版本

为了避免把旧版 Clash 语法误写到 sing-box 里，这份模板没有继续使用旧式 DNS 字符串写法，也没有使用 1.13 已移除的 legacy inbound / legacy special outbound 字段。

## 使用前需要替换的内容

模板里内置了两个占位节点：

- `node-1`
- `node-2`

当前它们是 `socks` 示例出站，地址分别是：

- `127.0.0.1:1081`
- `127.0.0.1:1082`

你需要在导入前把它们改成你自己的真实节点，或者改成你实际使用的出站类型（例如 `vmess`、`vless`、`trojan`、`hysteria2` 等）。

> 说明：模板里的远程规则集来自 `MetaCubeX/meta-rules-dat` 的 `sing` 分支，并设置了 `download_detour: "proxy"`。如果占位节点没换成真实节点，远程规则集下载会失败。

## 本地规则集和现有仓库内容的对应关系

脚本会把 `providers/*.yaml` 转成 sing-box source rule-set v4，当前模板已经直接引用了这些规则：

- `adult`
- `copilot`
- `github-copilot`
- `cursor-direct`
- `google-cn`
- `local-area-network`
- `programmer`
- `steam-cn`
- `unban`

如果你后续更新了 `providers/*.yaml`，重新执行：

```bash
python3 tools/generate_sing_rule_sets.py
```

即可刷新 `sing-rule-set/*.json`。

## 路由思路

模板默认策略大致如下：

- 局域网 / 国内域名 / 国内 IP：`direct`
- Cursor / GoogleCN / SteamCN / UnBan：`direct`
- 程序员规则 / Copilot / GitHub Copilot：`dev`
- AI 站点：`ai`
- 成人站点：`adult-proxy`
- 其他国外域名：`proxy`
- 未命中流量：`final`

其中 `final` 默认优先 `direct`，你可以按自己的需求改成默认走代理。

## DNS 说明

这份模板的 DNS 使用的是 sing-box 1.13 的新结构：

- `dns_local`：`type: "local"`
- `dns_remote`：`type: "https"`，通过 `proxy` 走 Cloudflare DoH

这和 Clash 常见的：

- `listen: :1053`
- `nameserver:`
- `fallback:`

不是一套配置模型，所以不要直接照搬旧 Clash 模板字段。

如果你后面要做 TUN 透明代理，再额外补：

- `tun` 入站
- `protocol: "dns"` + `action: "hijack-dns"` 路由规则

会更完整。
