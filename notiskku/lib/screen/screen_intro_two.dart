import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenIntroTwo extends StatelessWidget {
  const ScreenIntroTwo({super.key});

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
                TextSpan(text: '공지사항도 내 스타일로! '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Image.asset(
                    'assets/images/magic_wand.png',
                    width: 28.w,
                    height: 28.h,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            '원하는 소식만 확인할 수 있어요.',
            style: textTheme.headlineSmall?.copyWith(fontSize: 17.sp),
          ),
          SizedBox(height: 50.h),
          Center(
            child: Image.asset(
              'assets/images/second_fix.png',
              width: 197.w,
              height: 202.h,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
