import 'package:flutter/foundation.dart';

import '../models/location.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';
import '../services/storage_service.dart';

// Enum untuk merepresentasikan state UI
enum ViewState { loading, success, error, empty }

class WeatherViewModel extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final StorageService _storageService = StorageService();

  ViewState _state = ViewState.loading;
  ViewState get state => _state;

  Location? _selectedLocation;
  Location? get selectedLocation => _selectedLocation;

  WeatherData? _data;
  WeatherData? get data => _data;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Inisialisasi: muat lokasi terakhir atau gunakan default (Semarang)
  Future<void> init() async {
    _state = ViewState.loading;
    notifyListeners();

    Location? lastLoc = await _storageService.getLastLocation();

    if (lastLoc == null) {
      // Default ke Semarang jika belum ada lokasi tersimpan
      _selectedLocation = Location(
        id: 0,
        name: 'Semarang',
        country: 'Indonesia',
        latitude: -6.9667,
        longitude: 110.4167,
      );
    } else {
      _selectedLocation = lastLoc;
    }

    await fetchWeather();
  }

  // Mengambil data cuaca dari API berdasarkan lokasi terpilih
  Future<void> fetchWeather() async {
    if (_selectedLocation == null) return;

    _state = ViewState.loading;
    notifyListeners();

    try {
      _data = await _weatherService.getWeather(_selectedLocation!);
      _state = ViewState.success;
      _errorMessage = null;
    } catch (e) {
      _state = ViewState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    }
    notifyListeners();
  }

  // Saat pengguna memilih lokasi baru
  Future<void> selectLocation(Location location) async {
    _selectedLocation = location;
    // Simpan ke storage agar diingat saat aplikasi dibuka lagi
    await _storageService.saveLastLocation(location);
    await fetchWeather();
  }

  // Untuk fitur pull-to-refresh
  Future<void> refresh() async {
    await fetchWeather();
  }
}
