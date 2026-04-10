import 'dart:ui';

extension ColorUtils on Color {
  Color darken([int amount = 10]) {
    assert(amount >= 0 && amount <= 100);
    final f = 1 - amount / 100;
    return Color.fromARGB(
      a.toInt(),
      (r * f).round(),
      (g * f).round(),
      (b * f).round(),
    );
  }

  Color withValues({int? alpha}) {
    return withAlpha(alpha ?? this.alpha);
  }
}
