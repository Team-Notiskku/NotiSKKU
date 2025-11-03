import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notiskku/data/temp_starred_notices.dart';
import 'package:notiskku/models/keyword.dart';
import 'package:notiskku/providers/user/user_provider.dart';
import 'package:notiskku/widget/side_scroll.dart';

// 선택된 키워드 상태 관리용 Provider
final selectedKeywordProvider = StateProvider<Keyword?>((ref) {
  final user = ref.watch(userProvider);
  if (user.selectedKeywords.isNotEmpty) {
    return user.selectedKeywords.first;
  } else {
    return null;
  }
});

class BarKeywords extends ConsumerStatefulWidget {
  const BarKeywords({super.key});

  @override
  ConsumerState<BarKeywords> createState() => _BarKeywordsState();
}

class _BarKeywordsState extends ConsumerState<BarKeywords> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final userState = ref.watch(userProvider);
    final savedKeywordList = userState.selectedKeywords;
    final selectedKeyword = ref.watch(selectedKeywordProvider);

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 11.w),
            child: Text(
              '키워드 별 보기',
              style: textTheme.headlineMedium?.copyWith(fontSize: 16.sp),
            ),
          ),
        ),
        SizedBox(height: 3.h),
        Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(savedKeywordList.length, (index) {
                    final keyword = savedKeywordList[index];
                    final isSelected = keyword == selectedKeyword;

                    return Padding(
                      padding: EdgeInsets.only(left: 7.w),
                      child: GestureDetector(
                        onTap: () {
                          ref
                              .read(userProvider.notifier)
                              .saveTempStarred(tempStarredNotices);
                          ref.read(selectedKeywordProvider.notifier).state =
                              keyword;
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 25.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? scheme.primary.withOpacity(0.7)
                                    : scheme.secondary.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            keyword.keyword,
                            style: textTheme.labelSmall?.copyWith(
                              color:
                                  isSelected ? scheme.surface : scheme.outline,
                              fontWeight: FontWeight.w800,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            SideScroll(scrollController: _scrollController),
          ],
        ),
      ],
    );
  }
}
