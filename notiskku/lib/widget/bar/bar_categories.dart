import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/data/temp_starred_notices.dart';
import 'package:notiskku/providers/bar_providers.dart';
import 'package:notiskku/providers/user/user_provider.dart';
import 'package:notiskku/widget/side_scroll.dart';

class BarCategories extends ConsumerStatefulWidget {
  const BarCategories({super.key});

  @override
  createState() => _BarCategoriesState();
}

class _BarCategoriesState extends ConsumerState<BarCategories> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final currentCategory = ref.watch(barCategoriesProvider);
    final notifier = ref.read(barCategoriesProvider.notifier);

    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(Categories.values.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(left: 7.w),
                  child: GestureDetector(
                    onTap: () {
                      ref
                          .read(userProvider.notifier)
                          .saveTempStarred(tempStarredNotices);
                      // 선택된 카테고리 변경
                      notifier.state = Categories.values[index];
                      // 공지 리스트 강제 새로고침 (FutureProvider 다시 실행) -> provider 삭제로 오류 발생 가능성 있음(구현 안됨)
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 3.w),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 25.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color:
                              currentCategory == Categories.values[index]
                                  ? scheme.primary.withOpacity(0.7)
                                  : scheme.secondary.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          _getCategoryLabel(Categories.values[index]),
                          style: textTheme.labelSmall?.copyWith(
                            color:
                                currentCategory == Categories.values[index]
                                    ? scheme.surface
                                    : scheme.outline,
                            fontWeight: FontWeight.w800,
                          ),
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
    );
  }
}

String _getCategoryLabel(Categories category) {
  switch (category) {
    case Categories.all:
      return '전체';
    case Categories.academics:
      return '학사';
    case Categories.admission:
      return '입학';
    case Categories.employment:
      return '취업';
    case Categories.recruitment:
      return '채용/모집';
    case Categories.scholarship:
      return '장학';
    case Categories.eventsAndSeminars:
      return '행사/세미나';
    case Categories.general:
      return '일반';
  }
}
