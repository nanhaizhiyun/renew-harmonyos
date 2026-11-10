# 日新 — AGC 上架材料（中文草稿）

> **状态：** DRAFT，供粘贴进 AGC 控制台。`<尖括号>` 为占位符，提审前替换。
> **依赖：** 提醒文案与 POST_NOTIFICATIONS 权限申报依赖通知系统落地（计划 Task 3）。

## 商店信息

| 字段 | 内容 |
|---|---|
| 应用名称 | 日新 |
| 推荐语（一句话） | 每天一点点坚持，慢慢养成习惯。 |
| 应用简介（短） | 日新是一款离线、开源的习惯追踪应用：习惯打卡、待办清单、专注计时、数据统计，功能无限量。无广告、无订阅、无账号，所有数据只保存在你的手机上。 |

## 完整介绍（粘贴块）

```text
每天一点点坚持，慢慢养成习惯。

日新（Renew）是一款免费、开源、完全离线的习惯追踪应用，帮你把想坚持的事变成每天的自然动作。

【核心功能】
• 习惯打卡：无限创建，连击一天天变长
• 分类整理：颜色与分类，让习惯井井有条
• 习惯笔记：为某一天写下一句话
• 待办清单：今天要做的事随手记
• 专注计时：留一段时间，只做一件事
• 数据统计：连击曲线与统计图表，坚持看得见
• 本地提醒：到点通知，离线照样提醒
• 备份导出：zip / JSON 一键导出，数据随时带走

【隐私承诺】
• 无账号、无注册、无云端
• 无广告、无订阅、无受限功能
• 所有数据仅保存在你的设备上
• 开源透明：代码公开可查（GPLv3）

基于开源项目 Streak 的鸿蒙适配版。
```

## 关键词

习惯打卡、习惯追踪、连击、待办清单、专注、统计、离线、无广告、开源、隐私

## 分类与分级

- **分类建议：** 效率（Efficiency）
- **年龄分级建议：** 全年龄（最低档）。问卷要点：无暴力、无成人内容、无用户生成内容／社交、无博彩、应用内无付费、无广告。
- **版本：** versionName 1.0.0 / versionCode 18 —— 取自 `pubspec.yaml`（`version: 1.0.0+18`），上架版本以此为准。版本注入全自动：每次 `flutter build hap`/`build app` 都会把版本写进 `ohos/local.properties`，再由 flutter-hvigor 插件在构建期注入打包用的 app.json5（内存态）——源文件 `ohos/AppScope/app.json5` 里的占位值（1000000 / 1.0.0）永远不会进包。已在 debug 构建实证：hap `pack.info` = `{"code":18,"name":"1.0.0"}`，设备顶层 BundleInfo = 18 / 1.0.0。红线：必须经 flutter 工具构建——用 DevEco Studio 或裸 hvigor 打包会把占位值烤进包里。提审前用 `hdc shell bm dump -n com.rixin.app` 核对发布安装的顶层字段（Task 7）。

## 权限申报理由

| 权限 | 理由 |
|---|---|
| `ohos.permission.INTERNET` | 运行框架所需普通权限（安装即授予）。应用完全离线，不传输用户数据。 |
| `ohos.permission.POST_NOTIFICATIONS` | 本地提醒通知（设备本地排定，不经过服务器，不用于营销）。 |

## 隐私政策

- **隐私政策 URL：** `<PRIVACY-POLICY-URL>`（托管方案后定：GitHub Pages 或 Gitee 镜像，境内可达；提审前必须可访问）
- **隐私联系方式：** `<PRIVACY-CONTACT>`（开发者邮箱）

## 发布前检查

- [x] 仓库 URL 占位符已替换 → https://github.com/nanhaizhiyun/renew-harmonyos
- [ ] `<PRIVACY-POLICY-URL>`（托管后填，提审前必须可访问）与 `<PRIVACY-CONTACT>` 提审粘贴时填入
- [ ] 提醒文案保留（通知系统已随 3249410+2824bad 落地构建）；AGC release 渠道验证端到端触发
- [x] 截图已备好（store-screenshots 工具链，zh/en 各 8 张 1920×1080）；以 AGC 上传页尺寸校验为准
- [ ] 版本号与 `pubspec.yaml`（1.0.0+18）一致：发布安装后 `hdc shell bm dump -n com.rixin.app` 顶层 `versionCode: 18` / `versionName: 1.0.0`（`appQuickFix` 节点内的 0/"" 是热修复元数据，恒为 0，不是版本字段）
- [x] 全部 18 个 arb 的分享链接已替换 → https://github.com/nanhaizhiyun/renew-harmonyos
- [ ] （可选）`lib/app/startup_failure.dart` 的反馈地址指向 upstream issues —— 提审时可换为 fork 仓库 issues
