import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/data/temp_starred_notices.dart';
import 'package:notiskku/providers/bar_providers.dart';
import 'package:notiskku/providers/user/user_provider.dart';

// 학교 | 단과대학 | 학과
class BarNotices extends ConsumerWidget {
  const BarNotices({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final scheme = theme.colorScheme;

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
            color: scheme.outline,
          );
        } else {
          Notices currentNotice = Notices.values[index ~/ 2];
          return Expanded(
            // 학교, 단과대학, 학과
            child: GestureDetector(
              onTap: () {
                ref
                    .read(userProvider.notifier)
                    .saveTempStarred(tempStarredNotices);
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
                            ? scheme.primary.withAlpha(35)
                            : null,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Text(
                      _getNoticeLabel(currentNotice),
                      style: textTheme.headlineSmall?.copyWith(
                        color:
                            selectedNotice == currentNotice
                                ? scheme.primary
                                : scheme.outline,
                        fontWeight:
                            selectedNotice == currentNotice
                                ? FontWeight.w800
                                : FontWeight.w400,
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
