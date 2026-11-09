import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak/core/utils/app_dirs.dart';
import 'package:streak/core/utils/ohos_timezone.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const ohosChannel = MethodChannel('ohos_timezone');
  const flutterTimezoneChannel = MethodChannel('flutter_timezone');

  tearDown(() {
    setOhosForTest(false);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(ohosChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(flutterTimezoneChannel, null);
  });

  test('ohos: bridge success returns IANA name', () async {
    setOhosForTest(true);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(ohosChannel, (call) async {
      expect(call.method, 'getLocalTimezone');
      return 'Asia/Shanghai';
    });
    expect(await getPlatformTimeZoneName(), 'Asia/Shanghai');
  });

  test('ohos: bridge PlatformException degrades to UTC', () async {
    setOhosForTest(true);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(ohosChannel, (call) async {
      throw PlatformException(code: 'tz_error', message: 'native read failed');
    });
    expect(await getPlatformTimeZoneName(), 'UTC');
  });

  test('ohos: missing plugin degrades to UTC', () async {
    setOhosForTest(true);
    expect(await getPlatformTimeZoneName(), 'UTC');
  });

  test('non-ohos: delegates to flutter_timezone', () async {
    setOhosForTest(false);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(flutterTimezoneChannel, (call) async {
      expect(call.method, 'getLocalTimezone');
      return 'Europe/Berlin';
    });
    expect(await getPlatformTimeZoneName(), 'Europe/Berlin');
  });
}
