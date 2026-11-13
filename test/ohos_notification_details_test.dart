import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak/services/notification_service.dart';
import 'package:streak/services/reminder_schedule.dart';

void main() {
  test('ohos reminder details use the high-level slot type without rebuild', () {
    const details = NotificationService.ohosReminderDetails;

    // On HarmonyOS NEXT the slot level defaults from the slot type (official
    // SlotType table): OTHER_TYPES maps to LEVEL_MIN — drawer-only, never a
    // banner — while SERVICE_INFORMATION maps to LEVEL_HIGH (banner + sound).
    // Apps cannot set a level via API, so the slot type is the only lever.
    // The plugin rebuilds an existing slot only on an update action, and that
    // rebuild can reset the user's per-category choices — the details must
    // never request a slot rebuild.
    expect(details.slotAction, OhosNotificationSlotAction.createIfNotExists);
    expect(details.slotType, OhosNotificationSlotType.SERVICE_INFORMATION);
  });

  test('ohos reminder quota budget stays inside the 30-reminder system cap', () {
    // reminderAgentManager rejects publishes past 30 valid reminders per app
    // (error 1700002) — the budget constants must stay well inside it so a
    // handful of habits plus todos and focus-end notices cannot exhaust it.
    expect(ReminderSchedule.ohosSlotsPerReminder, lessThan(30));
    expect(ReminderSchedule.ohosHourlyTotalCap, lessThan(30));

    // Hourly budget: the total across all days is capped, split per weekday,
    // and never divides by zero on an empty day list.
    expect(ReminderSchedule.hourlyCapFor(0, ohosQuota: true), 12);
    expect(ReminderSchedule.hourlyCapFor(1, ohosQuota: true), 12);
    expect(ReminderSchedule.hourlyCapFor(2, ohosQuota: true), 6);
    expect(ReminderSchedule.hourlyCapFor(3, ohosQuota: true), 4);
    expect(ReminderSchedule.hourlyCapFor(7, ohosQuota: true), 1);

    // Non-OHOS platforms keep the unbounded cap.
    expect(
      ReminderSchedule.hourlyCapFor(2, ohosQuota: false),
      ReminderSchedule.hourlyCap(2),
    );
  });
}
