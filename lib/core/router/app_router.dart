import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/city_details_screen.dart';
import '../../presentation/screens/search_screen.dart';
import '../../presentation/screens/settings_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        pageBuilder: (context, state) => NoTransitionPage(child: const HomeScreen()),
      ),
      GoRoute(
        path: '/city/:name',
        name: 'city',
        pageBuilder: (context, state) {
          final name = state.pathParameters['name']!;
          return CustomTransitionPage(
            child: CityDetailsScreen(cityName: name),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              final curved = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
              return FadeTransition(opacity: curved, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/search',
        name: 'search',
        pageBuilder: (context, state) => CustomTransitionPage(
          transitionsBuilder: _slideUp,
          child: const SearchScreen(),
        ),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        pageBuilder: (context, state) => CustomTransitionPage(
          transitionsBuilder: _slideUp,
          child: const SettingsScreen(),
        ),
      ),
    ],
  );
});

Widget _slideUp(BuildContext context, Animation<double> animation, Animation<double> secondary, Widget child) {
  final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
  return SlideTransition(
    position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(curved),
    child: FadeTransition(opacity: curved, child: child),
  );
}
