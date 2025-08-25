import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../secrets.dart';
import '../models/weather_models.dart';

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) => WeatherRepository());

class WeatherRepository {
  final String _base = 'https://api.openweathermap.org/data/2.5';

  Future<(CurrentWeather, List<HourlyPoint>)> fetchCurrentAndHourly(String city) async {
    final url = Uri.parse('$_base/forecast?q=$city&APPID=$openWeatherApiKey');
    final res = await http.get(url);
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    if (map['cod'] != '200') {
      throw Exception(map['message']?.toString() ?? 'Failed');
    }
    final list = (map['list'] as List).cast<Map<String, dynamic>>();
    final first = list.first;
    final current = CurrentWeather(
      tempK: (first['main']['temp'] as num).toDouble(),
      condition: first['weather'][0]['main'].toString(),
      humidity: (first['main']['humidity'] as num).toInt(),
      wind: (first['wind']['speed'] as num).toDouble(),
      pressure: (first['main']['pressure'] as num).toInt(),
    );
    final hourly = list.take(8).map((e) => HourlyPoint(
          time: DateTime.parse(e['dt_txt'].toString()),
          tempK: (e['main']['temp'] as num).toDouble(),
          condition: e['weather'][0]['main'].toString(),
        ));
    return (current, hourly.toList());
  }

  Future<List<DailyPoint>> fetchDaily(String city) async {
    // Use 7-day via One Call 3.0 requires lat/lon; we approximate from forecast list groups by day
    final url = Uri.parse('$_base/forecast?q=$city&APPID=$openWeatherApiKey');
    final res = await http.get(url);
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    if (map['cod'] != '200') {
      throw Exception(map['message']?.toString() ?? 'Failed');
    }
    final list = (map['list'] as List).cast<Map<String, dynamic>>();
    final grouped = <DateTime, List<Map<String, dynamic>>>{};
    for (final e in list) {
      final dt = DateTime.parse(e['dt_txt'].toString());
      final key = DateTime(dt.year, dt.month, dt.day);
      grouped.putIfAbsent(key, () => []).add(e);
    }
    final days = grouped.entries.take(7).map((entry) {
      double min = double.infinity;
      double max = -double.infinity;
      String cond = 'Clear';
      for (final e in entry.value) {
        final t = (e['main']['temp'] as num).toDouble();
        if (t < min) min = t;
        if (t > max) max = t;
      }
      // pick midday condition if available
      final mid = entry.value[(entry.value.length / 2).floor()];
      cond = mid['weather'][0]['main'].toString();
      return DailyPoint(day: entry.key, minK: min, maxK: max, condition: cond);
    }).toList();
    days.sort((a, b) => a.day.compareTo(b.day));
    return days;
  }
}

final cityWeatherProvider = FutureProvider.family<(CurrentWeather, List<HourlyPoint>), String>((ref, city) async {
  final repo = ref.read(weatherRepositoryProvider);
  return repo.fetchCurrentAndHourly(city);
});

final cityDailyProvider = FutureProvider.family<List<DailyPoint>, String>((ref, city) async {
  final repo = ref.read(weatherRepositoryProvider);
  return repo.fetchDaily(city);
});
