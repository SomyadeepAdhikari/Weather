class CurrentWeather {
  final double tempK;
  final double feelsLikeK;
  final String condition;
  final int humidity;
  final double wind;
  final int pressure;
  final DateTime sunrise;
  final DateTime sunset;
  final int timezoneOffsetSec;
  CurrentWeather({
    required this.tempK,
    required this.feelsLikeK,
    required this.condition,
    required this.humidity,
    required this.wind,
    required this.pressure,
    required this.sunrise,
    required this.sunset,
    required this.timezoneOffsetSec,
  });
}

class HourlyPoint {
  final DateTime time;
  final double tempK;
  final String condition;
  HourlyPoint({required this.time, required this.tempK, required this.condition});
}

class DailyPoint {
  final DateTime day;
  final double minK;
  final double maxK;
  final String condition;
  DailyPoint({required this.day, required this.minK, required this.maxK, required this.condition});
}

class CitySnapshot {
  final String name;
  final CurrentWeather current;
  CitySnapshot({required this.name, required this.current});
}
