import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/location.dart';

class StorageService {
  // Kunci untuk menyimpan data di shared_preferences
  static const String _keyFavorites = 'favorites';
  static const String _keyHistory = 'history';
  static const String _keyLastLocation = 'last_location';

  // ==========================================
  // 1. Lokasi Terakhir (Last Location)
  // ==========================================

  /// Menyimpan lokasi terakhir yang dipilih pengguna
  Future<void> saveLastLocation(Location location) async {
    final prefs = await SharedPreferences.getInstance();
    // Simpan sebagai string JSON
    await prefs.setString(_keyLastLocation, jsonEncode(location.toJson()));
  }

  /// Mengambil lokasi terakhir. Mengembalikan null jika belum pernah disimpan.
  Future<Location?> getLastLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyLastLocation);

    if (jsonString != null) {
      // Decode JSON string kembali menjadi Map, lalu ke objek Location
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return Location.fromJson(jsonMap);
    }
    return null;
  }

  // ==========================================
  // 2. Riwayat Pencarian (History)
  // ==========================================

  /// Menambahkan lokasi ke riwayat.
  /// Aturan: Maksimal 10 item, tanpa duplikat, yang terbaru di posisi pertama (index 0).
  Future<void> addHistory(Location location) async {
    final prefs = await SharedPreferences.getInstance();
    final historyStrings = prefs.getStringList(_keyHistory) ?? [];

    // 1. Ubah string JSON kembali menjadi List<Location>
    List<Location> history = historyStrings
        .map((e) => Location.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .toList();

    // 2. Hapus jika lokasi dengan ID yang sama sudah ada (mencegah duplikat)
    history.removeWhere((loc) => loc.id == location.id);

    // 3. Tambahkan lokasi baru ke paling atas (index 0)
    history.insert(0, location);

    // 4. Batasi maksimal 10 item
    if (history.length > 10) {
      history = history.sublist(0, 10);
    }

    // 5. Simpan kembali sebagai List<String> JSON
    final newHistoryStrings = history
        .map((loc) => jsonEncode(loc.toJson()))
        .toList();
    await prefs.setStringList(_keyHistory, newHistoryStrings);
  }

  /// Mengambil seluruh riwayat pencarian
  Future<List<Location>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyStrings = prefs.getStringList(_keyHistory) ?? [];

    return historyStrings
        .map((e) => Location.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .toList();
  }

  /// Menghapus seluruh riwayat pencarian
  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyHistory);
  }

  // ==========================================
  // 3. Lokasi Favorit (Favorites)
  // ==========================================

  /// Menyimpan daftar lokasi favorit (menimpa data lama)
  Future<void> saveFavorites(List<Location> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final favStrings = favorites
        .map((loc) => jsonEncode(loc.toJson()))
        .toList();
    await prefs.setStringList(_keyFavorites, favStrings);
  }

  /// Mengambil daftar lokasi favorit
  Future<List<Location>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favStrings = prefs.getStringList(_keyFavorites) ?? [];

    return favStrings
        .map((e) => Location.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .toList();
  }
}
