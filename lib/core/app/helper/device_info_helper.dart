import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoHelper {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  DeviceInfoHelper._();

  static final DeviceInfoHelper of = DeviceInfoHelper._();

  Future<BaseDeviceInfo> getDeviceInfo() async => await _deviceInfoPlugin.deviceInfo;
  Future<AndroidDeviceInfo> getAndroidDeviceInfo() async => await _deviceInfoPlugin.androidInfo;
  Future<IosDeviceInfo> getIOSDeviceInfo() async => await _deviceInfoPlugin.iosInfo;

  void check() async {
    var result = await getAndroidDeviceInfo();
    result.version.sdkInt;
  }

  // THIS ONLY FOR ANDROID DEVICES
  Future<bool> get isBelow13  async {
    var result = await getAndroidDeviceInfo();
    return (result.version.sdkInt < 33);
  }
}