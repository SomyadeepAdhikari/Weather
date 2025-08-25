import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../data/repositories/weather_repository.dart';
import '../providers/settings_provider.dart';
import '../widgets/ui_helpers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () => context.push('/search'), icon: const Icon(Icons.search_rounded)),
          IconButton(onPressed: () => context.push('/settings'), icon: const Icon(Icons.settings_rounded)),
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Opacity(
              opacity: 0.35,
              child: Lottie.asset('assets/animations/weather_bg.json', repeat: true, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat('EEEE, MMM d').format(DateTime.now()), style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: settings.savedCities.length,
                    itemBuilder: (context, index) {
                      final city = settings.savedCities[index];
                      final async = ref.watch(cityWeatherProvider(city));
                      return InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () => context.push('/city/$city'),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: async.when(
                            data: (tuple) {
                              final current = tuple.$1;
                              final k = current.tempK;
                              final temp = settings.unit == TempUnit.celsius ? '${kToC(k).round()}°C' : '${kToF(k).round()}°F';
                              return Hero(
                                tag: 'card_$city',
                                child: glassCard(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(weatherIcon(current.condition), size: 28),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(city, style: Theme.of(context).textTheme.titleMedium, overflow: TextOverflow.ellipsis),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Text(temp, style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700)),
                                      const SizedBox(height: 6),
                                      Text(current.condition, style: Theme.of(context).textTheme.bodyMedium),
                                    ],
                                  ),
                                ),
                              );
                            },
                            loading: () => glassCard(
                              child: const Center(child: CircularProgressIndicator.adaptive()),
                            ),
                            error: (e, st) => glassCard(
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.error_outline),
                                    const SizedBox(height: 8),
                                    Text('Failed: ${e.toString()}', textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/search'),
        label: const Text('Add city'),
        icon: const Icon(Icons.add_location_alt_outlined),
      ),
    );
  }
}
