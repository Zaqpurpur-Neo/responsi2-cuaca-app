import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/location.dart';
import '../models/weather.dart';

class WeatherService {
  static const Duration _timeout = Duration(seconds: 10);

  // 1. Cari lokasi berdasarkan nama
  Future<List<Location>> searchLocations(String name) async {
    try {
      final uri = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
        'name': name,
        'count': '10',
        'language': 'id',
        'format': 'json',
      });

      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Jika key "results" tidak ada, kembalikan list kosong
        if (data['results'] != null) {
          return (data['results'] as List)
              .map((json) => Location.fromJson(json))
              .toList();
        }
        return [];
      } else {
        throw Exception('Gagal mencari lokasi: ${response.statusCode}');
      }
    } catch (e) {
      if (e is http.ClientException || e is FormatException) {
        throw Exception('Kesalahan jaringan atau format data tidak valid.');
      }
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // 2. Ambil data cuaca berdasarkan lokasi
  Future<WeatherData> getWeather(Location loc) async {
    try {
      final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
        'latitude': loc.latitude.toString(),
        'longitude': loc.longitude.toString(),
        'current': 'temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m',
        'daily': 'weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max',
        'timezone': 'auto',
        'forecast_days': '7',
        'format': 'json',
      });

      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherData.fromJson(data);
      } else {
        throw Exception('Gagal mengambil data cuaca: ${response.statusCode}');
      }
    } catch (e) {
      if (e is http.ClientException || e is FormatException) {
        throw Exception('Kesalahan jaringan atau format data tidak valid.');
      }
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
