import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';
import 'design_system.dart';

double kToC(double k) => k - 273.15;
double kToF(double k) => (k - 273.15) * 9 / 5 + 32;

IconData weatherIcon(String cond) {
  switch (cond.toLowerCase()) {
    case 'clouds':
      return WeatherIcons.cloud;
    case 'rain':
      return WeatherIcons.rain;
    case 'drizzle':
      return WeatherIcons.showers;
    case 'thunderstorm':
      return WeatherIcons.thunderstorm;
    case 'snow':
      return WeatherIcons.snow;
    case 'mist':
    case 'fog':
    case 'haze':
      return WeatherIcons.fog;
    default:
      return WeatherIcons.day_sunny;
  }
}

/// Legacy glassCard function for backward compatibility
Widget glassCard({
  required Widget child, 
  EdgeInsetsGeometry padding = const EdgeInsets.all(16), 
  double radius = 24
}) {
  return FrostedGlass(
    radius: radius,
    padding: padding,
    child: child,
  );
}

/// Enhanced info item widget with modern styling
class EnhancedInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? accentColor;
  
  const EnhancedInfoItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return ModernInfoCard(
      icon: icon,
      label: label,
      value: value,
      accentColor: accentColor,
      isVertical: true,
    );
  }
}

/// Animated temperature display widget
class AnimatedTemperature extends StatefulWidget {
  final String temperature;
  final TextStyle? style;
  final Duration animationDuration;
  
  const AnimatedTemperature({
    super.key,
    required this.temperature,
    this.style,
    this.animationDuration = const Duration(milliseconds: 800),
  });

  @override
  State<AnimatedTemperature> createState() => _AnimatedTemperatureState();
}

class _AnimatedTemperatureState extends State<AnimatedTemperature>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
    
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedTemperature oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.temperature != widget.temperature) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Text(
              widget.temperature,
              style: widget.style,
            ),
          ),
        );
      },
    );
  }
}

/// Gradient icon widget for weather conditions
class GradientIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final List<Color> colors;
  
  const GradientIcon({
    super.key,
    required this.icon,
    this.size = 24,
    this.colors = const [Colors.white, Colors.white70],
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Icon(
        icon,
        size: size,
        color: Colors.white,
      ),
    );
  }
}
