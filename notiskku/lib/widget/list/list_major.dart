import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/data/major_data.dart';
import 'package:notiskku/providers/user/user_provider.dart';
import 'package:notiskku/widget/dialog/dialog_limit_major.dart';
import 'package:notiskku/widget/list/list_selected_major.dart';
import 'package:notiskku/widget/search/search_major.dart';

class ListMajor extends ConsumerWidget {
  const ListMajor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final userNotifier = ref.read(userProvider.notifier);

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final scheme = theme.colorScheme;

    final filteredAndSorted =
        majors
            .where(
              (m) => m.major.toLowerCase().contains(
                userState.currentSearchText.toLowerCase(),
              ),
            )
            .toList()
          ..sort((a, b) => a.major.compareTo(b.major));

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
          child: const SearchMajor(),
        ),

        // 상단 선택 리스트: 고정 높이(내용만), 스크롤 없음
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: const ListSelectedMajor(),
        ),

        // 하단 메인 리스트만 스크롤
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
            itemCount: filteredAndSorted.length,
            itemBuilder: (context, index) {
              final majorObj = filteredAndSorted[index];
              final major = majorObj.major;
              final isSelected = userState.selectedMajors.any(
                (m) => m.major == major,
              );

              return GestureDetector(
                onTap: () {
                  if (!isSelected && userState.selectedMajors.length >= 2) {
                    final currentMajors =
                        userState.selectedMajors.map((m) => m.major).toList()
                          ..sort();
                    _showLimitDialog(context, currentMajors);
                    return;
                  }
                  userNotifier.toggleMajor(majorObj);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 7.h,
                    horizontal: 10.w,
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: scheme.secondary, width: 1.5),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        major,
                        style: textTheme.headlineMedium?.copyWith(
                          color: isSelected ? scheme.primary : scheme.outline,
                        ),
                      ),
                      if (isSelected)
                        Icon(Icons.check, color: scheme.primary, size: 20.w),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showLimitDialog(BuildContext context, List<String> selectedMajors) {
    showDialog(
      context: context,
      builder: (context) => DialogLimitMajor(selectedMajors: selectedMajors),
    );
  }
}
