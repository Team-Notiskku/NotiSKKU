import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notiskku/models/keyword.dart';
import 'package:notiskku/models/major.dart';
import 'package:notiskku/providers/user/user_provider.dart';
import 'package:notiskku/screen/screen_intro_loading.dart';
import 'package:notiskku/widget/grid/grid_alarm_keyword.dart';
import 'package:notiskku/widget/list/list_alarm_major.dart';
import 'package:notiskku/widget/button/wide_green.dart';
import 'package:notiskku/widget/dialog/dialog_no_alarm.dart';
import 'package:notiskku/widget/dialog/dialog_not_saved.dart';

class ScreenIntroAlarm extends ConsumerStatefulWidget {
  const ScreenIntroAlarm({super.key, this.isFromIntro = false});
  final bool isFromIntro;

  @override
  ConsumerState<ScreenIntroAlarm> createState() => _ScreenIntroAlarmState();
}

class _ScreenIntroAlarmState extends ConsumerState<ScreenIntroAlarm> {
  // 입장 시 스냅샷
  late final List<Major> _originalMajors;
  late final List<Keyword> _originalKeywords;
  late final bool _originalDoNotSelect;

  bool _committed = false; // 완료 눌렀는지 (원복 방지)
  bool _restoring = false; // 원복 중 가드

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);

    // ✅ deep copy
    _originalMajors = user.selectedMajors
        .map(
          (m) => Major(
            id: m.id,
            department: m.department,
            major: m.major,
            receiveNotification: m.receiveNotification,
          ),
        )
        .toList(growable: false);

    _originalKeywords = user.selectedKeywords
        .map(
          (k) => Keyword(
            id: k.id,
            keyword: k.keyword,
            defined: k.defined,
            receiveNotification: k.receiveNotification,
          ),
        )
        .toList(growable: false);

    _originalDoNotSelect = user.doNotSelectKeywords;
  }

  void _restoreIfNotCommitted() {
    if (_committed || _restoring) return;
    _restoring = true;

    // 선택(알림 포함) 복원
    ref.read(userProvider.notifier).replaceSelectedMajors(_originalMajors);
    ref.read(userProvider.notifier).replaceSelectedKeywords(_originalKeywords);

    // replaceSelectedKeywords가 doNotSelectKeywords를 false로 만들 수 있으니 원래 값 복원
    final now = ref.read(userProvider).doNotSelectKeywords;
    if (now != _originalDoNotSelect) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(userProvider.notifier).toggleDoNotSelectKeywords();
        _restoring = false;
      });
    } else {
      _restoring = false;
    }
  }

  Future<void> _handleBack() async {
    if (_committed) {
      if (mounted) Navigator.pop(context);
      return;
    }

    // DialogNotSaved 사용
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (ctx) => DialogNotSaved(
            onConfirm: () {
              _restoreIfNotCommitted();
              if (mounted) Navigator.pop(context);
            },
          ),
    );
  }

  void _goToNext(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ScreenIntroLoading(
              isFromIntro: widget.isFromIntro,
              isFromAlarm: true,
            ),
      ),
    );
  }

  Future<void> _showNoAlarmDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true, // 바깥 탭으로 닫기 허용 → null 반환
      builder:
          (context) => DialogNoAlarm(
            // 확인 버튼 로직은 다이얼로그 내부에서 Navigator.pop(true) 호출
            onConfirm: () {
              // 다이얼로그 내부에서 pop(true)만 하고 여기선 추가 없음
            },
          ),
    );

    if (!mounted) return;

    if (result == true) {
      // ✅ 사용자가 '확인' 선택 → 다음 화면으로 이동
      _committed = true; // 이제 원복 방지
      _goToNext(context);
    } else {
      // ✅ 취소/닫기(null 포함) → 원상복구
      _restoreIfNotCommitted();
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedMajors = ref.watch(userProvider).selectedMajors;
    final selectedKeywords = ref.watch(userProvider).selectedKeywords;

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 24.w),
            onPressed: _handleBack, // ✅ 앱바 뒤로가기와 동일 처리
          ),
        ),
        body: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 31.w),
                child: Text(
                  '알림 받을 학과와 키워드를 선택해주세요😀\n미선택 시 알림이 발송되지 않습니다.',
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            SizedBox(height: 26.h),

            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(
                  '선택한 학과',
                  style: TextStyle(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            const ListAlarmMajor(),

            SizedBox(height: 26.h),

            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(
                  '선택한 키워드',
                  style: TextStyle(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            const GridAlarmKeyword(),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: WideGreen(
                text: '설정 완료',
                onPressed: () async {
                  final noMajorAlarms = selectedMajors.every(
                    (m) => m.receiveNotification == false,
                  );
                  final noKeywordAlarms = selectedKeywords.every(
                    (k) => k.receiveNotification == false,
                  );

                  if (noMajorAlarms && noKeywordAlarms) {
                    // 다이얼로그 결과에 따라 진행/복원
                    await _showNoAlarmDialog(context);
                  } else {
                    // 알림 하나라도 있으면 바로 진행 + 커밋
                    _committed = true;
                    _goToNext(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
