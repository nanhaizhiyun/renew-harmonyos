# Renew — AGC Listing Materials (English draft)

> **Status:** DRAFT, for pasting into the AGC console. `<angle-bracket>` items are placeholders to replace before submission.
> **Dependency:** reminder copy and the POST_NOTIFICATIONS declaration depend on the notification system landing (plan Task 3).

## Store fields

| Field | Content |
|---|---|
| App name | Renew |
| One-liner | Small daily check-ins that turn into habits you keep. |
| Short description | Renew is an offline, open-source habit tracker: unlimited habits and streaks, a todo list, a focus timer, and statistics. No ads, no subscriptions, no accounts — everything stays on your phone. |

## Full description (paste block)

```text
Small daily check-ins that turn into habits you keep.

Renew is a free, open-source, fully offline habit tracker that helps you turn the things you want to keep doing into a natural part of every day.

[Core features]
• Habits & streaks: create as many as you want, watch streaks grow day by day
• Categories: organize habits with colors and categories
• Habit notes: jot down a line about any day
• Todo list: capture what needs doing today
• Focus timer: set aside time for one thing
• Statistics: charts and streak curves make persistence visible
• Local reminders: on-device notifications, no internet needed
• Backup & export: one-tap zip / JSON export, your data always leaves with you

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
- **Version:** versionName 2.6.0 / versionCode 17 — taken from `pubspec.yaml` (`version: 2.6.0+17`), which is the source of truth for the store listing. `ohos/AppScope/app.json5` still carries placeholder values (1.0.0 / 1000000) and is NOT authoritative; verify the release build via `hdc shell bm dump -n com.rixin.app` before submission (Task 7).

## Permission declarations

| Permission | Justification |
|---|---|
| `ohos.permission.INTERNET` | Normal install-time permission required by the app runtime. The app is fully offline and transmits no user data. |
| `ohos.permission.POST_NOTIFICATIONS` | Local reminder notifications (scheduled on-device, never pass through a server, never used for marketing). |

## Privacy policy & filing

- **Privacy policy URL:** `<PRIVACY-POLICY-URL>` (hosted on the Gitee mirror once the public repo exists; must be reachable before submission)
- **ICP filing number:** `<ICP-BEIAN>` (fill in after the filing is approved)

## Pre-submit checklist

- [ ] Placeholders `<FORK-URL>`, `<PRIVACY-POLICY-URL>`, `<ICP-BEIAN>` replaced
- [ ] Reminder copy depends on Task 3 (notifications) landing; if the submitted build lacks reminders, drop the "Local reminders" bullet and declare INTERNET only
- [ ] Screenshots taken per `screenshot-shotlist.md` (1320×2760, 4–5 shots)
- [ ] Version matches `pubspec.yaml` (2.6.0+17), confirmed on the release build via `hdc shell bm dump -n com.rixin.app`
