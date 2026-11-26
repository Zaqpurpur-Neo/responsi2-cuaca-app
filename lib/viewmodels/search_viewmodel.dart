import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/location.dart';
import '../services/weather_service.dart';
import '../services/storage_service.dart';

enum SearchState { idle, loading, success, empty, error }

class SearchViewModel extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final StorageService _storageService = StorageService();

  SearchState _state = SearchState.idle;
  SearchState get state => _state;

  List<Location> _results = [];
  List<Location> get results => _results;

  List<Location> _history = [];
  List<Location> get history => _history;

  List<Location> _favorites = [];
  List<Location> get favorites => _favorites;

  Timer? _debounceTimer;

  // Muat data riwayat dan favorit dari storage saat pertama kali dibuka
  Future<void> init() async {
    _history = await _storageService.getHistory();
    _favorites = await _storageService.getFavorites();
    notifyListeners();
  }

  // Fungsi pencarian dengan debounce 500ms
  void search(String query) {
    // Batalkan timer sebelumnya jika pengguna masih mengetik
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    // Jika query kosong, kembali ke state idle dan kosongkan hasil
    if (query.trim().isEmpty) {
      _state = SearchState.idle;
      _results = [];
      notifyListeners();
      return;
    }

    // Mulai timer debounce
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      _state = SearchState.loading;
      notifyListeners();

      try {
        _results = await _weatherService.searchLocations(query);
        if (_results.isEmpty) {
          _state = SearchState.empty;
        } else {
          _state = SearchState.success;
        }
      } catch (e) {
        _state = SearchState.error;
        _results = [];
      }
      notifyListeners();
    });
  }

  // Tambah ke riwayat pencarian
  Future<void> addToHistory(Location location) async {
    await _storageService.addHistory(location);
    _history = await _storageService.getHistory(); // Refresh list lokal
    notifyListeners();
  }

  // Tambah/Hapus dari favorit
  Future<void> toggleFavorite(Location location) async {
    if (isFavorite(location)) {
      _favorites.removeWhere((loc) => loc.id == location.id);
    } else {
      _favorites.add(location);
    }
    await _storageService.saveFavorites(_favorites);
    notifyListeners();
  }

  // Cek apakah lokasi sudah difavoritkan
  bool isFavorite(Location location) {
    return _favorites.any((loc) => loc.id == location.id);
  }

  // Hapus semua riwayat
  Future<void> clearHistory() async {
    await _storageService.clearHistory();
    _history = [];
    notifyListeners();
  }

  // Bersihkan resource saat ViewModel dihancurkan
  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
