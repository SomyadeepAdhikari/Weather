import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

/// Enhanced premium gradients inspired by modern weather UIs and design systems
class SkyGradients {
  static LinearGradient byCondition(String condition, Brightness brightness) {
    final c = condition.toLowerCase();
    final isDark = brightness == Brightness.dark;
    
    if (c.contains('rain') || c.contains('drizzle')) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark 
          ? [
              const Color(0xFF1A1A2E),
              const Color(0xFF16213E),
              const Color(0xFF0F3460),
            ]
          : [
              const Color(0xFF667eea),
              const Color(0xFF764ba2),
              const Color(0xFF667eea),
            ],
        stops: const [0.0, 0.6, 1.0],
      );
    }
    
    if (c.contains('cloud')) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark 
          ? [
              const Color(0xFF232526),
              const Color(0xFF414345),
            ]
          : [
              const Color(0xFFbdc3c7),
              const Color(0xFF2c3e50),
            ],
      );
    }
    
    if (c.contains('snow')) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark 
          ? [
              const Color(0xFF0c0c0c),
              const Color(0xFF1e3c72),
              const Color(0xFF2a5298),
            ]
          : [
              const Color(0xFFe6ddd4),
              const Color(0xFFffffff),
            ],
        stops: const [0.0, 0.7, 1.0],
      );
    }
    
    if (c.contains('thunder')) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark 
          ? [
              const Color(0xFF232526),
              const Color(0xFF414345),
              const Color(0xFF1f1c2c),
            ]
          : [
              const Color(0xFF654ea3),
              const Color(0xFFeaafc8),
            ],
        stops: const [0.0, 0.8, 1.0],
      );
    }
    
    if (c.contains('fog') || c.contains('mist') || c.contains('haze')) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark 
          ? [
              const Color(0xFF2C3E50),
              const Color(0xFF4CA1AF),
            ]
          : [
              const Color(0xFFf7f0ac),
              const Color(0xFFacb6e5),
            ],
      );
    }
    
    // Clear/Sunny default
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark 
        ? [
            const Color(0xFF0F0C29),
            const Color(0xFF302B63),
            const Color(0xFF24243e),
          ]
        : [
            const Color(0xFF74b9ff),
            const Color(0xFF0984e3),
            const Color(0xFF6c5ce7),
          ],
      stops: const [0.0, 0.6, 1.0],
    );
  }
}

/// Enhanced frosted glass widget with advanced blur and shadow effects
class FrostedGlass extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsetsGeometry padding;
  final Color? overlay;
  final double blurSigma;
  final double shadowBlur;
  final Offset shadowOffset;
  final bool hasBorder;
  final double borderWidth;
  final Color? borderColor;
  
  const FrostedGlass({
    super.key,
    required this.child,
    this.radius = 28,
    this.padding = const EdgeInsets.all(20),
    this.overlay,
    this.blurSigma = 10.0,
    this.shadowBlur = 20.0,
    this.shadowOffset = const Offset(0, 8),
    this.hasBorder = true,
    this.borderWidth = 1.0,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: isDark 
              ? Colors.black.withOpacity(0.3)
              : Colors.black.withOpacity(0.1),
            blurRadius: shadowBlur,
            offset: shadowOffset,
            spreadRadius: 0,
          ),
          if (!isDark)
            BoxShadow(
              color: Colors.white.withOpacity(0.6),
              blurRadius: 2,
              offset: const Offset(0, -2),
              spreadRadius: 0,
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark 
                  ? [
                      Colors.white.withOpacity(0.15),
                      Colors.white.withOpacity(0.05),
                    ]
                  : [
                      Colors.white.withOpacity(0.25),
                      Colors.white.withOpacity(0.10),
                    ],
              ),
              border: hasBorder ? Border.all(
                color: borderColor ?? Colors.white.withOpacity(isDark ? 0.1 : 0.2),
                width: borderWidth,
              ) : null,
            ),
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Enhanced animated card widget with hover effects and smooth transitions
class AnimatedWeatherCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Duration animationDuration;
  final double? width;
  final double? height;
  
  const AnimatedWeatherCard({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius = 28,
    this.padding = const EdgeInsets.all(20),
    this.animationDuration = const Duration(milliseconds: 200),
    this.width,
    this.height,
  });

  @override
  State<AnimatedWeatherCard> createState() => _AnimatedWeatherCardState();
}

class _AnimatedWeatherCardState extends State<AnimatedWeatherCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _elevationAnimation = Tween<double>(
      begin: 0.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: SizedBox(
              width: widget.width,
              height: widget.height,
              child: FrostedGlass(
                radius: widget.borderRadius,
                padding: widget.padding,
                shadowBlur: 15 + _elevationAnimation.value,
                child: widget.child,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Modern info card with gradient accent
class ModernInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? accentColor;
  final bool isVertical;
  
  const ModernInfoCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.accentColor,
    this.isVertical = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = accentColor ?? theme.colorScheme.primary;
    
    return FrostedGlass(
      radius: 16,
      padding: const EdgeInsets.all(16),
      child: isVertical 
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [accent.withOpacity(0.2), accent.withOpacity(0.1)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          )
        : Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [accent.withOpacity(0.2), accent.withOpacity(0.1)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      value,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}

extension ColorX on Color {
  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness(min(1.0, hsl.lightness + amount));
    return hslLight.toColor();
  }
}
