import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenIntroThree extends StatelessWidget {
  const ScreenIntroThree({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 35.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 65.h),
          RichText(
            text: TextSpan(
              style: textTheme.headlineMedium?.copyWith(fontSize: 24.sp),
              children: [
                TextSpan(text: '중요한 소식, 내가 먼저!'),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Image.asset(
                    'assets/images/medal.png',
                    width: 35.w,
                    height: 35.h,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            '필요한 알림만 받을 수 있어요.',
            style: textTheme.headlineSmall?.copyWith(fontSize: 17.sp),
          ),
          SizedBox(height: 49.h),
          Center(
            child: Image.asset(
              'assets/images/third_fix.png',
              width: 204.w,
              height: 202.h,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
