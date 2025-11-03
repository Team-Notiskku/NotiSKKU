import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notiskku/screen/screen_intro.dart';
import 'package:notiskku/screen/screen_main_tabs.dart';
import 'package:notiskku/services/preferences_app.dart';

// 3초 후 넘어가는 초록색 NotiSKKU 로고 페이지
class ScreenLogoIntro extends StatefulWidget {
  const ScreenLogoIntro({super.key});

  @override
  State<ScreenLogoIntro> createState() => _ScreenLogoIntroState();
}

class _ScreenLogoIntroState extends State<ScreenLogoIntro> {
  @override
  void initState() {
    super.initState();

    // Future.delayed(const Duration(seconds: 1), () {
    //   if (!mounted) return;
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => const ScreenIntro()),
    //   );
    // });

    Future.delayed(const Duration(seconds: 1), () async {
      final isFirst = await AppPreferences.isFirstLaunch();

      if (isFirst) {
        // await AppPreferences.isFirstLaunch();
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ScreenIntro()),
        );
      } else {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ScreenMainTabs()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0b5b42),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 195.w,
              child: Image.asset(
                'assets/images/whitelogo_fix.png',
                width: 110.w, // 반응형 너비
                height: 130.h, // 반응형 높이
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              child: Text(
                'NotiSKKU',
                style: TextStyle(
                  fontSize: 44.sp, // 반응형 폰트 크기
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
