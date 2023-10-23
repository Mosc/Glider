import 'package:glider_data/glider_data.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';

class PackageRepository {
  const PackageRepository(
    this._sharedPreferencesService,
    this._packageInfo,
  );

  final SharedPreferencesService _sharedPreferencesService;
  final PackageInfo _packageInfo;

  Version getVersion() => Version.parse(_packageInfo.version);

  Future<Version?> getLastVersion() async {
    final lastVersion = await _sharedPreferencesService.getLastVersion();
    return lastVersion != null ? Version.parse(lastVersion) : null;
  }

  Future<bool?> setLastVersion({required Version value}) async =>
      _sharedPreferencesService.setLastVersion(
        value: value.canonicalizedVersion,
      );
}
