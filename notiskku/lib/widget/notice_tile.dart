import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/data/temp_starred_notices.dart';
import 'package:notiskku/notice_functions/launch_url.dart';
import 'package:notiskku/providers/tab_providers.dart';
import 'package:notiskku/providers/user/user_provider.dart';

class NoticeTile extends ConsumerStatefulWidget {
  final Map<String, dynamic> notice;

  const NoticeTile({super.key, required this.notice});

  @override
  ConsumerState<NoticeTile> createState() => _NoticeTileState();
}

class _NoticeTileState extends ConsumerState<NoticeTile> {
  final launchUrlService = LaunchUrlService();

  // 메인 홈 탭 인덱스(필요 시 프로젝트에 맞게 변경)
  static const int MAIN_HOME_TAB_INDEX = 0;

  @override
  Widget build(BuildContext context) {
    final hash = widget.notice['hash'] ?? '';
    final title = widget.notice['title'] ?? '';
    final date = widget.notice['date'] ?? '';
    final views = widget.notice['views'] ?? '';
    final link = widget.notice['url'] ?? '';

    final userState = ref.watch(userProvider);
    final starredNotices = userState.starredNotices;
    final currentTab = ref.watch(tabIndexProvider);

    // 현재 별 상태가 "채움"인지 판정
    // (기존 아이콘 렌더링 로직과 동일하게 맞춰서 판정)
    final bool isFilledNow =
        (currentTab == 2)
            ? !tempStarredNotices.contains(hash)
            : (starredNotices.contains(hash) ||
                tempStarredNotices.contains(hash));

    final bool isMainHome = (currentTab == MAIN_HOME_TAB_INDEX);

    return Column(
      children: [
        ListTile(
          title: Text(title, style: TextStyle(fontSize: 15.sp)),
          subtitle: Text(
            views == 'null' ? '$date | 조회수: -' : '$date | 조회수: $views',
            style: TextStyle(fontSize: 14.sp),
          ),
          trailing: GestureDetector(
            onTap: () async {
              // 규칙:
              // 1) 메인 홈 && 채운 별 → 빈 별 : 즉시 영구 반영 (unstar)
              // 2) 그 외: 기존 로직 유지 (tempStarredNotices 토글만)
              if (isMainHome && isFilledNow) {
                try {
                  // 영구 삭제
                  ref.read(userProvider.notifier).unstarNotice(hash);

                  // 화면상 임시상태가 남아있지 않도록 안전 제거
                  tempStarredNotices.remove(hash);

                  if (mounted) setState(() {});
                } catch (e) {
                  // 혹시 실패하면 기존 임시 토글로 폴백
                  setState(() {
                    tempStarredNotices.remove(hash);
                  });
                }
              } else {
                // 기존 임시 토글 유지
                setState(() {
                  if (tempStarredNotices.contains(hash)) {
                    tempStarredNotices.remove(hash);
                  } else {
                    tempStarredNotices.add(hash);
                  }
                });
              }
            },
            child: Image.asset(
              (currentTab == 2)
                  ? !tempStarredNotices.contains(hash)
                      ? 'assets/images/fullstar_fix.png'
                      : 'assets/images/emptystar_fix.png'
                  : (starredNotices.contains(hash) ||
                      tempStarredNotices.contains(hash))
                  ? 'assets/images/fullstar_fix.png'
                  : 'assets/images/emptystar_fix.png',
              width: 26.w,
              height: 26.h,
            ),
          ),
          onTap: () => launchUrlService.launchURL(link),
        ),
        Divider(thickness: 1.h, indent: 16.w, endIndent: 16.w),
      ],
    );
  }
}
