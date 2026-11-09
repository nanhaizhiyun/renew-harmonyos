import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

import 'app_dirs.dart';

const MethodChannel _ohosTimezoneChannel = MethodChannel('ohos_timezone');

/// Returns the platform IANA timezone identifier (e.g. "Asia/Shanghai").
///
/// On ohos, asks the native TimezonePlugin; any bridge failure (missing
/// plugin, platform error, empty or null reply) degrades to UTC with a
/// diagnostic instead of crashing startup. On all other platforms this
/// delegates to flutter_timezone, preserving the pre-T2 behavior of
/// NotificationService.initialize.
Future<String> getPlatformTimeZoneName() async {
  if (isOhos) {
    try {
      final String? name = await _ohosTimezoneChannel
          .invokeMethod<String>('getLocalTimezone');
      if (name == null || name.isEmpty) {
        debugPrint('ohos_timezone: empty reply; falling back to UTC');
        return 'UTC';
      }
      return name;
    } catch (error) {
      debugPrint('ohos_timezone: bridge failed ($error); falling back to UTC');
      return 'UTC';
    }
  }
  final info = await FlutterTimezone.getLocalTimezone();
  return info.identifier;
}
