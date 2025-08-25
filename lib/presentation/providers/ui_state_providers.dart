import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds UI-only state such as which city is selected in the home carousel.
final selectedCityIndexProvider = StateProvider<int>((ref) => 0);
