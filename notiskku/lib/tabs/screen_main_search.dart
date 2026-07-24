import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/edit/screen_main_major_edit.dart';
import 'package:notiskku/providers/bar_providers.dart';
import 'package:notiskku/providers/selected_major_provider.dart';
import 'package:notiskku/providers/user/user_provider.dart';
import 'package:notiskku/widget/bar/bar_notices.dart';
import 'package:notiskku/widget/list/list_recent_search.dart';
import 'package:notiskku/widget/list/list_search_results.dart';
import 'package:notiskku/widget/search/search_notice.dart';

class ScreenMainSearch extends ConsumerStatefulWidget {
  const ScreenMainSearch({super.key});

  @override
  ScreenMainSearchState createState() => ScreenMainSearchState();
}

class ScreenMainSearchState extends ConsumerState<ScreenMainSearch> {
  String searchText = '';
  bool isSearched = false;

  void updateSearch(String newText, bool searched) {
    setState(() {
      searchText = newText;
      isSearched = searched;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final typeState = ref.watch(barNoticesProvider);
    final userState = ref.watch(userProvider);
    final majorIndex = ref.watch(selectedMajorIndexProvider);

    final hasMajor = userState.selectedMajors.isNotEmpty;

    String hintText = '검색어를 입력하세요.';
    if (hasMajor && typeState == Notices.dept) {
      hintText = '${userState.selectedMajors[majorIndex].department} 내 검색';
    } else if (hasMajor && typeState == Notices.major) {
      hintText = '${userState.selectedMajors[majorIndex].major} 내 검색';
    }

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          BarNotices(),
          SizedBox(height: 5.h),
          if (typeState != Notices.common && !hasMajor)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/no_major_exception.png',
                      width: 206.w,
                      height: 202.h,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      '학과를 선택해야 검색할 수 있어요.',
                      style: TextStyle(fontSize: 14.sp),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ScreenMainMajorEdit(),
                          ),
                        );
                      },
                      child: Text(
                        '→ 학과 선택하러 가기',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: Column(
                children: [
                  SearchNotice(onSearch: updateSearch, hintText: hintText),
                  SizedBox(height: 5.h),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    padding: EdgeInsets.all(5.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        isSearched ? "‘$searchText’에 대한 검색 결과" : '최근 검색 내역',
                        style: textTheme.headlineMedium?.copyWith(
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child:
                        isSearched
                            ? ListSearchResults(
                              searchText: searchText,
                              typeState: typeState,
                            )
                            : ListRecentSearch(
                              onTapRecentSearch:
                                  (text) => updateSearch(text, true),
                            ),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: scheme.outline),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text('검색'),
      centerTitle: true,
      actions: [SizedBox(width: 40.w)],
    );
  }
}
