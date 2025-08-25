import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/repositories/weather_repository.dart';
import '../providers/settings_provider.dart';
import '../widgets/ui_helpers.dart';
import '../widgets/animated_sky.dart';
import '../widgets/design_system.dart';

class CityDetailsScreen extends ConsumerWidget {
  final String cityName;
  const CityDetailsScreen({super.key, required this.cityName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final currentAsync = ref.watch(cityWeatherProvider(cityName));
    final dailyAsync = ref.watch(cityDailyProvider(cityName));
    return currentAsync.when(
      data: (tuple) {
        final c = tuple.$1;
        final temp = settings.unit == TempUnit.celsius ? '${kToC(c.tempK).round()}°C' : '${kToF(c.tempK).round()}°F';
        return Scaffold(
          body: AnimatedSkyBackground(
            condition: c.condition,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  leading: IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: const Icon(Icons.arrow_back_rounded, color: Colors.white)),
                  title: Text(cityName, style: const TextStyle(color: Colors.white)),
                  actions: [
                    IconButton(onPressed: () {}, icon: const Icon(Icons.refresh_rounded, color: Colors.white)),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WeatherHeroCard(
                          city: cityName,
                          condition: c.condition,
                          temperature: temp,
                          leadingIcon: Icon(weatherIcon(c.condition), size: 48, color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        Text('Today details', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
                        const SizedBox(height: 10),
                        FrostedGlass(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.thermostat_rounded, color: Colors.white),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text('Feels like', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                                  ),
                                  Text(
                                    settings.unit == TempUnit.celsius ? '${kToC(c.feelsLikeK).round()}°C' : '${kToF(c.feelsLikeK).round()}°F',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const Divider(height: 18, color: Colors.white24),
                              Row(
                                children: [
                                  const Icon(Icons.water_drop_rounded, color: Colors.white),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text('Humidity', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                                  ),
                                  Text('${c.humidity}%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.air_rounded, color: Colors.white),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text('Wind', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                                  ),
                                  Text('${c.wind.toStringAsFixed(1)} m/s', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.speed_rounded, color: Colors.white),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text('Pressure', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                                  ),
                                  Text('${c.pressure} hPa', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.wb_sunny_rounded, color: Colors.white),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text('Sunrise', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                                  ),
                                  Text(
                                    DateFormat('h:mm a').format(c.sunrise.toUtc().add(Duration(seconds: c.timezoneOffsetSec))),
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.nights_stay_rounded, color: Colors.white),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text('Sunset', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                                  ),
                                  Text(
                                    DateFormat('h:mm a').format(c.sunset.toUtc().add(Duration(seconds: c.timezoneOffsetSec))),
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text('Hourly forecast', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 126,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: tuple.$2.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (context, i) {
                              final h = tuple.$2[i];
                              final t = settings.unit == TempUnit.celsius ? '${kToC(h.tempK).round()}°' : '${kToF(h.tempK).round()}°';
                              return FrostedGlass(
                                padding: const EdgeInsets.all(12),
                                child: SizedBox(
                                  width: 94,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(DateFormat.Hm().format(h.time), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
                                      const SizedBox(height: 8),
                                      Icon(weatherIcon(h.condition), size: 28, color: Colors.white),
                                      const SizedBox(height: 8),
                                      Text(t, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text('7-day forecast', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
                        const SizedBox(height: 12),
                        dailyAsync.when(
                          data: (days) => Column(
                            children: [
                              for (final d in days)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: FrostedGlass(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    child: Row(
                                      children: [
                                        Expanded(child: Text(DateFormat('EEE, MMM d').format(d.day), style: const TextStyle(color: Colors.white))),
                                        Icon(weatherIcon(d.condition), size: 24, color: Colors.white),
                                        const SizedBox(width: 12),
                                        Text(
                                          settings.unit == TempUnit.celsius
                                              ? '${kToC(d.minK).round()}° / ${kToC(d.maxK).round()}°C'
                                              : '${kToF(d.minK).round()}° / ${kToF(d.maxK).round()}°F',
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (e, st) => Text('Error: $e', style: const TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, st) => Scaffold(appBar: AppBar(), body: Center(child: Text('Error: $e'))),
    );
  }

}
