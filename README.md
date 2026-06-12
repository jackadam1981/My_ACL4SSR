# My_ACL4SSR

FlareFlux 使用的订阅转换规则仓。仓库保持精简，只保存我们维护的 ini、Clash 底稿和少量自建补丁规则；公共规则集一律通过线上 raw 地址自动更新。

## 入口

- `my_rules.ini`：正式规则，生产订阅使用。
- `my_rules_test.ini`：测试规则，验证通过后再同步到正式规则。
- `GeneralClashConfig.yml`：Clash Meta 通用底稿，由 ini 中的 `clash_rule_base` 引用。
- `lists-used/cursor_direct.list`：自建 Cursor 直连补丁。
- `lists-used/adult.list`：自建成人内容补充规则。

## 订阅转换

使用支持 subconverter 外部配置的后端，把节点订阅和本仓 ini 组合成 Clash 配置：

```text
https://<转换后端>/sub?target=clash&url=<节点订阅>&config=https://raw.githubusercontent.com/jackadam1981/My_ACL4SSR/main/my_rules.ini
```

测试规则使用：

```text
https://<转换后端>/sub?target=clash&url=<节点订阅>&config=https://raw.githubusercontent.com/jackadam1981/My_ACL4SSR/main/my_rules_test.ini
```

`url=` 可以是原始订阅地址或后端要求的 Base64 订阅地址，按转换后端文档为准。

## 维护原则

- 不提交 ACL4SSR、cmliu/ACL4SSR 等上游规则仓镜像。
- 不提交公共规则集的本地副本；需要公共规则时在 ini 中引用线上 raw 地址。
- 自建补丁规则只放在 `lists-used/`，并由 ini 通过本仓 raw 地址引用。
- `my_rules.ini` 是正式入口，未经验证不要直接改；先改 `my_rules_test.ini` 做转换和真机测试。
- ChatGPT / Codex 由上游 `Copilot.list`、`AI.list`、`OpenAi.list` 命中 `🤖 AI自动` 分组；该分组使用 `https://chatgpt.com/` 做健康检查，避免通用 `gstatic` 测速选中会返回 403 的节点。

## FlareFlux 节点命名

FlareFlux 订阅节点名应包含 Cloudflare colo 短码，例如 `-HKG-`、`-SIN-`、`-SJC-`。规则会基于这些短码生成香港、台湾、新加坡、日本、韩国、美国、欧洲、其他地区等自动测速组。
