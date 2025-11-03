import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/user/user_provider.dart';

class ListRecentSearch extends ConsumerStatefulWidget {
  final void Function(String searchText)? onTapRecentSearch;
  const ListRecentSearch({super.key, this.onTapRecentSearch});

  @override
  ListRecentSearchState createState() => ListRecentSearchState();
}

class ListRecentSearchState extends ConsumerState<ListRecentSearch> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final scheme = theme.colorScheme;

    final searchedTexts = ref.watch(userProvider).recentSearchedText;

    return Flexible(
      child: ListView.builder(
        itemCount: searchedTexts.length,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemBuilder: (BuildContext context, int index) {
          final reversedIndex = searchedTexts.length - 1 - index;
          return GestureDetector(
            onTap: () {
              // 여기에 원하는 동작 작성
              widget.onTapRecentSearch?.call(searchedTexts[reversedIndex]);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              margin: EdgeInsets.symmetric(vertical: 4.h),
              decoration: BoxDecoration(
                color: scheme.secondary.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    searchedTexts[reversedIndex],
                    style: textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
                  ),
                  GestureDetector(
                    onTap: () {
                      ref
                          .read(userProvider.notifier)
                          .deleteRecentSearch(searchedTexts[reversedIndex]);
                    },
                    child: Icon(Icons.close, size: 18.w),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
