import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/recent_search_provider.dart';

class ListRecentSearch extends ConsumerStatefulWidget {
  const ListRecentSearch({super.key});

  @override
  ListRecentSearchState createState() => ListRecentSearchState();
}

class ListRecentSearchState extends ConsumerState<ListRecentSearch> {
  @override
  Widget build(BuildContext context) {
    final searchedTexts = ref.watch(recentSearchProvider).searchedTexts;

    return Flexible(
      child: ListView.builder(
        itemCount: searchedTexts.length,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemBuilder: (BuildContext context, int index) {
          final reversedIndex = searchedTexts.length - 1 - index;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            margin: EdgeInsets.symmetric(vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0x99D9D9D9),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  searchedTexts[reversedIndex],
                  style: TextStyle(color: Colors.black, fontSize: 15.sp),
                ),
                GestureDetector(
                  onTap: () {
                    ref
                        .read(recentSearchProvider.notifier)
                        .deleteWord(searchedTexts[reversedIndex]);
                  },
                  child: Icon(Icons.close, color: Colors.black, size: 20.w),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
