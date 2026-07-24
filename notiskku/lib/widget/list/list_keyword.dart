import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notiskku/data/keyword_data.dart';
import 'package:notiskku/providers/user/user_provider.dart';

class ListKeyword extends ConsumerWidget {
  final String searchText;

  const ListKeyword({super.key, required this.searchText});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final userNotifier = ref.read(userProvider.notifier);

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final scheme = theme.colorScheme;

    final filteredKeywords =
        keywords.where((k) {
          return k.keyword.toLowerCase().contains(searchText.toLowerCase());
        }).toList();

    final selectedKeywords = userState.selectedKeywords;

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
      itemCount: filteredKeywords.length,
      itemBuilder: (context, index) {
        final keyword = filteredKeywords[index];
        final isSelected = selectedKeywords
            .map((k) => k.keyword)
            // .contains(keyword.toString());
            .contains(keyword.keyword);

        return Column(
          children: [
            GestureDetector(
              onTap: () {
                userNotifier.toggleKeyword(keyword);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 10.w),
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
                      keyword.keyword,
                      style: textTheme.headlineMedium?.copyWith(
                        color: isSelected ? scheme.primary : scheme.outline,
                      ),
                    ),
                    if (isSelected)
                      Icon(Icons.check, color: scheme.primary, size: 20.w),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
