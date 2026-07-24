import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/data/temp_starred_notices.dart';
import 'package:notiskku/notice_functions/launch_url.dart';
import 'package:notiskku/providers/tab_providers.dart';
import 'package:notiskku/providers/user/user_provider.dart';

import 'package:notiskku/providers/read_notices_provider.dart';

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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final scheme = theme.colorScheme;

    final hash = widget.notice['hash'] ?? '';
    final title = widget.notice['title'] ?? '';
    final date = widget.notice['date'] ?? '';
    final views = widget.notice['views'] ?? '';
    final link = widget.notice['url'] ?? '';

    final userState = ref.watch(userProvider);
    final starredNotices = userState.starredNotices;
    final currentTab = ref.watch(tabIndexProvider);

    final readNotices = ref.watch(readNoticesProvider);
    final bool isRead = readNotices.contains(hash);

    // ====== [NEW 뱃지용 최근 7일 판정] ======
    bool isNew = false;
    if (date is String && date.isNotEmpty) {
      try {
        // 예: "2025.11.27 14:03", "2025-11-27" 등 대응
        String normalized = date.trim();
        if (normalized.contains('.')) {
          normalized = normalized.replaceAll('.', '-');
        }
        // 뒤에 시간 잘려도 되므로 앞 10자리만 사용 (yyyy-MM-dd)
        if (normalized.length >= 10) {
          normalized = normalized.substring(0, 10);
        }
        final noticeDate = DateTime.parse(normalized);
        final diffDays = DateTime.now().difference(noticeDate).inDays;
        // 오늘(0일) ~ 6일 전까지 => 최근 7일
        isNew = diffDays >= 0 && diffDays < 7;
      } catch (_) {
        isNew = false;
      }
    }

    // 현재 별 상태가 "채움"인지 판정
    final bool isFilledNow =
        (currentTab == 2)
            ? !tempStarredNotices.contains(hash)
            : (starredNotices.contains(hash) ||
                tempStarredNotices.contains(hash));

    final bool isMainHome = (currentTab == MAIN_HOME_TAB_INDEX);

    // 한글 줄바꿈 개선 함수
    String applyWordBreakFix(String text) {
      final RegExp emoji = RegExp(
        r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])',
      );
      String fullText = '';
      List<String> words = text.split(' ');
      for (var i = 0; i < words.length; i++) {
        fullText +=
            emoji.hasMatch(words[i])
                ? words[i]
                : words[i].replaceAllMapped(
                  RegExp(r'(\S)(?=\S)'),
                  (m) => '${m[1]}\u200D',
                );
        if (i < words.length - 1) fullText += ' ';
      }
      return fullText;
    }

    return Column(
      children: [
        ListTile(
          title: Padding(
            padding: const EdgeInsets.only(
              left: 1.0,
              right: 1.0,
              top: 4.0,
              bottom: 3.0,
            ),
            // ====== 제목 + NEW 뱃지 Row ======
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    applyWordBreakFix(title),
                    style: textTheme.headlineMedium?.copyWith(
                      fontSize: 12.sp,
                      height: 1.5,
                      fontWeight: isRead ? FontWeight.w400 : FontWeight.w600,
                      color:
                          isRead
                              ? textTheme.bodySmall?.color?.withAlpha(180)
                              : null,
                    ),
                  ),
                ),
                if (isNew) ...[
                  SizedBox(width: 6.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 2.h,
                    ),
                    child: Text(
                      'NEW',
                      style: textTheme.labelSmall?.copyWith(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w700,
                        color: scheme.error,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              views == 'null' ? '$date | 조회수: -' : '$date | 조회수: $views',
              style: textTheme.labelSmall?.copyWith(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
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
              width: 23.w,
              height: 23.h,
              color: scheme.primary,
            ),
          ),
          onTap: () async {
            // 1) 읽음으로 표시
            await ref.read(readNoticesProvider.notifier).markAsRead(hash);

            // 2) 실제 공지 링크 열기
            await launchUrlService.launchURL(link);
          },
        ),
        Divider(thickness: 1.h, indent: 16.w, endIndent: 16.w),
      ],
    );
  }
}
