import 'dart:math';
import 'package:flutter/material.dart';

/// App gradients inspired by premium, vibrant weather UIs.
class SkyGradients {
  static LinearGradient byCondition(String condition, Brightness b) {
    final c = condition.toLowerCase();
    if (c.contains('rain') || c.contains('drizzle')) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
    colors: b == Brightness.dark
      ? [const Color(0xFF1F102B), const Color(0xFF2A183A), const Color(0xFF3B1E54)]
      : [const Color(0xFFA18CD1), const Color(0xFFFBC2EB)],
      );
    }
    if (c.contains('cloud')) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
    colors: b == Brightness.dark
      ? [const Color(0xFF111111), const Color(0xFF2A2A2A)]
      : [const Color(0xFFEDE9E3), const Color(0xFFD6CCC2)],
      );
    }
    if (c.contains('snow')) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
    colors: b == Brightness.dark
      ? [const Color(0xFF0B0B0B), const Color(0xFF1E1E1E), const Color(0xFF2A2A2A)]
      : [const Color(0xFFFFF9F1), const Color(0xFFFFFFFF)],
      );
    }
    if (c.contains('thunder')) {
    return b == Brightness.dark
      ? const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1E1E1E), Color(0xFF3D1F1F)],
      )
      : const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF3E2C41), Color(0xFFFEC260)],
      );
    }
    // clear / default
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    colors: b == Brightness.dark
      ? [const Color(0xFF0B1020), const Color(0xFF3B0764)]
      : [const Color(0xFFFFE259), const Color(0xFFFFA751)],
    );
  }
}

class FrostedGlass extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsetsGeometry padding;
  final Color? overlay;
  const FrostedGlass({super.key, required this.child, this.radius = 24, this.padding = const EdgeInsets.all(16), this.overlay});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          colors: [
            (overlay ?? scheme.surface).withOpacity(0.18),
            (overlay ?? scheme.surface).withOpacity(0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class NeuButton extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget child;
  final double radius;
  const NeuButton({super.key, required this.child, this.onTap, this.radius = 20});

  @override
  State<NeuButton> createState() => _NeuButtonState();
}

class _NeuButtonState extends State<NeuButton> {
  bool _down = false;
  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).scaffoldBackgroundColor;
    return GestureDetector(
      onTapDown: (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) => setState(() => _down = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(widget.radius),
          boxShadow: _down
              ? [
                  BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(4, 4)),
                  const BoxShadow(color: Colors.white10, blurRadius: 10, offset: Offset(-4, -4)),
                ]
              : [
                  BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 20, offset: const Offset(12, 12)),
                  const BoxShadow(color: Colors.white10, blurRadius: 20, offset: Offset(-12, -12)),
                ],
        ),
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), child: widget.child),
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
