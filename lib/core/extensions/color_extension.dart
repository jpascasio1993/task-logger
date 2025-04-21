import 'dart:ui';

extension ColorExtension on Color {
  Color setOpacity(double opacity) {
    return withValues(alpha: opacity.clamp(0, 1.0));
  }
}
