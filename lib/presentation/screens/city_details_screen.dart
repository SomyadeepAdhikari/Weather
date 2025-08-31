import 'dart:ui';
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
                        Text('Today details', style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        )),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.2),
                                Colors.white.withOpacity(0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    _buildDetailRow(
                                      context,
                                      Icons.thermostat_rounded,
                                      'Feels like',
                                      settings.unit == TempUnit.celsius 
                                        ? '${kToC(c.feelsLikeK).round()}°C' 
                                        : '${kToF(c.feelsLikeK).round()}°F',
                                    ),
                                    const SizedBox(height: 16),
                                    _buildDetailRow(
                                      context,
                                      Icons.water_drop_rounded,
                                      'Humidity',
                                      '${c.humidity}%',
                                    ),
                                    const SizedBox(height: 16),
                                    _buildDetailRow(
                                      context,
                                      Icons.air_rounded,
                                      'Wind',
                                      '${c.wind.toStringAsFixed(1)} m/s',
                                    ),
                                    const SizedBox(height: 16),
                                    _buildDetailRow(
                                      context,
                                      Icons.speed_rounded,
                                      'Pressure',
                                      '${c.pressure} hPa',
                                    ),
                                    const SizedBox(height: 16),
                                    _buildDetailRow(
                                      context,
                                      Icons.wb_sunny_rounded,
                                      'Sunrise',
                                      DateFormat('h:mm a').format(c.sunrise.toUtc().add(Duration(seconds: c.timezoneOffsetSec))),
                                    ),
                                    const SizedBox(height: 16),
                                    _buildDetailRow(
                                      context,
                                      Icons.nights_stay_rounded,
                                      'Sunset',
                                      DateFormat('h:mm a').format(c.sunset.toUtc().add(Duration(seconds: c.timezoneOffsetSec))),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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

  Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
