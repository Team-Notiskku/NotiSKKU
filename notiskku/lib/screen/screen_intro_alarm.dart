import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/major_provider.dart';
// import 'package:notiskku/widget/list/alarm_major_list.dart';
// import 'package:notiskku/widget/grid/alarm_keywords_grid.dart';
// import 'package:notiskku/widget/button/alarm_complete_button.dart';
// import 'package:notiskku/providers/alarm_major_provider.dart';
// import 'package:notiskku/providers/alarm_keyword_provider.dart';

class ScreenIntroAlarm extends ConsumerWidget {
  const ScreenIntroAlarm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmMajorState = ref.watch(majorProvider);
    final alarmKeywordState = ref.watch(alarmKeywordProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 80.h),

            Text(
              '알림 받을 학과와 키워드를 선택해주세요😀\n미선택 시 알림이 발송되지 않습니다.',
              style: TextStyle(fontSize: 16.sp, fontFamily: 'GmarketSans', fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 20.h),

            Text('선택한 학과', style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 10.h),
            const AlarmMajorList(),

            SizedBox(height: 30.h),

            Text('선택한 키워드', style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 10.h),
            const Expanded(child: AlarmKeywordsGrid()),

            AlarmCompleteButton(
              isEnabled: alarmMajorState.selectedMajors.isNotEmpty || alarmKeywordState.selectedKeywords.isNotEmpty,
              onPressed: () {
                print("설정 완료!");
              },
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
