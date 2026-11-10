
import { FlutterAbility, FlutterEngine, Log } from '@ohos/flutter_ohos';
import {
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult
} from '@ohos/flutter_ohos';
import { GeneratedPluginRegistrant } from '../plugins/GeneratedPluginRegistrant';
import TimezonePlugin from '../plugins/TimezonePlugin';
import { notificationManager } from '@kit.NotificationKit';
import { BusinessError } from '@ohos.base';
import common from '@ohos.app.ability.common';

const NOTIFICATION_PERMISSION_TAG: string = 'NotificationPermissionPlugin';
const NOTIFICATION_PERMISSION_CHANNEL: string = 'rixin/notification_permission';
const NOTIFICATION_PERMISSION_REQUEST: string = 'request';

class NotificationPermissionHandler implements MethodCallHandler {
  private readonly abilityContext: common.UIAbilityContext;

  constructor(abilityContext: common.UIAbilityContext) {
    this.abilityContext = abilityContext;
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    if (call.method !== NOTIFICATION_PERMISSION_REQUEST) {
      result.notImplemented();
      return;
    }
    notificationManager.requestEnableNotification(this.abilityContext).then(() => {
      result.success(notificationManager.isNotificationEnabledSync());
    }).catch((err: BusinessError) => {
      Log.e(NOTIFICATION_PERMISSION_TAG,
        'requestEnableNotification err: ' + JSON.stringify(err));
      result.success(false);
    });
  }
}

class NotificationPermissionPlugin implements FlutterPlugin {
  private channel: MethodChannel | null = null;
  private readonly abilityContext: common.UIAbilityContext;

  constructor(abilityContext: common.UIAbilityContext) {
    this.abilityContext = abilityContext;
  }

  getUniqueClassName(): string {
    return 'NotificationPermissionPlugin';
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), NOTIFICATION_PERMISSION_CHANNEL);
    this.channel.setMethodCallHandler(new NotificationPermissionHandler(this.abilityContext));
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null);
      this.channel = null;
    }
  }
}

export default class EntryAbility extends FlutterAbility {
  configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    GeneratedPluginRegistrant.registerWith(flutterEngine)
    flutterEngine.getPlugins()?.add(new TimezonePlugin())
    flutterEngine.getPlugins()?.add(new NotificationPermissionPlugin(this.context))
  }
}
