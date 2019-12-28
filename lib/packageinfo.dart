import 'package:package_info/package_info.dart';

PackageInfo packageInfo;

Future<void> initPackageInfo() async {
  packageInfo = await PackageInfo.fromPlatform();
}
