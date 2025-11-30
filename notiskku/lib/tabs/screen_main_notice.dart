import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/data/major_data.dart';
import 'package:notiskku/data/temp_starred_notices.dart';
import 'package:notiskku/edit/screen_main_major_edit.dart';
import 'package:notiskku/models/major.dart';
import 'package:notiskku/providers/bar_providers.dart';
import 'package:notiskku/providers/selected_major_provider.dart';
import 'package:notiskku/providers/user/user_provider.dart';
import 'package:notiskku/tabs/screen_main_search.dart';
import 'package:notiskku/widget/bar/bar_categories.dart';
import 'package:notiskku/widget/bar/bar_notices.dart';
import 'package:notiskku/widget/list/list_notices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class _NoticeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const _NoticeAppBar();

  void _updateMajorIndex(WidgetRef ref, bool isLeft, int listLength) {
    final notifier = ref.read(selectedMajorIndexProvider.notifier);
    final currentIndex = ref.read(selectedMajorIndexProvider);

    final newIndex =
        isLeft
            ? (currentIndex - 1 + listLength) % listLength
            : (currentIndex + 1) % listLength;

    notifier.state = newIndex;
    ref.read(userProvider.notifier).saveTempStarred(tempStarredNotices);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final userState = ref.watch(userProvider);
    final majorIndex = ref.watch(selectedMajorIndexProvider);
    final typeState = ref.watch(barNoticesProvider); // ✅ 추가
    final isCommon = typeState == Notices.common; // ✅ 추가

    // currentMajor에 현재 화면에 렌더링 되는 학과가 선택됨
    String currentMajor = '';
    String currentDepartment = '';

    if (userState.selectedMajors.isNotEmpty) {
      final selected =
          userState.selectedMajors[majorIndex.clamp(
            0,
            userState.selectedMajors.length - 1,
          )];
      currentMajor = selected.major;
      currentDepartment = selected.department;
    }

    return AppBar(
      leading: Padding(
        padding: EdgeInsets.all(15.0),
        child: Image.asset(
          'assets/images/green_logo_2025.png',
          width: 28.w,
          color: scheme.primary,
        ),
      ),
      title:
          isCommon
              ? Text('성균관대학교')
              : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 좌측 화살표
                  userState.selectedMajors.length > 1
                      ? IconButton(
                        icon: Icon(Icons.chevron_left, size: 24.w),
                        onPressed: () {
                          _updateMajorIndex(
                            ref,
                            true,
                            userState.selectedMajors.length,
                          );
                          ref
                              .read(userProvider.notifier)
                              .saveTempStarred(tempStarredNotices);
                        },
                        // splashRadius: 20.r, // 터치 효과 반경 조정 (선택사항임)
                      )
                      : const SizedBox.shrink(),
                  // 학과 명
                  userState.selectedMajors.isEmpty
                      ? Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '학과를 선택해 주세요',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                      : Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            typeState == Notices.dept
                                ? currentDepartment // 단과대 공지 → 학과대학 이름 표시
                                : currentMajor, // 학과 공지 → 학과 이름 표시
                          ),
                        ),
                      ),
                  // 우측 화살표
                  userState.selectedMajors.length > 1
                      ? IconButton(
                        icon: Icon(Icons.chevron_right, size: 24.w),
                        onPressed: () {
                          _updateMajorIndex(
                            ref,
                            false,
                            userState.selectedMajors.length,
                          );
                          ref
                              .read(userProvider.notifier)
                              .saveTempStarred(tempStarredNotices);
                        },
                        // splashRadius: 20.r,
                      )
                      : const SizedBox.shrink(),
                ],
              ),
      actions: [
        Padding(
          padding: EdgeInsets.all(15.0),
          child: GestureDetector(
            onTap: () {
              ref
                  .read(userProvider.notifier)
                  .saveTempStarred(tempStarredNotices);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScreenMainSearch()),
              );
            },
            child: Image.asset(
              'assets/images/search_fix.png',
              width: 30.w,
              color: scheme.outline,
            ),
          ),
        ),
      ],
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ScreenMainNotice extends ConsumerWidget {
  const ScreenMainNotice({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final majorIndex = ref.watch(selectedMajorIndexProvider);
    final typeState = ref.watch(barNoticesProvider);

    final currentMajor =
        userState.selectedMajors.isEmpty
            ? ''
            : userState
                .selectedMajors[majorIndex.clamp(
                  0,
                  userState.selectedMajors.length - 1,
                )]
                .major;

    final currentDept =
        majors
            .firstWhere(
              (m) => m.major == currentMajor,
              orElse: () => Major(id: '', department: '', major: ''), // 기본값 지정
            )
            .department;

    final currentCategory = ref.watch(barCategoriesProvider);
    String getCategory(Categories category) {
      switch (category) {
        case Categories.all:
          return '[전체]';
        case Categories.academics:
          return '[학사]';
        case Categories.admission:
          return '[입학]';
        case Categories.employment:
          return '[취업]';
        case Categories.recruitment:
          return '[채용/모집]';
        case Categories.scholarship:
          return '[장학]';
        case Categories.eventsAndSeminars:
          return '[행사/세미나]';
        case Categories.general:
          return '[일반]';
      }
    }

    Future<void> _launchURL(String url) async {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $url';
      }
    }

    Future<Widget> getNoticesWidget(
      Notices type,
      String department,
      String major,
      Categories category,
    ) async {
      late QuerySnapshot snapshot;
      final currentCategoryLabel = getCategory(currentCategory);

      final noScrapingMajors = {
        "인공지능융합전공": "https://sco.skku.edu/sco/community/major_info.do",
        "영상학과": "https://ott.skku.edu/ftm-skku-edu/notice",
        "건설환경공학부": "https://cal.skku.edu/index.php?hCode=BOARD&bo_idx=17",
        "나노공학과": "https://nano.skku.edu/bbs/board.php?tbl=bbs42",
        "화학공학/고분자공학부": "https://cheme.skku.edu/notice/",
      };

      if ((type == Notices.dept || type == Notices.major) && major == '') {
        return Center(
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
                '학과 선택 후 단과대/학과별 공지를 볼 수 있어요.',
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
        );
      }
      if (type == Notices.common) {
        if (currentCategoryLabel == '[전체]') {
          snapshot =
              await FirebaseFirestore.instance
                  .collection('notices')
                  .where('type', isEqualTo: "전체")
                  .orderBy('date', descending: true)
                  .get();
        } else {
          snapshot =
              await FirebaseFirestore.instance
                  .collection('notices')
                  .where('type', isEqualTo: "전체")
                  .where('category', isEqualTo: currentCategoryLabel)
                  .orderBy('date', descending: true)
                  .get();
        }
      } else if (type == Notices.dept) {
        snapshot =
            await FirebaseFirestore.instance
                .collection('notices')
                .where('department', isEqualTo: department)
                .orderBy('date', descending: true)
                .get();
      } else if (type == Notices.major) {
        if (noScrapingMajors.containsKey(major)) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '공지를 불러올 수 없는 학과입니다.\n하단 링크를 통해 직접 접속해 확인해주세요! 🥲',
                  style: TextStyle(fontSize: 14.sp),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                TextButton(
                  onPressed: () {
                    _launchURL(noScrapingMajors[major]!);
                  },
                  child: Text(
                    '→ 학과 게시판 바로가기',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Image.asset(
                  'assets/images/no_major_exception.png',
                  width: 206.w,
                  height: 202.h,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          );
        }
        snapshot =
            await FirebaseFirestore.instance
                .collection('notices')
                .where('major', isEqualTo: major)
                .orderBy('date', descending: true)
                .get();
      } else {
        return const Center(child: Text("잘못된 타입입니다."));
      }

      final notices =
          snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['hash'] = doc.id;
            return data;
          }).toList();

      return ListNotices(notices: notices);
    }

    return Scaffold(
      appBar: const _NoticeAppBar(),
      body: Column(
        children: [
          BarNotices(),
          SizedBox(height: 6.h),
          if (typeState == Notices.common) ...[
            BarCategories(),
            SizedBox(height: 10.h),
          ],
          Expanded(
            child: FutureBuilder<Widget>(
              future: getNoticesWidget(
                typeState,
                currentDept,
                currentMajor,
                currentCategory,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('오류 발생: ${snapshot.error}'));
                } else {
                  return snapshot.data ?? const Center(child: Text('공지 없음'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
