# Phase 2 AGC 上架 实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to dispatch/execute task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

## Global Constraints

- Suite 基线 `+547 ~2 -2`(Ruling 7:exit=1 正常,2 个 todos_page 环境性失败是已接受基线);每个代码任务收尾以精确计数对比
- 真机 5ZFYD25B20000755(HarmonyOS NEXT),**禁用模拟器**
- flutter/hvigor/hdc 经 `scripts/ohos_env.ps1`(先 dot-source;禁用 `2>nul` 类吞错重定向)
- **永不提交** `ohos/build-profile.json5`(本地签名块);**永不 `git add -A`**,只加具名文件
- 共享 arb 改动影响 Android 应用内文案(接受成本已记录);Android 桌面名/strings 资源不碰
- l10n 品牌替换只动精确大小写 "Streak";普通名词 "streak"(连击)不碰
- fork URL 占位符统一 `<FORK-URL>`(建仓时一次性全局替换)
- AGC/证书/备案是用户侧动作,任务里只做本地能做的部分

## Review Focus

1. 时区桥接失败必须降级(UTC + 可诊断上报),不得崩溃(tz.getLocation 非 IANA 名会 throw)
2. 通知权限被拒:提醒功能照常,列表页条幅提示,无权限弹窗环
3. 改系统时区后已排定提醒仍正确触发,不重不漏
4. 品牌替换不得误伤普通名词 streak;diff 人审,suite 计数持平
5. 图标 drop-in 后:启动器=日新/新图标,构建+真机安装通过

## Task 1: 通知+时区真机 spike(throwaway)

**Files:** 临时探针(main.dart + 最小 ArkTS 探针),Throwaway
**Interfaces:** Produces: spike 证据入 notes.md,供 Task 2/3 消费
**Model: sonnet**(真机调试判断型)

- [ ] Step 1: `hdc list targets` 见 5ZFYD25B20000755;未连接停下报告(不换模拟器)
- [ ] Step 2: 探针:启动时 zonedSchedule 一次性通知(2 分钟后)经 SIG adapter;hilog 打 DateTime.timeZoneName;若非 IANA,加最小 MethodChannel 读 ArkTS i18n 时区 API(spike 现场确认,不臆测 API)
- [ ] Step 3: 真机证据:安装→等触发→hilog 捕获通知到达 + timeZoneName 值(+ channel 返回值);证据写入 notes.md
- [ ] Step 4: 移除探针;suite 复跑确认 `+547 ~2 -2` 没动;commit 仅 notes.md: `docs(ohos): notification+timezone spike evidence (probe removed)`

## Task 2: 时区桥接

**Files:** Create `lib/core/utils/ohos_timezone.dart`;Modify `lib/services/notification_service.dart`
**Interfaces:** Produces `Future<String> getPlatformTimeZoneName()`(ohos 按 spike 结论;非 ohos 走 flutter_timezone 原路径)
**Model: sonnet**

- [ ] 先写红测试:桥接异常 → 降级路径返回 UTC 回退并带可诊断信息(不崩)
- [ ] 实现 `getPlatformTimeZoneName()`:ohos 分支按 spike 结论取 IANA 名;异常捕获 → 降级;非 ohos 委托 flutter_timezone
- [ ] notification_service.dart 改调 getPlatformTimeZoneName() 替换 flutter_timezone 直调点
- [ ] suite 精确计数持平;commit: `feat(ohos): bridge IANA timezone for notifications on ohos`

## Task 3: 点亮通知系统(解 Phase-1 门 + 权限流程)

**Files:** Modify `lib/core/utils/app_dirs.dart`(hasReminders ohos→true)、`lib/services/notification_service.dart`(init/permission 门)、`lib/main.dart`(init 门)
**Interfaces:** Consumes Task 2 桥接;Produces ohos 完整提醒流
**Model: sonnet**

- [ ] Step 1: 清单先行——`git show c6fb482 --stat` + grep hasReminders/通知门,关闭点清单落 ledger,再动手
- [ ] 先改测试:app_dirs_test 的 hasReminders 断言更新为 ohos→true(先红后翻)
- [ ] hasReminders ohos→true;init/permission 门逐一解除;权限流程(requestPermission + 被拒条幅 + 设置页引导)
- [ ] suite 精确计数持平;真机冒烟:创建提醒→触发;commit: `feat(ohos): enable notification system with permission flow on ohos`

## Task 4: 改版壳层(bundle id / 显示名 / 图标 drop-in)

