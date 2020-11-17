import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:framework_plugin/framework_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('framework_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FrameworkPlugin.platformVersion, '42');
  });
}
