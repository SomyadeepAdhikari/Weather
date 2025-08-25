import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

double kToC(double k) => k - 273.15;
double kToF(double k) => (k - 273.15) * 9 / 5 + 32;

IconData weatherIcon(String cond) {
  switch (cond.toLowerCase()) {
    case 'clouds':
      return WeatherIcons.cloud;
    case 'rain':
      return WeatherIcons.rain;
    case 'drizzle':
      return WeatherIcons.showers;
    case 'thunderstorm':
      return WeatherIcons.thunderstorm;
    case 'snow':
      return WeatherIcons.snow;
    case 'mist':
    case 'fog':
    case 'haze':
      return WeatherIcons.fog;
    default:
      return WeatherIcons.day_sunny;
  }
}

Widget glassCard({required Widget child, EdgeInsetsGeometry padding = const EdgeInsets.all(16)}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      gradient: LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.12),
          Colors.white.withValues(alpha: 0.04),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 10)),
      ],
    ),
    child: Padding(padding: padding, child: child),
  );
}
