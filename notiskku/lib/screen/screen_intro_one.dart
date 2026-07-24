import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 성균관대 공지사항 어플 NotiSKKU를 소개합니다!
class ScreenIntroOne extends StatelessWidget {
  const ScreenIntroOne({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final scheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 35.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 65.h),
          Text('성균관대 공지사항 어플', style: textTheme.headlineMedium),
          SizedBox(height: 2.h),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'NotiSKKU',
                  style: textTheme.headlineLarge?.copyWith(
                    color: scheme.primary,
                  ),
                ),
                TextSpan(text: '를 소개합니다!', style: textTheme.headlineMedium),
              ],
            ),
          ),
          SizedBox(height: 52.h),
          Center(
            child: Image.asset(
              'assets/images/first_fix.png',
              width: 206.w,
              height: 202.h,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
