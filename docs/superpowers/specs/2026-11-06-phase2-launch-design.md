# Phase 2 — 日新/Renew AGC 上架 设计

Date: 2026-11-06
Status: draft, pending approval
Sources: `docs/superpowers/specs/2026-11-05-harmonyos-port-design.md`(Phase-2 backlog)、`docs/superpowers/specs/2026-11-05-commercialization-gplv3-design.md`(§2/§3/§4/§5)

## Intent

把已在上游 Streak(GPLv3)基础上完成鸿蒙移植的应用,以新品牌 日新/Renew、bundle id com.rixin.app、免费上架华为 AGC。Phase 2 = 从"核心功能可用"走到"可提审上架"。

## Decisions already made (user, 2026-11-06)

- **最小上架线**:提审前只做 M1–M5;local_auth、gal、服务卡片 → 上线后首个更新
- **bundle id = com.rixin.app**(AGC 建应用/签名 profile/商店链接锚点,上架后不可改)
- **图标:用户提供的完整分层图标集**(app-icons/,镜像 ohos/ 布局 drop-in;1024² 母版:AppScope foreground/background/app_icon_single + layered json 定义 + entry icon/startWindowIcon + preview 掩码图/闪屏)
- 通知 = **全量对齐 Android 现有行为**(点亮现有系统,非重写):9 处 zonedSchedule 调用点、权限流程、提醒 UI 全部恢复
- 显示名 zh=日新 / en=Renew
- GPL 署名 fork URL:建仓时填真实地址
- **提审前建公开仓**(GitHub + Gitee 镜像;隐私政策 URL 挂 Gitee,境内可达)——修订 ledger Ruling 13:建仓从"上线"提前到"提审";CI Android 编译证明仍推迟到上传时
- **l10n 品牌串全量替换**:用户可见品牌串 Streak→日新/Renew(zh=日新、en=Renew、其余 locale 机械替换+逐条人审;精确区分品牌 "Streak" 与普通名词 "streak" 连击)
- 真机:5ZFYD25B20000755(HarmonyOS NEXT,Phase 1 验收同机)

## Goals

1. 提醒系统真机达到 Android 对齐:创建/编辑/删除提醒、精确触发、权限被拒降级、改系统时区后仍正确触发
2. `flutter build hap --release` + hvigor assembleApp 产出上架格式 `.app`,用 AGC 发布证书签名
3. 包体显示 日新/Renew,无 Streak 品牌残留(标题/关于页/图标/显示名)
4. GPLv3 合规三件套:README fork 声明、about_page 双署名、上架 tag 可复现
5. AGC 提审材料齐备:隐私政策、应用介绍(zh/en)、权限说明、截图指引

## Non-goals (上线后首个更新)

