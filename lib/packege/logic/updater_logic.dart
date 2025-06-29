import 'dart:convert';
import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:updater/my_updater/model/updater_result.dart';

class UpdaterLogic {
  Future<UpdaterResult> updater({
    required String iosPath,
    required String androidPath,
  }) async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(seconds: 1),
      ),
    );
    await remoteConfig.fetchAndActivate();
    final values = await remoteConfig.getAll();
    final defaultValue = json.encode({
      "app_version": "0.0.1",
      "is_optional": true,
    });
    await remoteConfig.setDefaults({
      if (values[iosPath] == null) iosPath: defaultValue,
      if (values[androidPath] == null) androidPath: defaultValue,
    });

    final rmData = json.decode(
      values[Platform.isIOS ? iosPath : androidPath]?.asString() ?? "{}",
    );

    final currentVersion =
        int.tryParse((await getAppCurrentVesion()).replaceAll(".", "")) ?? 0;

    final rmVersion =
        int.tryParse(rmData["app_version"].replaceAll(".", "")) ?? 0;
    if (currentVersion < rmVersion) {
      return UpdaterResult(
        needUpdate: true,
        isOptional: rmData["is_optional"] ?? true,
      );
    }
    return UpdaterResult(
      needUpdate: true,
      isOptional: rmData["is_optional"] ?? false,
    );
  }

  Future<String> getAppCurrentVesion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    // String appName = packageInfo.appName;
    // String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    // String buildNumber = packageInfo.buildNumber;
    return version;
  }
}
