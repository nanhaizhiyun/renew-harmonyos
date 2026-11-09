import {
  FlutterPlugin,
  FlutterPluginBinding,
  Log,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult
} from '@ohos/flutter_ohos';
import systemDateTime from '@ohos.systemDateTime';

const TAG: string = 'TimezonePlugin';
const CHANNEL_NAME: string = 'ohos_timezone';
const GET_LOCAL_TIMEZONE: string = 'getLocalTimezone';
const FALLBACK_TIMEZONE: string = 'UTC';
class TimezoneCallHandler implements MethodCallHandler {
  onMethodCall(call: MethodCall, result: MethodResult): void {
    if (call.method === GET_LOCAL_TIMEZONE) {
      try {
        result.success(systemDateTime.getTimezoneSync());
      } catch (e) {
        Log.e(TAG, 'getLocalTimezone err: ' + JSON.stringify(e));
        result.success(FALLBACK_TIMEZONE);
      }
      return;
    }
    result.notImplemented();
  }
}

export default class TimezonePlugin implements FlutterPlugin {
  private channel: MethodChannel | null = null;

  getUniqueClassName(): string {
    return 'TimezonePlugin';
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), CHANNEL_NAME);
    this.channel.setMethodCallHandler(new TimezoneCallHandler());
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null);
      this.channel = null;
    }
  }
}