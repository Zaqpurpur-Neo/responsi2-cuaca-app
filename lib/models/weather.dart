class WeatherData {
  final CurrentWeather current;
  final List<DailyForecast> daily;

  WeatherData({required this.current, required this.daily});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final currentJson = json['current'] as Map<String, dynamic>;
    final dailyJson = json['daily'] as Map<String, dynamic>;

    // Open-Meteo mengembalikan data harian dalam bentuk array paralel
    final times = (dailyJson['time'] as List).map((e) => e.toString()).toList();
    final weatherCodes = (dailyJson['weather_code'] as List)
        .map((e) => (e as num).toInt())
        .toList();
    final tempMax = (dailyJson['temperature_2m_max'] as List)
        .map((e) => (e as num).toDouble())
        .toList();
    final tempMin = (dailyJson['temperature_2m_min'] as List)
        .map((e) => (e as num).toDouble())
        .toList();
    final precipProb = (dailyJson['precipitation_probability_max'] as List)
        .map((e) => (e as num).toInt())
        .toList();

    // Gabungkan array paralel menjadi list objek DailyForecast
    List<DailyForecast> dailyList = [];
    for (int i = 0; i < times.length; i++) {
      dailyList.add(
        DailyForecast(
          date: times[i],
          weatherCode: weatherCodes[i],
          tempMax: tempMax[i],
          tempMin: tempMin[i],
          precipitationProbabilityMax: precipProb[i],
        ),
      );
    }

    return WeatherData(
      current: CurrentWeather.fromJson(currentJson),
      daily: dailyList,
    );
  }
}

class CurrentWeather {
  final double temperature;
  final double apparentTemperature;
  final int humidity;
  final double precipitation;
  final int weatherCode;
  final double windSpeed;
  final bool isDay;

  CurrentWeather({
    required this.temperature,
    required this.apparentTemperature,
    required this.humidity,
    required this.precipitation,
    required this.weatherCode,
    required this.windSpeed,
    required this.isDay,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: (json['temperature_2m'] ?? 0.0).toDouble(),
      apparentTemperature: (json['apparent_temperature'] ?? 0.0).toDouble(),
      humidity: (json['relative_humidity_2m'] ?? 0).toInt(),
      precipitation: (json['precipitation'] ?? 0.0).toDouble(),
      weatherCode: (json['weather_code'] ?? 0).toInt(),
      windSpeed: (json['wind_speed_10m'] ?? 0.0).toDouble(),
      isDay: (json['is_day'] ?? 1).toInt() == 1,
    );
  }
}

class DailyForecast {
  final String date;
  final int weatherCode;
  final double tempMax;
  final double tempMin;
  final int precipitationProbabilityMax;

  DailyForecast({
    required this.date,
    required this.weatherCode,
    required this.tempMax,
    required this.tempMin,
    required this.precipitationProbabilityMax,
  });
}
