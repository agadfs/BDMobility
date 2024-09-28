import 'package:flutter/services.dart';

class PowerSaveMode {
  static const platform = MethodChannel('com.app.bdmobility');

  static Future<bool> isPowerSaveModeEnabled() async {
    try {
      final bool result = await platform.invokeMethod('isPowerSaveModeEnabled');
      return result;
    } on PlatformException catch (e) {
      print("Failed to get power save mode: '${e.message}'.");
      return false;
    }
  }
}
