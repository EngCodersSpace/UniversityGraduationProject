import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'user_agent_plugin_method_channel.dart';

abstract class UserAgentPluginPlatform extends PlatformInterface {
  /// Constructs a UserAgentPluginPlatform.
  UserAgentPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static UserAgentPluginPlatform _instance = MethodChannelUserAgentPlugin();

  /// The default instance of [UserAgentPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelUserAgentPlugin].
  static UserAgentPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [UserAgentPluginPlatform] when
  /// they register themselves.
  static set instance(UserAgentPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