local_auth、gal(含 triage #20 间距)、服务卡片(商业化设计 §5 明确不做)、zh-locale cosmetics(#16)、todos bisect(#17)、fork 上游贡献(#14)

## Anti-goals

ArkTS 重写;收费/IAP;企业开发者账号;iOS

## Module specs

### M1 通知 + IANA 时区(最大模块,含实测前置)

事实基础:提醒系统是现成的(9 处 zonedSchedule,notification_service.dart:531-1037),Phase-1 整体关闭在 ohos;时区名来自 flutter_timezone(ohos 无 adapter)。SIG flutter_local_notifications adapter 存在(gitcode),但 zonedSchedule 在本 fork 构建上未实测。

1. **Spike(真机,先行)**:最小调用验证 zonedSchedule 在 fork 3.35.8-ohos 触发真机通知;同时测 ohos 时区获取两条候选路径(DateTime.timeZoneName 是否已给 IANA;i18n 系统 API 经 MethodChannel 返回 IANA 名)。产出记录进 notes.md;失败则本设计回炉
2. **时区桥接**:按 spike 结论实现 IANA 名获取,只替换 flutter_timezone 在 ohos 的职责,其他平台不动
3. **点亮通知**:解除 Phase-1 的通知 init/hasReminders 关闭;权限流程(requestPermission + 被拒降级 + 设置页引导);9 调用点逐一真机验证
4. **提醒 UI 恢复**:解除 habit_form_page 三处 if (hasReminders) 门(236e8fc 引入);ohos 旧提醒记录随之重新可见(triage #22 关闭)
5. 验证:真机创建提醒→触发→权限拒绝→重授权→改系统时区后仍正确触发

### M2 改版 日新/Renew

触及点(§3 清单 verbatim,文件已存在):
- `ohos/AppScope/app.json5` bundleName → com.rixin.app
- 显示名 string.json ×5(AppScope/base + entry/{base,en_US,zh_CN})
- 图标:用户已提供完整集(app-icons/ 镜像 ohos/ 布局 drop-in):AppScope foreground.png + background.png + app_icon.json(.json5) + app_icon_single.png → ohos/AppScope/resources/base/media/;entry icon.png + startWindowIcon.png → ohos/entry/src/main/resources/base/media/;preview/ 目录不入库(可选资产)。现役目标位为 114×114,新图为 1024²——分层图标用大母版是标准做法;entry icon.png 的接收尺寸由构建+真机安装验证
- 应用内标题/关于页文案 → 日新/Renew;共享 l10n arb(lib/l10n/*.arb)用户可见品牌串全量替换(按上述决策;Android 应用内文案随之变更——桌面名不动,本仓不发 Android;上游同步面变大,见风险表)
- pubspec.yaml `name:` 保留(Dart 包名不外显)

### M3 GPL 合规(§2 verbatim)

- README 顶部 fork 声明(基于 InlitX/streak GPLv3,chenbf 鸿蒙适配,注明修改年份)
- about_page.dart:保留 "Original: InlitX" + 追加 "HarmonyOS adaptation: chenbf — <fork-url 占位>";保留 LICENSE 入口(about_page.dart:241)
- LICENSE 原样;源码头版权行不动;Weblate 译者文件保留
- 推送纪律沿用:永不 git add -A;签名块只在本地(备份 D:\ohos-tmp);推送前 git status 只剩这一个有意修改

### M4 Release 签名 + .app(**阻塞**:用户侧 AGC 发布证书到位后才可开工)

- ohos/build-profile.json5 release signingConfig(本地保留,提交剥离纪律)
- flutter build hap --release 通过;hvigor assembleApp --mode module -p product=default -p buildMode=release 产出 .app 路径记录进 notes.md
- Release 包体积记录(debug 176MB 无参考价值);R8/混淆对 fork 适用性确认(仅确认,不强制启用)

### M5 AGC 素材草稿

- 隐私政策:数据全本地(Hive,文档目录),仅 INTERNET + POST_NOTIFICATIONS 权限,无账号/无统计;文本很短,**托管在建仓后的 Gitee 镜像**(境内可达;提审前必须可访问)
- 应用介绍 zh+en 草稿;权限说明(含 POST_NOTIFICATIONS,通知落地后补);分类(效率);年龄分级建议
- 截图:真机 1320×2760 用户侧拍摄(4–5 张),列出 shot list

## User-side critical path(P0,今天,与本计划并行)

**CNIPA 商标精查(人工,中国商标网验证码;先于备案——备案携带"日新"名称,后翻 = 重走备案)** → 华为开发者注册 + 个人实名(1–2 工作日)→ AGC 创建应用(com.rixin.app)→ 生成发布证书(.cer/.p7b/.p12)→ **ICP App 备案提交(1–2 周,全项目最长钟)**;提审前:建公开仓 + Gitee 镜像 + 隐私政策页上线。M4 阻塞在证书节点;提审阻塞在备案通过。

## Risks

| 风险 | 缓解 |
|---|---|
| SIG adapter zonedSchedule 不工作或行为差异 | M1 spike 先行,失败即回炉设计,不烧任务 |
| 时区源不可用(timeZoneName 非 IANA) | spike 同时测 MethodChannel + i18n 备选路径 |
| 备案审核超期 | 用户侧今天就提交;功能线并行不等待 |
| 改 bundle id 后旧签名 profile 失效 | 新 id 申请新 profile;旧 debug 签名仅 Phase-1 遗留 |
| 改版后 Android 桌面显示名联动 | 本期只动 ohos string.json,Android strings 不碰 |
| 图标初版观感不足 | 提审不卡图标质量;上线后可换(无需重建 AGC 应用) |
| l10n 替换误伤普通名词 streak(连击) | 机械替换仅限精确大小写 "Streak",diff 逐条人审 |
| Android 应用内文案随 arb 变更(桌面名不变) | 本仓不发 Android;记为接受成本,上游同步时再对齐 |

## Left to the builder (spike answers)

- zonedSchedule 触发行为 + 权限模型实际表现(fork 构建)
- ohos IANA 时区源最终路径
- assembleApp 产出路径与 .app 结构验证
