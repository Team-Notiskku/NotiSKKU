import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/bar_providers.dart';

// 학교 | 단과대학 | 학과
class BarNotices extends ConsumerWidget {
  const BarNotices({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedNotice = ref.watch(
      barNoticesProvider,
    ); // enum Notices {common, dept, major}
    final selectedNoticeNotifier = ref.read(barNoticesProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(Notices.values.length * 2 - 1, (index) {
        // 홀수 인덱스에는 구분선을, 짝수 인덱스에는 카테고리를 표시
        if (index % 2 == 1) {
          return Container(
            // 구분선
            width: 2.w,
            height: 20.h,
            color: Colors.grey[600],
          );
        } else {
          Notices currentNotice = Notices.values[index ~/ 2];
          return Expanded(
            // 학교, 단과대학, 학과
            child: GestureDetector(
              onTap: () {
                selectedNoticeNotifier.state = currentNotice; // 상태 변경
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  width: 106.w,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  decoration: BoxDecoration(
                    color:
                        selectedNotice == currentNotice
                            ? const Color(0xFFE8F5E9)
                            : Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Text(
                      _getNoticeLabel(currentNotice),
                      style: TextStyle(
                        color:
                            selectedNotice == currentNotice
                                ? const Color(0xFF0B5B42)
                                : Colors.grey,
                        fontWeight:
                            selectedNotice == currentNotice
                                ? FontWeight.w900
                                : FontWeight.w400,
                        fontSize: 14.sp,
                        // fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      }),
    );
  }
}

String _getNoticeLabel(Notices notice) {
  switch (notice) {
    case Notices.common:
      return '전체';
    case Notices.dept:
      return '단과대학';
    case Notices.major:
      return '학과';
  }
}
