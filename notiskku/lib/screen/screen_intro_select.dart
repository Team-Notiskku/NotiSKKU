import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/user/user_provider.dart';
import 'package:notiskku/widget/grid/grid_keywords.dart';
import 'package:notiskku/widget/bar/bar_settings.dart';
import 'package:notiskku/widget/list/list_major.dart';
import 'package:notiskku/widget/button/wide_condition.dart';
import 'package:notiskku/providers/bar_providers.dart';
import 'package:notiskku/screen/screen_intro_alarm.dart';

// 관심 학과와 키워드를 선택해주세요
class ScreenIntroSelect extends ConsumerWidget {
  const ScreenIntroSelect({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsType = ref.watch(settingsProvider);
    final userState = ref.watch(userProvider);

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // '설정완료' 버튼 활성화 조건: 학과 1개 이상 + 키워드 1개 이상 선택
    final isButtonEnabled =
        userState.selectedMajors.isNotEmpty &&
        (userState.doNotSelectKeywords ||
            userState.selectedKeywords.isNotEmpty);

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 30.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 41.w),
                child: Text(
                  '관심 학과와 키워드를 선택해주세요😀\n(학과는 최대 2개까지 가능)',
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: const BarSettings.barSettings(),
            ), // 학과|키워드
            Expanded(
              child:
                  settingsType == Settings.major
                      ? const ListMajor() // 전체 전공 리스트 보여주기
                      : const GridKeywords(), // 전체 키워드 그리드 보여주기
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: WideCondition(
                text: '설정 완료',
                isEnabled: isButtonEnabled,
                onPressed:
                    isButtonEnabled
                        ? () {
                          ref.read(userProvider.notifier).updateSearchText('');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      const ScreenIntroAlarm(isFromIntro: true),
                            ),
                          );
                        }
                        : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
