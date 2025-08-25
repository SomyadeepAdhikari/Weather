import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';
import 'design_system.dart';

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

Widget glassCard({required Widget child, EdgeInsetsGeometry padding = const EdgeInsets.all(16), double radius = 24}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      gradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.16),
          Colors.white.withOpacity(0.06),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
  border: Border.all(color: Colors.white.withOpacity(0.18)),
    ),
    child: Padding(padding: padding, child: child),
  );
}

// Accent pill used for labels and chips
class AccentPill extends StatelessWidget {
  final String text;
  final Color color;
  const AccentPill(this.text, {super.key, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
        gradient: LinearGradient(colors: [color.withOpacity(.18), color.withOpacity(.06)]),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Text(text, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color.lighten(.2))),
    );
  }
}
