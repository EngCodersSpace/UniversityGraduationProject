
import 'user_agent_plugin_platform_interface.dart';

class UserAgentPlugin {
  Future<String?> getPlatformVersion() {
    return UserAgentPluginPlatform.instance.getPlatformVersion();
  }
}
