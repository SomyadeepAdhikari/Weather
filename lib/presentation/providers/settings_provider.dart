import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TempUnit { celsius, fahrenheit }

class SettingsState {
  final TempUnit unit;
  final List<String> savedCities; // city names
  const SettingsState({required this.unit, required this.savedCities});

  SettingsState copyWith({TempUnit? unit, List<String>? savedCities}) =>
      SettingsState(unit: unit ?? this.unit, savedCities: savedCities ?? this.savedCities);
}

final settingsProvider = StateNotifierProvider<SettingsController, SettingsState>((ref) {
  return SettingsController()..load();
});

class SettingsController extends StateNotifier<SettingsState> {
  SettingsController() : super(const SettingsState(unit: TempUnit.celsius, savedCities: ['Kolkata']));

  static const _keyUnit = 'unit_v1';
  static const _keyCities = 'cities_v1';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final u = prefs.getString(_keyUnit);
    final cities = prefs.getStringList(_keyCities) ?? state.savedCities;
    state = state.copyWith(
      unit: u == 'f' ? TempUnit.fahrenheit : TempUnit.celsius,
      savedCities: cities,
    );
  }

  Future<void> setUnit(TempUnit unit) async {
    state = state.copyWith(unit: unit);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUnit, unit == TempUnit.fahrenheit ? 'f' : 'c');
  }

  Future<void> addCity(String name) async {
    if (name.trim().isEmpty) return;
    final list = [...state.savedCities];
    if (list.contains(name)) return;
    list.add(name);
    await _saveCities(list);
  }

  Future<void> removeCity(String name) async {
    final list = [...state.savedCities]..remove(name);
    await _saveCities(list);
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    final list = [...state.savedCities];
    if (newIndex > oldIndex) newIndex -= 1;
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);
    await _saveCities(list);
  }

  Future<void> _saveCities(List<String> list) async {
    state = state.copyWith(savedCities: list);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyCities, list);
  }
}
