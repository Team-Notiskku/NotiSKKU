import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// ===== Palette (Dark) =====
class DarkPalette {
  static const greenBackground = Color(0xFF17171B); // 배경
  static const textPrimary = Color(0xFFFAFAF8); // 일반 텍스트
  static const lineGray = Color(0xFFD9D9D9); // 구분선, 회색 텍스트
  static const gray = Color(0xFF555555); // 회색 보조

  static const mainGreen = Color(0xFF14DF8E); // 메인 초록 (버튼/포커스)
  static const subGreen = Color(0xFF0B5B42); // 서브 초록 (링크/포인트)

  static const mainRed = Color(0xFFC94848); // 삭제/에러
  static const subRed = Color(0xFFA01210); // 경고/취소 텍스트
}

/// ===== Typography (Dark) =====
TextTheme darkTextTheme(String fontFamily) => TextTheme(
  // Display / Headline
  headlineLarge: TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w900,
    fontSize: 25.sp,
    color: DarkPalette.textPrimary,
  ),
  headlineMedium: TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 18.sp,
    color: DarkPalette.textPrimary,
  ),
  headlineSmall: TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
    color: DarkPalette.textPrimary,
  ),

  bodyMedium: TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 15.sp,
    color: DarkPalette.textPrimary,
  ),
  labelSmall: TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w100,
    fontSize: 13.sp,
    // 살짝 투명도로 보조 톤
    color: DarkPalette.textPrimary.withAlpha(200),
  ),
);

/// ===== Theme Builder (M3 최소 ColorScheme + 팔레트 오버라이드) =====
ThemeData buildDarkTheme({String fontFamily = 'NanumSquareNeo'}) {
  final text = darkTextTheme(fontFamily);

  // 대비(contrast) 확보: on*는 밝은 톤 사용
  final scheme = const ColorScheme.dark().copyWith(
    primary: DarkPalette.mainGreen,
    onPrimary: DarkPalette.textPrimary, // 버튼 내부 텍스트 등
    secondary: DarkPalette.gray,
    surface: DarkPalette.greenBackground,
    onSurface: DarkPalette.textPrimary,
    error: DarkPalette.mainRed,
    onError: DarkPalette.textPrimary,
    outline: DarkPalette.lineGray,
  );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: DarkPalette.greenBackground,
    textTheme: text.copyWith(
      bodyLarge: text.headlineSmall,
      bodyMedium: text.headlineSmall,
      bodySmall: text.headlineSmall,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: DarkPalette.greenBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: DarkPalette.textPrimary),
      titleTextStyle: text.headlineMedium,
    ),

    dividerTheme: const DividerThemeData(
      color: DarkPalette.lineGray,
      thickness: 1,
      space: 1,
    ),
  );

  return base;
}
