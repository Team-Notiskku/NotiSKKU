import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notiskku/screen/screen_main_tabs.dart';
import 'package:notiskku/widget/button/wide_green.dart';
import 'package:notiskku/services/preferences_app.dart';

class ScreenIntroReady extends StatelessWidget {
  const ScreenIntroReady({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final scheme = theme.colorScheme;

    return PopScope(
      canPop: false, // 뒤로가기 차단
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 60.h), // 반응형 상단 여백
              Column(
                children: [
                  Image.asset(
                    'assets/images/fourth_fix.png',
                    height: 170.h,
                    width: 170.h,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 23.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '이제 준비가 완료되었습니다! ',
                        style: textTheme.headlineMedium?.copyWith(
                          color: scheme.primary,
                        ),
                      ),
                      Text('🎉', style: TextStyle(fontSize: 16.sp)),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: WideGreen(
                  text: '나의 공지 보러가기',
                  onPressed: () async {
                    await AppPreferences.setFirstLaunch();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScreenMainTabs(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
