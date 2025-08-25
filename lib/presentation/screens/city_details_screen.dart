import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/repositories/weather_repository.dart';
import '../providers/settings_provider.dart';
import '../widgets/ui_helpers.dart';

class CityDetailsScreen extends ConsumerWidget {
  final String cityName;
  const CityDetailsScreen({super.key, required this.cityName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final currentAsync = ref.watch(cityWeatherProvider(cityName));
    final dailyAsync = ref.watch(cityDailyProvider(cityName));
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            pinned: true,
            leading: IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: const Icon(Icons.arrow_back_rounded)),
            title: Text(cityName),
            flexibleSpace: Hero(
              tag: 'card_$cityName',
              child: const SizedBox.expand(),
            ),
            actions: [
              IconButton(onPressed: () => {}, icon: const Icon(Icons.refresh_rounded)),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  currentAsync.when(
                    data: (tuple) {
                      final c = tuple.$1;
                      final k = c.tempK;
                      final temp = settings.unit == TempUnit.celsius ? '${kToC(k).round()}°C' : '${kToF(k).round()}°F';
                      return glassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(weatherIcon(c.condition), size: 36),
                                const SizedBox(width: 12),
                                Text(c.condition, style: Theme.of(context).textTheme.titleLarge),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(temp, style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _stat('Humidity', '${c.humidity}%'),
                                _stat('Wind', '${c.wind} m/s'),
                                _stat('Pressure', '${c.pressure} hPa'),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                    loading: () => glassCard(child: const SizedBox(height: 140, child: Center(child: CircularProgressIndicator()))),
                    error: (e, st) => glassCard(child: Padding(padding: const EdgeInsets.all(16), child: Text('Error: $e'))),
                  ),
                  const SizedBox(height: 20),
                  Text('Hourly forecast', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  currentAsync.when(
                    data: (tuple) => SizedBox(
                      height: 130,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: tuple.$2.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, i) {
                          final h = tuple.$2[i];
                          final t = settings.unit == TempUnit.celsius ? '${kToC(h.tempK).round()}°' : '${kToF(h.tempK).round()}°';
                          return glassCard(
                            padding: const EdgeInsets.all(12),
                            child: SizedBox(
                              width: 90,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(DateFormat.Hm().format(h.time), style: Theme.of(context).textTheme.bodyMedium),
                                  const SizedBox(height: 8),
                                  Icon(weatherIcon(h.condition), size: 28),
                                  const SizedBox(height: 8),
                                  Text(t, style: Theme.of(context).textTheme.titleMedium),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    loading: () => const SizedBox(height: 130, child: Center(child: CircularProgressIndicator())),
                    error: (e, st) => Padding(padding: const EdgeInsets.all(8.0), child: Text('Error: $e')),
                  ),
                  const SizedBox(height: 20),
                  Text('7-day forecast', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  dailyAsync.when(
                    data: (days) => Column(
                      children: [
                        for (final d in days)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: glassCard(
                              child: Row(
                                children: [
                                  Expanded(child: Text(DateFormat('EEE, MMM d').format(d.day))),
                                  Icon(weatherIcon(d.condition), size: 24),
                                  const SizedBox(width: 12),
                                  Text(
                                    settings.unit == TempUnit.celsius
                                        ? '${kToC(d.minK).round()}° / ${kToC(d.maxK).round()}°C'
                                        : '${kToF(d.minK).round()}° / ${kToF(d.maxK).round()}°F',
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, st) => Text('Error: $e'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
