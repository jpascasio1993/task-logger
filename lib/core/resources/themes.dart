// ignore_for_file: avoid_classes_with_only_static_members, document_ignores

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_logger/core/extensions/color_extension.dart';

class AppThemeData extends ThemeExtension<AppThemeData> {
  const AppThemeData({
    required this.brightness,
    required this.edgeInsets,
    required this.rawDimensions,
    required this.textStyles,
  });

  final Brightness brightness;
  final EdgeInsetsData edgeInsets;
  final RawDimensionsData rawDimensions;
  final TextStylesData textStyles;

  @override
  AppThemeData copyWith({
    Brightness? brightness,
    EdgeInsetsData? edgeInsets,
    RawDimensionsData? rawDimensions,
    TextStylesData? textStyles,
    AppBarTheme? flatAppBarTheme,
  }) {
    return AppThemeData(
      brightness: brightness ?? this.brightness,
      edgeInsets: edgeInsets ?? this.edgeInsets,
      rawDimensions: rawDimensions ?? this.rawDimensions,
      textStyles: textStyles ?? this.textStyles,
    );
  }

  @override
  ThemeExtension<AppThemeData> lerp(
      ThemeExtension<AppThemeData>? other, double t) {
    return this;
  }
}

class EdgeInsetsData {
  const EdgeInsetsData({required this.containerPadding});

  final EdgeInsets containerPadding;
}

class RawDimensionsData {
  RawDimensionsData(
      {required this.maxWidth,
      required this.cornerRadius,
      required this.textFieldSpacing});

  final double maxWidth;
  final double cornerRadius;
  final double textFieldSpacing;
}

class TextStylesData {
  TextStylesData({required this.actionsStyle});

  final TextStyle actionsStyle;
}

abstract class ColorSchemes {
  static const Color seed = Color(0xFF5b58ff);
  static const Color orange = Color(0xFFFFA525);

  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: seed,
    surfaceTint: seed,
    onPrimary: Color(0xffffffff),
    primaryContainer: Color(0xffb1f1c1),
    onPrimaryContainer: Color(0xff11512e),
    secondary: Color(0xff4f6353),
    onSecondary: Color(0xffffffff),
    secondaryContainer: Color(0xffd2e8d4),
    onSecondaryContainer: Color(0xff384b3c),
    tertiary: Color(0xff003570),
    onTertiary: Color(0xffffffff),
    tertiaryContainer: Color(0xff006bd5),
    onTertiaryContainer: Color(0xff214c57),
    // error: Color(0xffba1a1a),
    error: Color(0xFFD32F2F),
    onError: Color(0xffffffff),
    errorContainer: Color(0xffffdad6),
    onErrorContainer: Color(0xff93000a),
    surface: Color(0xffffffff),
    // onSurface: Color(0xff181d18),
    onSurface: Color(0xff333333),
    onSurfaceVariant: Color(0xff414942),
    outline: Color(0xff717971),
    outlineVariant: Color(0xffc0c9bf),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xff2c322d),
    inversePrimary: Color(0xff5ede90),
    primaryFixed: Color(0xff007e46),
    onPrimaryFixed: Color(0xff00210e),
    primaryFixedDim: Color(0xff006235),
    onPrimaryFixedVariant: Color(0xffffffff),
    secondaryFixed: Color(0xff007e3d),
    onSecondaryFixed: Color(0xffffffff),
    secondaryFixedDim: Color(0xff00622e),
    onSecondaryFixedVariant: Color(0xffffffff),
    tertiaryFixed: Color(0xff006bd5),
    onTertiaryFixed: Color(0xff001f26),
    tertiaryFixedDim: Color(0xffa2ceda),
    onTertiaryFixedVariant: Color(0xff214c57),
    surfaceDim: Color(0xffd6dbd4),
    surfaceBright: Color(0xfff6fbf3),
    surfaceContainerLowest: Color(0xffffffff),
    surfaceContainerLow: Color(0xfff0f5ed),
    surfaceContainer: Color(0xFFF0F5F5),
    surfaceContainerHigh: Color(0xffe5eae2),
    surfaceContainerHighest: Color(0xffdfe4dc),
  );

  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xffc1c1ff),
    surfaceTint: Color.fromARGB(255, 153, 153, 250),
    onPrimary: Color(0xffe2e0f9),
    primaryContainer: Color(0xff414178),
    onPrimaryContainer: Color(0xff414178),
    secondary: Color(0xffc6c4dd),
    onSecondary: Color(0xffc6c4dd),
    secondaryContainer: Color(0xff454559),
    onSecondaryContainer: Color(0xffe2e0f9),
    tertiary: Color(0xffaac7ff),
    onTertiary: Color(0xff0b305f),
    tertiaryContainer: Color(0xff284777),
    onTertiaryContainer: Color(0xffd7e3ff),
    error: Color(0xFFD32F2F),
    onError: Color(0xffffffff),
    errorContainer: Color(0xffffdad6),
    onErrorContainer: Color(0xff93000a),
    surface: Color(0xff131318),
    onSurface: Color(0xffe4e1e9),
    onSurfaceVariant: Color(0xffc8c5d0),
    outline: Color(0xff918f9a),
    outlineVariant: Color(0xff47464f),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xffe4e1e9),
    inversePrimary: Color(0xff585992),
    primaryFixed: Color(0xffe2dfff),
    onPrimaryFixed: Color(0xff14134a),
    primaryFixedDim: Color(0xffc1c1ff),
    onPrimaryFixedVariant: Color(0xff414178),
    secondaryFixed: Color(0xffe2e0f9),
    onSecondaryFixed: Color(0xff1a1a2c),
    secondaryFixedDim: Color(0xffc6c4dd),
    onSecondaryFixedVariant: Color(0xff454559),
    tertiaryFixed: Color(0xffd7e3ff),
    onTertiaryFixed: Color(0xff001b3e),
    tertiaryFixedDim: Color(0xffaac7ff),
    onTertiaryFixedVariant: Color(0xff284777),
    surfaceDim: Color(0xff131318),
    surfaceBright: Color(0xff39383f),
    surfaceContainerLowest: Color(0xff0e0e13),
    surfaceContainerLow: Color(0xff1b1b21),
    surfaceContainer: Color(0xff1f1f25),
    surfaceContainerHigh: Color(0xff2a292f),
    surfaceContainerHighest: Color(0xff35343a),
  );
}

