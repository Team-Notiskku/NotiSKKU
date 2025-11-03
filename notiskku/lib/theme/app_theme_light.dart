import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// ===== Palette =====
class LightPalette {
  static const greenBackground = Color(0xFFFAFFFE); // 배경
  static const textPrimary = Color(0xFF17171B); // 일반 텍스트
  static const lineGray = Color(0xFF979797); // 구분선, 회색 텍스트
  static const gray = Color(0xFFD9D9D9); // 회색 배경

  static const mainGreen = Color(0xFF0B5B42); // 메인 초록 (버튼/포커스)
  static const subGreen = Color(0xFF24916F); // 서브 초록 (링크/포인트)

  static const mainRed = Color(0xFFA01210); // 삭제 버튼
  static const subRed = Color(0xFFC94848); // 경고/취소 텍스트
}

/// ===== Typography =====
TextTheme lightTextTheme(String fontFamily) => TextTheme(
  // Display / Headline
  headlineLarge: TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w900,
    fontSize: 25.sp,
    color: LightPalette.textPrimary,
  ),
  headlineMedium: TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 18.sp,
    color: LightPalette.textPrimary,
  ),
  headlineSmall: TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
    color: LightPalette.textPrimary,
  ),

  bodyMedium: TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 15.sp,
    color: LightPalette.textPrimary,
  ),
  labelSmall: TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w100,
    fontSize: 13.sp,
    color: LightPalette.textPrimary.withAlpha(200),
  ),
);

/// ===== Theme Builder (M3 최소 ColorScheme + 팔레트 오버라이드) =====
ThemeData buildLightTheme({String fontFamily = 'NanumSquareNeo'}) {
  final text = lightTextTheme(fontFamily);

  // 최소 ColorScheme: primary/secondary/on* 대비만 맞춰서 지정
  final scheme = const ColorScheme.light().copyWith(
    primary: LightPalette.mainGreen,
    onPrimary: LightPalette.textPrimary,
    secondary: LightPalette.gray,
    surface: LightPalette.greenBackground,
    onSurface: LightPalette.textPrimary,
    error: LightPalette.mainRed,
    onError: LightPalette.textPrimary,
    outline: LightPalette.lineGray,
  );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: LightPalette.greenBackground,
    textTheme: text.copyWith(
      bodyLarge: text.headlineSmall,
      bodyMedium: text.headlineSmall,
      bodySmall: text.headlineSmall,
    ),

    // ===== AppBarTheme
    appBarTheme: AppBarTheme(
      backgroundColor: LightPalette.greenBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: LightPalette.textPrimary),
      titleTextStyle: text.headlineMedium,
    ),

    dividerTheme: const DividerThemeData(
      color: LightPalette.lineGray,
      thickness: 1,
      space: 1,
    ),
  );

  return base;
}

/*
final theme = Theme.of(context);
final textTheme = theme.textTheme;
final scheme = theme.colorScheme;
 */
