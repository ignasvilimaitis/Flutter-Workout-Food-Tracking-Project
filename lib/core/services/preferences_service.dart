import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static final PreferencesService _instance = PreferencesService._internal();
  late SharedPreferencesWithCache _prefs;

  PreferencesService._internal();

  factory PreferencesService() {
    return _instance;
  }

  Future<void> init() async {
    _prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions()
    );
  }

  SharedPreferencesWithCache get prefs => _prefs;
}