AppThemeData _createBaseTheme(ColorScheme colorScheme) => AppThemeData(
      brightness: colorScheme.brightness,
      edgeInsets: const EdgeInsetsData(
        containerPadding: EdgeInsets.all(24),
      ),
      rawDimensions: RawDimensionsData(
        cornerRadius: 8,
        maxWidth: 512,
        textFieldSpacing: 24,
      ),
      textStyles: TextStylesData(
        actionsStyle: const TextStyle(fontSize: 16),
      ),
    );

abstract class MaterialAppThemes {
  static ThemeData get lightTheme =>
      _createTheme(_createBaseTheme(ColorSchemes.light), ColorSchemes.light);
  static ThemeData get darkTheme =>
      _createTheme(_createBaseTheme(ColorSchemes.dark), ColorSchemes.dark);
  static ThemeData _createTheme(
      AppThemeData baseTheme, ColorScheme colorScheme) {
    return ThemeData(
      extensions: [baseTheme],
      primaryColor: colorScheme.primary,
      brightness: baseTheme.brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      dividerColor: colorScheme.shadow.setOpacity(0.2),
      appBarTheme: AppBarTheme(
        color: colorScheme.surface,
        elevation: 0,
        foregroundColor: colorScheme.onSurface,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        actionsIconTheme: IconThemeData(color: colorScheme.onSurface),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
          fontSize: 20,
        ),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(baseTheme.rawDimensions.cornerRadius)),
        ),
      ),
      badgeTheme: const BadgeThemeData(
        backgroundColor: ColorSchemes.orange,
        padding: EdgeInsets.all(2),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
      ),
      visualDensity: VisualDensity.standard,
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(baseTheme.rawDimensions.cornerRadius)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: colorScheme.shadow.setOpacity(0.2), width: 0.5),
          borderRadius:
              BorderRadius.circular(baseTheme.rawDimensions.cornerRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: colorScheme.shadow.setOpacity(0.2), width: 0.5),
          borderRadius:
              BorderRadius.circular(baseTheme.rawDimensions.cornerRadius),
        ),
        hintStyle: TextStyle(
          color: colorScheme.onSurface.setOpacity(0.3),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorSchemes.orange,
          foregroundColor: colorScheme.onPrimary,
          elevation: 8,
          minimumSize: const Size(134, 54),
          textStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(baseTheme.rawDimensions.cornerRadius)),
          ),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        side: WidgetStateBorderSide.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return BorderSide(color: colorScheme.primary, width: 1.5);
            }
            return BorderSide(
                color: colorScheme.shadow.setOpacity(0.2), width: 1.5);
          },
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle:
              const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(baseTheme.rawDimensions.cornerRadius)),
          ),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.onPrimary,
          backgroundColor: colorScheme.primary,
          disabledBackgroundColor: colorScheme.shadow.setOpacity(0.1),
          disabledForegroundColor: const Color(0xFF626262),
          padding: const EdgeInsets.symmetric(vertical: 15),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white.setOpacity(0.3), width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: colorScheme.primary,
      ),
      tabBarTheme: TabBarTheme(
        dividerColor: colorScheme.shadow.setOpacity(0.1),
        dividerHeight: 5,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.shadow.setOpacity(0.2),
        unselectedLabelStyle: TextStyle(
          color: colorScheme.shadow.setOpacity(0.2),
          fontWeight: FontWeight.w600,
          fontSize: 14,
          height: 1.1,
          letterSpacing: 0.5,
        ),
        labelStyle: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.w800,
          fontSize: 14,
          height: 1.1,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
