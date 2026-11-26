import 'package:flutter/material.dart';

import '../models/weather.dart';
import '../utils/weather_code.dart';

class WeatherHeroCard extends StatelessWidget {
  final CurrentWeather current;

  const WeatherHeroCard({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    // Gradient berubah sesuai cuaca & siang/malam
    final gradient = WeatherCodeUtils.getGradient(
      current.weatherCode,
      current.isDay,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ikon cuaca besar
          Icon(
            WeatherCodeUtils.getIcon(current.weatherCode),
            size: 64,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          // Suhu sangat besar & tipis
          Text(
            '${current.temperature.round()}°',
            style: Theme.of(context).textTheme.displayLarge
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 4),
          // Deskripsi kondisi cuaca
          Text(
            WeatherCodeUtils.getDescription(current.weatherCode),
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          // "Terasa seperti xx°"
          Text(
            'Terasa seperti ${current.apparentTemperature.round()}°',
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(color: Colors.white.withOpacity(0.9)),
          ),
        ],
      ),
    );
  }
}
