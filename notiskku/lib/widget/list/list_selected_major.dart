import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/user/user_provider.dart';

/// 선택된 학과(major)를 최근검색 UI와 동일한 스타일로 표시
/// - ListView → Column 기반 (부모가 스크롤 책임)
/// - 각 아이템: 가로 전체 차지, 회색 배경 + 라운드, 텍스트 + X 아이콘
class ListSelectedMajor extends ConsumerWidget {
  final void Function(String major)? onTapMajor;

  const ListSelectedMajor({super.key, this.onTapMajor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final scheme = theme.colorScheme;

    final selectedMajors = ref.watch(userProvider).selectedMajors;

    // 최신 선택이 아래로 쌓이도록 역순
    final items = selectedMajors.reversed.toList();

    return Column(
      children:
          items.map((majorObj) {
            final majorName = majorObj.major;
            return GestureDetector(
              onTap: () => onTapMajor?.call(majorName),
              child: Container(
                width: double.infinity, // 가로 전체 차지
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                margin: EdgeInsets.symmetric(vertical: 4.h),
                decoration: BoxDecoration(
                  color: scheme.primary.withAlpha(45), // 연한 primary 색상
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        majorName,
                        style: textTheme.headlineMedium?.copyWith(
                          color: scheme.primary,
                          fontSize: 14.sp,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap:
                          () => ref
                              .read(userProvider.notifier)
                              .toggleMajor(majorObj),
                      child: Icon(
                        Icons.close,
                        color: scheme.primary,
                        size: 18.w,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }
}
