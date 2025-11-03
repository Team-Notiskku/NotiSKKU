import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notiskku/screen/screen_intro_ready.dart';
import 'package:notiskku/screen/screen_intro_select.dart';
import 'package:notiskku/widget/button/wide_green.dart';
import 'package:notiskku/widget/button/wide_grey.dart';
import 'package:notiskku/screen/screen_intro_one.dart';
import 'package:notiskku/screen/screen_intro_two.dart';
import 'package:notiskku/screen/screen_intro_three.dart';

class ScreenIntro extends StatefulWidget {
  const ScreenIntro({super.key});

  @override
  State<ScreenIntro> createState() => _ScreenIntroSliderState();
}

class _ScreenIntroSliderState extends State<ScreenIntro> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Widget> _slides = const [
    ScreenIntroOne(),
    ScreenIntroTwo(),
    ScreenIntroThree(),
  ];

  void _onNext() {
    if (_currentPage < _slides.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // SizedBox(height: 60.h),
            // 슬라이드 영역
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (_, index) => _slides[index],
              ),
            ),

            // 인디케이터
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13.w),
                  child: Container(
                    width: 10.w,
                    height: 10.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          _currentPage == index
                              ? scheme.primary
                              : scheme.outline,
                    ),
                  ),
                );
              }),
            ),

            SizedBox(height: 60.h),

            // 버튼
            if (_currentPage == _slides.length - 1) ...[
              Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: WideGrey(
                  text: '다음에 설정하기',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ScreenIntroReady(),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: WideGreen(
                  text: '학과 / 키워드 설정하기',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ScreenIntroSelect(),
                      ),
                    );
                  },
                ),
              ),
            ] else
              Column(
                children: [
                  SizedBox(height: 52.h),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: WideGreen(text: '다음으로', onPressed: _onNext),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
