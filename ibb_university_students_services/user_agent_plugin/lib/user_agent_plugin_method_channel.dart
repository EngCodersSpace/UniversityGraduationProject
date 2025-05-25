import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'user_agent_plugin_platform_interface.dart';

/// An implementation of [UserAgentPluginPlatform] that uses method channels.
class MethodChannelUserAgentPlugin extends UserAgentPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('user_agent_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
