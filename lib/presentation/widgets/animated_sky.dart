import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'design_system.dart';

class AnimatedSkyBackground extends StatefulWidget {
  final String condition;
  final Widget? child;
  
  const AnimatedSkyBackground({
    super.key, 
    required this.condition, 
    this.child,
  });

  @override
  State<AnimatedSkyBackground> createState() => _AnimatedSkyBackgroundState();
}

class _AnimatedSkyBackgroundState extends State<AnimatedSkyBackground>
    with TickerProviderStateMixin {
  late AnimationController _gradientController;
  late AnimationController _floatingController;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();
    
    _gradientController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _floatingController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);
    
    _floatingAnimation = Tween<double>(
      begin: -20,
      end: 20,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final baseGradient = SkyGradients.byCondition(widget.condition, brightness);
    
    return AnimatedBuilder(
      animation: _gradientController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: baseGradient.colors.map((color) {
                // Subtle animated color shifting
                final hsl = HSLColor.fromColor(color);
                final shifted = hsl.withHue(
                  (hsl.hue + (_gradientController.value * 10)) % 360,
                );
                return shifted.toColor();
              }).toList(),
              stops: baseGradient.stops,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Ambient particles effect
              if (widget.condition.toLowerCase().contains('snow'))
                ...List.generate(15, (index) => _buildSnowflake(index)),
              
              if (widget.condition.toLowerCase().contains('rain'))
                ...List.generate(20, (index) => _buildRaindrop(index)),
              
              // Main animated background
              AnimatedBuilder(
                animation: _floatingAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatingAnimation.value),
                    child: IgnorePointer(
                      child: Opacity(
                        opacity: 0.15,
                        child: Lottie.asset(
                          'assets/animations/weather_bg.json',
                          fit: BoxFit.cover,
                          repeat: true,
                        ),
                      ),
                    ),
                  );
                },
              ),
              
              // Gradient overlay for better text readability
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
              
              if (widget.child != null) widget.child!,
            ],
          ),
        );
      },
    );
  }

  Widget _buildSnowflake(int index) {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        final screenHeight = MediaQuery.of(context).size.height;
        final progress = (_floatingController.value + (index * 0.1)) % 1.0;
        
        return Positioned(
          left: (index * 50.0) % MediaQuery.of(context).size.width,
          top: progress * (screenHeight + 100) - 50,
          child: Transform.rotate(
            angle: progress * 6.28 * 2, // 2 full rotations
            child: Icon(
              Icons.ac_unit,
              color: Colors.white.withOpacity(0.3),
              size: 12 + (index % 3) * 4,
            ),
          ),
        );
      },
    );
  }

  Widget _buildRaindrop(int index) {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        final screenHeight = MediaQuery.of(context).size.height;
        final progress = (_floatingController.value * 2 + (index * 0.05)) % 1.0;
        
        return Positioned(
          left: (index * 30.0) % MediaQuery.of(context).size.width,
          top: progress * (screenHeight + 100) - 50,
          child: Container(
            width: 2,
            height: 20,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.6),
                  Colors.transparent,
                ],
              ),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        );
      },
    );
  }
}

class WeatherHeroCard extends StatefulWidget {
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
  State<WeatherHeroCard> createState() => _WeatherHeroCardState();
}

class _WeatherHeroCardState extends State<WeatherHeroCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 20.0,
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
    final textTheme = Theme.of(context).textTheme;
    
    return Hero(
      tag: 'card_${widget.city}',
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
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
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20 + _glowAnimation.value,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        blurRadius: 5 + _glowAnimation.value / 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        height: 240,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.25),
                              Colors.white.withOpacity(0.05),
                            ],
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          children: [
                            // Animated icon container
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.2),
                                    Colors.white.withOpacity(0.05),
                                  ],
                                ),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Center(child: widget.leadingIcon),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.city,
                                    style: textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    widget.condition,
                                    style: textTheme.titleMedium?.copyWith(
                                      color: Colors.white.withOpacity(0.8),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    widget.temperature,
                                    style: textTheme.displayMedium?.copyWith(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                      height: 1.0,
                                    ),
                                  ),
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
            },
          ),
        ),
      ),
    );
  }
}
