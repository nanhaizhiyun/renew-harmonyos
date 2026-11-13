# Renew — AGC Listing Materials (English draft)

> **Status:** DRAFT, for pasting into the AGC console. `<angle-bracket>` items are placeholders to replace before submission.
> **Dependency:** reminder copy and the POST_NOTIFICATIONS declaration depend on the notification system landing (plan Task 3).

## Store fields

| Field | Content |
|---|---|
| App name | Renew |
| One-liner | Minimal habit tracker. Streaks at a glance. |
| Short description | Renew is an offline, open-source habit tracker: unlimited habits and streaks, a todo list, a focus timer, and statistics. No ads, no subscriptions, no accounts — everything stays on your phone. |

## Full description (paste block)

```text
Minimal habit tracker. Streaks at a glance.

Renew is a free, open-source, fully offline habit tracker: it turns the things you want to keep doing into a natural part of every day, and makes every bit of persistence visible.

[Core features]
• Habit check-ins: create as many as you like — one tap marks today done
• Streaks: watch unbroken days grow, day by day
• Categories: colors and categories keep habits organized
• Habit notes: jot down a line about any day
• Todo list: capture what needs doing today
• Focus timer: set aside time for one thing
• Statistics: streak curves and charts make progress easy to see
• Local reminders: on-device notifications, no internet needed
• Backup & export: one-tap zip / JSON export — your data always leaves with you

[Privacy]
• No accounts, no sign-up, no cloud
• No ads, no subscriptions, no locked features
• Everything stays on your device
• Open source: the code is public (GPLv3)

A HarmonyOS adaptation of the open-source project Streak.
```

## Keywords

habit tracker, streak, daily habits, todo list, focus timer, offline, no ads, open source, privacy

## Category & rating

- **Category suggestion:** Efficiency
- **Age rating suggestion:** All ages (lowest tier). Questionnaire points: no violence, no adult content, no user-generated content or social features, no gambling, no in-app purchases, no ads. A pure utility app with no rating-sensitive content.
- **Version:** versionName 1.0.0 / versionCode 18 — taken from `pubspec.yaml` (`version: 1.0.0+18`), which is the source of truth. Stamping is automatic: every `flutter build hap`/`build app` writes the version into `ohos/local.properties`, and the flutter-hvigor plugin injects it into the packaged `app.json5` in memory — the placeholder in the source `ohos/AppScope/app.json5` (1000000 / 1.0.0) never reaches the package. Verified on the debug build: hap `pack.info` = `{"code":18,"name":"1.0.0"}`, device top-level BundleInfo = 18 / 1.0.0. Red line: build via the flutter tool only — a DevEco Studio or raw-hvigor build would bake in the placeholder. Verify the release install via `hdc shell bm dump -n com.rixin.app` top-level fields (Task 7).

## Permission declarations

| Permission | Justification |
|---|---|
| `ohos.permission.INTERNET` | Normal install-time permission required by the app runtime. The app is fully offline and transmits no user data. |
| `ohos.permission.POST_NOTIFICATIONS` | Local reminder notifications (scheduled on-device, never pass through a server, never used for marketing). |

## Privacy policy

- **Privacy policy URL:** `<PRIVACY-POLICY-URL>` (hosting to be decided: GitHub Pages or a Gitee mirror, reachable from mainland; must be live before submission)
- **Privacy contact:** `<PRIVACY-CONTACT>` (developer email)

## Pre-submit checklist

- [x] Repo URL placeholder replaced → https://github.com/nanhaizhiyun/renew-harmonyos
- [ ] `<PRIVACY-POLICY-URL>` (after hosting; must be reachable before submission) and `<PRIVACY-CONTACT>` pasted at submit time
- [ ] Reminder copy kept (notification system shipped in-build via 3249410+2824bad); verify end-to-end firing on the AGC release channel
- [x] Screenshots ready (store-screenshots toolchain, 8 × 1920×1080 per language); AGC upload-page size validation governs
- [ ] Version matches `pubspec.yaml` (1.0.0+18): on the release install, `hdc shell bm dump -n com.rixin.app` top-level `versionCode: 18` / `versionName: 1.0.0` (the 0/"" pairs inside the `appQuickFix` node are patch metadata, always zero — not the version)
- [x] Share link swapped in all 18 arb locales → https://github.com/InlitX/streak (2026-11-13: in-app source/share links point upstream Streak; the repo URL above = the fork, where the GPL source offer for this binary lives)
- [ ] (Optional) `lib/app/startup_failure.dart` feedback URL points to upstream issues — consider pointing it at the fork tracker at submission
