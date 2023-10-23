import 'package:glider_data/glider_data.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PackageRepository {
  const PackageRepository(
    this._sharedPreferencesService,
    this._packageInfo,
  );

  final SharedPreferencesService _sharedPreferencesService;
  final PackageInfo _packageInfo;

  String getVersion() => _packageInfo.version;

  Future<String?> getLastVersion() async =>
      _sharedPreferencesService.getLastVersion();

  Future<bool?> setLastVersion({required String value}) async =>
      _sharedPreferencesService.setLastVersion(value: value);
}
