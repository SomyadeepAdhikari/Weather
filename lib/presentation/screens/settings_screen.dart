import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final themeMode = ref.watch(themeModeProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Appearance', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(value: ThemeMode.light, label: Text('Light'), icon: Icon(Icons.light_mode_rounded)),
              ButtonSegment(value: ThemeMode.dark, label: Text('Dark'), icon: Icon(Icons.dark_mode_rounded)),
              ButtonSegment(value: ThemeMode.system, label: Text('System'), icon: Icon(Icons.brightness_auto_rounded)),
            ],
            selected: {themeMode},
            onSelectionChanged: (s) => ref.read(themeModeProvider.notifier).setTheme(s.first),
          ),
          const SizedBox(height: 24),
          Text('Units', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          SegmentedButton<TempUnit>(
            segments: const [
              ButtonSegment(value: TempUnit.celsius, label: Text('°C')),
              ButtonSegment(value: TempUnit.fahrenheit, label: Text('°F')),
            ],
            selected: {settings.unit},
            onSelectionChanged: (s) => ref.read(settingsProvider.notifier).setUnit(s.first),
          ),
          const SizedBox(height: 24),
          Text('Saved cities', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: settings.savedCities.length,
            onReorder: (oldI, newI) => ref.read(settingsProvider.notifier).reorder(oldI, newI),
            itemBuilder: (context, index) {
              final city = settings.savedCities[index];
              return Dismissible(
                key: ValueKey(city),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => ref.read(settingsProvider.notifier).removeCity(city),
                background: Container(
                  alignment: Alignment.centerRight,
                  color: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: ListTile(
                  title: Text(city),
                  leading: const Icon(Icons.drag_indicator_rounded),
                  trailing: IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => ref.read(settingsProvider.notifier).removeCity(city),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
