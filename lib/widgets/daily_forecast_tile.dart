import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/weather.dart';
import '../utils/weather_code.dart';

class DailyForecastTile extends StatelessWidget {
  final DailyForecast forecast;
  final bool isToday;

  const DailyForecastTile({
    super.key,
    required this.forecast,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // Format nama hari dalam Bahasa Indonesia (contoh: "Senin")
    final dayName = isToday
        ? 'Hari ini'
        : DateFormat('EEEE', 'id_ID').format(DateTime.parse(forecast.date));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Nama hari (lebar tetap agar rapi)
          SizedBox(
            width: 90,
            child: Text(
              dayName,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          // Ikon cuaca
          Icon(
            WeatherCodeUtils.getIcon(forecast.weatherCode),
            color: colorScheme.primary,
            size: 28,
          ),
          const SizedBox(width: 12),
          // Peluang hujan
          Row(
            children: [
              Icon(Icons.water_drop, size: 16, color: colorScheme.primary),
              const SizedBox(width: 4),
              Text(
                '${forecast.precipitationProbabilityMax}%',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const Spacer(),
          // Suhu min - max
          Text(
            '${forecast.tempMin.round()}° / ${forecast.tempMax.round()}°',
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
