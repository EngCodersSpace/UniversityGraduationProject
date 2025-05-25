import 'package:flutter_test/flutter_test.dart';
import 'package:user_agent_plugin/user_agent_plugin.dart';
import 'package:user_agent_plugin/user_agent_plugin_platform_interface.dart';
import 'package:user_agent_plugin/user_agent_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockUserAgentPluginPlatform
    with MockPlatformInterfaceMixin
    implements UserAgentPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final UserAgentPluginPlatform initialPlatform = UserAgentPluginPlatform.instance;

  test('$MethodChannelUserAgentPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelUserAgentPlugin>());
  });

  test('getPlatformVersion', () async {
    UserAgentPlugin userAgentPlugin = UserAgentPlugin();
    MockUserAgentPluginPlatform fakePlatform = MockUserAgentPluginPlatform();
    UserAgentPluginPlatform.instance = fakePlatform;

    expect(await userAgentPlugin.getPlatformVersion(), '42');
  });
}
