import 'package:flutter/material.dart';

class WeatherCodeUtils {
  // 1. Deskripsi Bahasa Indonesia berdasarkan WMO Code Open-Meteo
  static String getDescription(int code) {
    if (code == 0) return 'Cerah';
    if (code >= 1 && code <= 3) return 'Berawan';
    if (code >= 45 && code <= 48) return 'Berkabut';
    if (code >= 51 && code <= 55) return 'Gerimis';
    if (code >= 56 && code <= 57) return 'Gerimis Beku';
    if (code >= 61 && code <= 65) return 'Hujan';
    if (code >= 66 && code <= 67) return 'Hujan Beku';
    if (code >= 71 && code <= 77) return 'Salju';
    if (code >= 80 && code <= 82) return 'Hujan Lebat';
    if (code >= 95) return 'Badai Petir';
    if (code == 96 || code == 99) return 'Badai Petir dengan Hujan Es';
    return 'Tidak Diketahui';
  }

  // 2. Ikon Material yang sesuai
  static IconData getIcon(int code) {
    if (code == 0) return Icons.wb_sunny;
    if (code >= 1 && code <= 3) return Icons.cloud;
    if (code >= 45 && code <= 48) return Icons.foggy;
    if (code >= 51 && code <= 67) return Icons.grain; // Gerimis / Hujan
    if (code >= 71 && code <= 77) return Icons.ac_unit; // Salju
    if (code >= 80 && code <= 82) return Icons.water_drop; // Hujan lebat
    if (code >= 95) return Icons.flash_on; // Badai petir
    return Icons.help_outline;
  }

  // 3. Gradient Background (dari Langkah 2, disesuaikan)
  static LinearGradient getGradient(int weatherCode, bool isDay) {
    if (!isDay) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
      );
    }

    if (weatherCode == 0 || weatherCode == 1) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)], // Cerah
      );
    } else if (weatherCode >= 2 && weatherCode <= 48) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF8E9EAB), Color(0xFFEef2f3)], // Berawan/Kabut
      );
    } else if (weatherCode >= 51 && weatherCode <= 67) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF3A7BD5), Color(0xFF3A6073)], // Hujan
      );
    } else if (weatherCode >= 71 && weatherCode <= 77) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFE6DADA), Color(0xFF274046)], // Salju
      );
    } else if (weatherCode >= 80) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF232526), Color(0xFF414345)], // Badai
      );
    }

    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)], // Default
    );
  }
}
