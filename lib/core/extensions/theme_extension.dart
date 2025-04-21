import 'package:flutter/material.dart';

extension ThemeExtensions on BuildContext {
  ThemeData get materialTheme => Theme.of(this);
}
