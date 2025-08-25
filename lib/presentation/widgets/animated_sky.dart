import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'design_system.dart';

class AnimatedSkyBackground extends StatelessWidget {
  final String condition;
  final Widget? child;
  const AnimatedSkyBackground({super.key, required this.condition, this.child});

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final grad = SkyGradients.byCondition(condition, b);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(gradient: grad),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Ambient animated background
          IgnorePointer(
            child: Align(
              alignment: Alignment.topCenter,
              child: Opacity(
                opacity: 0.25,
                child: Lottie.asset('assets/animations/weather_bg.json', fit: BoxFit.cover, repeat: true),
              ),
            ),
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class WeatherHeroCard extends StatelessWidget {
  final String city;
  final String condition;
  final String temperature;
  final Widget leadingIcon;
  final VoidCallback? onTap;
  const WeatherHeroCard({
    super.key,
    required this.city,
    required this.condition,
    required this.temperature,
    required this.leadingIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Hero(
      tag: 'card_$city',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: FrostedGlass(
            radius: 28,
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 220,
              child: Row(
                children: [
                  SizedBox(width: 72, height: 72, child: Center(child: leadingIcon)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(city, style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Text(condition, style: textTheme.titleMedium),
                        const SizedBox(height: 12),
                        Text(temperature, style: textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