**Files:** Modify `ohos/AppScope/app.json5`(bundleName → com.rixin.app);string.json ×5(显示名);图标 6 文件 drop-in(从 app-icons/ 镜像路径复制);`ohos/entry/src/main/resources/base/media/` 下旧 114² icon.png 替换
**Interfaces:** Produces 壳层品牌;AGC 建应用/新 profile 是用户侧并行动作(不阻塞本任务)
**Model: sonnet**(风险在构建链验证)

- [ ] Step 1: bundle id → com.rixin.app;5 处 string.json 显示名(base=日新,en_US=Renew,zh_CN=日新)
- [ ] Step 2: 图标 drop-in:app-icons/AppScope/... 4 文件 + app-icons/entry/... 2 文件按镜像路径复制到位;preview/ 不入库
- [ ] Step 3: 清旧产物(ohos build 目录 + 卸载旧包)后 `flutter build hap --debug` 通过
- [ ] Step 4: 真机安装:启动器显示 日新 + 新图标,启动窗正常;commit: `feat(ohos): rebrand shell to rixin/renew (id, names, icons)`

## Task 5: GPL 合规(README + 关于页)

**Files:** Modify `README.md`(顶部 fork 声明)、`lib/features/settings/pages/about_page.dart`(双署名 + 保留 LICENSE 入口 about_page.dart:241)
**Model: haiku**(机械编辑)

- [ ] README 顶部 fork 声明(基于 InlitX/streak GPLv3,chenbf 鸿蒙适配,修改年份 2026;fork URL 用 `<FORK-URL>`)
- [ ] about_page:保留 "Original: InlitX" 署名 + 追加 "HarmonyOS adaptation: chenbf — <FORK-URL>";LICENSE 入口不动
- [ ] suite 持平;commit: `docs: gplv3 compliance - fork declaration and about attribution`

## Task 6: l10n 品牌串全量替换

**Files:** Modify `lib/l10n/*.arb`(用户可见品牌串)
**Interfaces:** Produces 日新/Renew 文案(Task 3 点亮的通知文案同批生效)
**Model: sonnet**(误伤判定需判断)

- [ ] Step 1: 清单——grep 精确大小写 "Streak" 于 lib/l10n/*.arb,逐条列出(区分品牌串 vs 普通名词 streak),清单落 ledger
- [ ] Step 2: 替换:zh→日新,en→Renew,其余 locale→Renew;机械替换仅限精确 "Streak";diff 逐条人审
- [ ] Step 3: suite 复跑(品牌断言类测试预期更新为新名——刻意行为变更,更新断言);计数持平(允许刻意更新的断言数)
- [ ] Step 4: commit: `feat(l10n): rebrand user-visible brand strings to rixin/renew`

## Task 7: Release 签名 + .app(**阻塞**:用户侧 AGC 发布证书到位后)

**Files:** Modify `ohos/build-profile.json5`(本地,不提交)
**Model: sonnet**

- [ ] release signingConfig(证书路径/密码,本地保留);`flutter build hap --release` 通过
- [ ] hvigor assembleApp 产出 .app;路径与体积记录 notes.md;R8 适用性确认(仅确认)
- [ ] 本地验证后无 commit(签名块不提交);ledger 记录证据

## Task 8: AGC 素材草稿

**Files:** Create `docs/agc/privacy-policy.md`、`docs/agc/listing-zh.md` + `listing-en.md`、shot list
**Model: haiku**(文本草稿)

- [ ] 隐私政策(本地存储声明/权限/无统计);应用介绍 zh+en;权限说明(含 POST_NOTIFICATIONS);分类效率/年龄分级建议;真机截图 shot list(用户拍摄)
- [ ] commit: `docs(agc): draft privacy policy and store listing materials`

## Task 9: 建仓准备(提审前执行,当前占位)

- [ ] 建公开仓(GitHub)+ Gitee 镜像;`<FORK-URL>` 全局替换为真实地址(一次性 chore commit);隐私政策页上线
- 触发条件:进入提审窗口(备案通过后);当前不执行

## Self-Review

- Spec 覆盖:M1(spike/桥接/点亮/UI 恢复→T1-T3)、M2(T4+T6)、M3(T5)、M4(T7)、M5(T8)、建仓(T9)——全覆盖
- 类型一致:getPlatformTimeZoneName 签名 T2 定义/T3 消费一致;图标路径镜像映射一致
- 步骤可执行:每步=单动作+可查结果;真机步骤有 hdc/build 验证锚点
- Review Focus 五条各有任务承接:T2(1)、T3(2/3)、T6(4)、T4(5)
