# My_ACL4SSR

规则与底稿：`my_rules.ini` + `GeneralClashConfig.yml`（`clash_rule_base`）。**节点不写在底稿里**，必须用「订阅合并」把机场链接和规则一起转换。

## 为什么会出现「没有 proxies」

只导入 `GeneralClashConfig.yml` 的 raw 链接时，**没有任何机场订阅参与合并**，`proxies` 只能是空数组。解决方式：**始终用带 `url=`（节点订阅）的转换链接**，或 OpenClash 里同时配置「规则订阅 + 节点订阅」再合并。

## 做法一：在线订阅转换（推荐）

1. 把你的**机场订阅链接**做 **Base64**（UTF-8）。PowerShell 示例：

   ```powershell
   [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("https://你的机场订阅地址"))
   ```

2. 使用支持你站点的 **subconverter 类 API**（示例域名请换成你实际在用的）：

   ```text
   https://<你的转换服务>/sub?target=clash&new_name=true&url=<上一步Base64>&config=https://raw.githubusercontent.com/jackadam1981/My_ACL4SSR/main/my_rules.ini
   ```

   - `url=`：机场订阅（Base64）  
   - `config=`：本仓库 **`my_rules.ini`**（内含 `clash_rule_base` 指向 `GeneralClashConfig.yml`）  

3. 把整条转换后的 **https 链接**填进 Clash / OpenClash / Meta Android 的「订阅地址」。

4. 更新订阅后，在生成的配置里应能看到 **`proxies` 有节点**。

若你用的 API 参数名不是 `config`，按该站文档改成 `remote_config` 等对应字段。

## 做法二：仓库内脚本生成链接

在仓库根目录执行（把机场地址换成你的）：

```powershell
powershell -NoProfile -File .\scripts\build-subscription-link.ps1 -SubscriptionUrl "https://你的机场订阅"
```

奈飞模板规则：

```powershell
powershell -NoProfile -File .\scripts\build-subscription-link.ps1 -SubscriptionUrl "https://你的机场订阅" -ConfigIni "https://raw.githubusercontent.com/jackadam1981/My_ACL4SSR/main/my_rules_netflix.ini"
```

脚本会打印一条可粘贴的示例链接（默认转换域名为 `api.dler.io`，可按需改脚本内变量）。

## OpenClash

- 不要只把 `GeneralClashConfig.yml` 当唯一订阅。  
- 使用「**合并订阅**」或「**订阅转换后的完整链接**」（含 `url` + `config`）。  
- 路由器透明代理另见 `GeneralClashConfig.tun-openclash.yml` 覆写说明。

## 文件说明

| 文件 | 作用 |
|------|------|
| `my_rules.ini` | 主规则；`clash_rule_base` → `GeneralClashConfig.yml` |
| `my_rules_netflix.ini` | 与上游 `ACL4SSR_Online_Full_Netflix.ini` 等价，**已启用** `clash_rule_base` 指向本仓库底稿（勿改子模块 `ACL4SSR/...` 里被注释的那行） |
| `GeneralClashConfig.yml` | Meta 通用底稿（含 `proxies: []` 占位） |
| `GeneralClashConfig.tun-openclash.yml` | OpenClash 覆写（TUN / DNS 监听） |
| `GeneralClashConfig.android-overlay.yml` | Android 可选覆写 |

订阅转换里把 `config=` 换成 Netflix 版 raw 即可，例如：

`https://raw.githubusercontent.com/jackadam1981/My_ACL4SSR/main/my_rules_netflix.ini`
