import 'dart:core';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageKeys {
  static const live_kit_url = 'live_kit_url';
  static const user_email = 'user_email';
}

class VariableController extends GetxController {
  SharedPreferences? preferences;

  late String livekit_url;
  late String user_email;

  bool pause_i_am_online_loop = false;

  Future<void> initilizeFunction() async {
    preferences = await SharedPreferences.getInstance();

    livekit_url = preferences?.getString(LocalStorageKeys.live_kit_url) ??
        "https://livekit-test.ai-tools-online.xyz";
    user_email = preferences?.getString(LocalStorageKeys.user_email) ??
        "yingshaoxo@gmail.com";
  }

  Future<void> save_livekit_url(String? url) async {
    if (url != null && url != "") {
      this.livekit_url = url;
      await preferences?.setString(LocalStorageKeys.live_kit_url, url);
    }
  }

  Future<void> save_user_email(String? user_email) async {
    if (user_email != null && user_email != "") {
      this.user_email = user_email;
      await preferences?.setString(LocalStorageKeys.user_email, user_email);
    }
  }
}
