import 'package:shared_preferences/shared_preferences.dart';

/// Minimal key-value storage for user preferences. Reads are synchronous
/// (values are cached at startup) so the first frame already uses them.
abstract interface class SettingsStore {
  String? getString(String key);
  Future<void> setString(String key, String value);
}

/// [SettingsStore] backed by shared_preferences. Create with [open] before
/// `runApp`.
class SharedPreferencesSettingsStore implements SettingsStore {
  SharedPreferencesSettingsStore._(this._prefs);

  final SharedPreferencesWithCache _prefs;

  /// Keys this app stores. The cache only loads allow-listed keys.
  static const themeModeKey = 'theme_mode';

  static Future<SharedPreferencesSettingsStore> open() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: {themeModeKey},
      ),
    );
    return SharedPreferencesSettingsStore._(prefs);
  }

  @override
  String? getString(String key) => _prefs.getString(key);

  @override
  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);
}

/// In-memory [SettingsStore] for tests and previews.
class InMemorySettingsStore implements SettingsStore {
  InMemorySettingsStore([Map<String, String>? values]) : values = values ?? {};

  final Map<String, String> values;

  @override
  String? getString(String key) => values[key];

  @override
  Future<void> setString(String key, String value) async => values[key] = value;
}
