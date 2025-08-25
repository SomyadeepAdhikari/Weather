import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/repositories/weather_repository.dart';
import '../providers/settings_provider.dart';
import '../providers/ui_state_providers.dart';
import '../widgets/ui_helpers.dart';
import '../widgets/animated_sky.dart';
import '../widgets/design_system.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    final initial = ref.read(selectedCityIndexProvider);
    _pageController = PageController(viewportFraction: .9, initialPage: initial);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final settings = ref.watch(settingsProvider);
    final cities = settings.savedCities;

    // Determine top background by the first city's condition when available
    final firstWeather = cities.isNotEmpty ? ref.watch(cityWeatherProvider(cities.first)) : null;
    final cond = firstWeather?.maybeWhen(data: (d) => d.$1.condition, orElse: () => 'Clear') ?? 'Clear';

    return Scaffold(
      body: AnimatedSkyBackground(
        condition: cond,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Weather', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800, color: Colors.white)),
                    const Spacer(),
                    IconButton(
                      style: IconButton.styleFrom(backgroundColor: Colors.white.withOpacity(.12)),
                      onPressed: () => context.push('/search'),
                      icon: const Icon(Icons.search_rounded, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      style: IconButton.styleFrom(backgroundColor: Colors.white.withOpacity(.12)),
                      onPressed: () => context.push('/settings'),
                      icon: const Icon(Icons.settings_rounded, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(DateFormat('EEEE, MMM d').format(DateTime.now()), style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70)),
                const SizedBox(height: 18),

                // Hero carousel of cities
                if (cities.isNotEmpty)
                  SizedBox(
                    height: 240,
                    child: Scrollbar(
                      controller: _pageController,
                      thumbVisibility: true,
                      interactive: true,
                      thickness: 4,
                      radius: const Radius.circular(8),
                      child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (i) => ref.read(selectedCityIndexProvider.notifier).state = i,
                      itemCount: cities.length,
                      itemBuilder: (context, index) {
                        final city = cities[index];
                        final async = ref.watch(cityWeatherProvider(city));
                        final isFirst = index == 0;
                        final isLast = index == cities.length - 1;
                        return AnimatedPadding(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                          padding: EdgeInsets.fromLTRB(
                            isFirst ? 16 : 12,
                            16,
                            isLast ? 16 : 12,
                            16,
                          ),
                          child: async.when(
                            data: (tuple) {
                              final current = tuple.$1;
                              final k = current.tempK;
                              final temp = settings.unit == TempUnit.celsius ? '${kToC(k).round()}°C' : '${kToF(k).round()}°F';
                              return WeatherHeroCard(
                                city: city,
                                condition: current.condition,
                                temperature: temp,
                                leadingIcon: Icon(weatherIcon(current.condition), size: 42, color: Colors.white),
                                onTap: () => context.push('/city/$city'),
                              );
                            },
                            loading: () => FrostedGlass(
                              child: const SizedBox(height: 220, child: Center(child: CircularProgressIndicator.adaptive())),
                            ),
                            error: (e, st) => FrostedGlass(
                              child: SizedBox(
                                height: 220,
                                child: Center(child: Text('Failed: $e', style: const TextStyle(color: Colors.white))),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    ),
                  )
                else
                  FrostedGlass(
                    child: SizedBox(
                      height: 200,
                      child: Center(
                        child: Text('Add a city to begin', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
                      ),
                    ),
                  ),

                const SizedBox(height: 10),

                const SizedBox(height: 14),

                // Secondary grid of snapshots
                if (cities.length > 1)
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(bottom: 24),
                      itemBuilder: (context, i) {
                        final city = cities[i];
                        final async = ref.watch(cityWeatherProvider(city));
                        return async.when(
                          data: (tuple) {
                            final k = tuple.$1.tempK;
                            final t = settings.unit == TempUnit.celsius ? '${kToC(k).round()}°' : '${kToF(k).round()}°';
                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => context.push('/city/$city'),
                              child: glassCard(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                child: Row(
                                  children: [
                                    Icon(weatherIcon(tuple.$1.condition), color: Colors.white, size: 24),
                                    const SizedBox(width: 12),
                                    Expanded(child: Text(city, style: const TextStyle(color: Colors.white))),
                                    Text(t, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
                                  ],
                                ),
                              ),
                            );
                          },
                          loading: () => glassCard(child: const SizedBox(height: 56, child: Center(child: CircularProgressIndicator.adaptive()))),
                          error: (e, st) => glassCard(child: Padding(padding: const EdgeInsets.all(12), child: Text('Failed: $e'))),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemCount: cities.length,
                    ),
                  )
                else
                  const Spacer(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/search'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        label: const Text('Add city'),
        icon: const Icon(Icons.add_location_alt_outlined),
      ),
    );
  }
}
