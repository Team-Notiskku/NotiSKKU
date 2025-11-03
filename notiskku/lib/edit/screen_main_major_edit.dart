import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:notiskku/models/major.dart';
import 'package:notiskku/providers/user/user_provider.dart';
import 'package:notiskku/widget/button/wide_condition.dart';
import 'package:notiskku/widget/list/list_major.dart';
import 'package:notiskku/screen/screen_intro_loading.dart';
import 'package:notiskku/widget/dialog/dialog_not_saved.dart'; // ✅ 추가

class ScreenMainMajorEdit extends ConsumerStatefulWidget {
  const ScreenMainMajorEdit({super.key});

  @override
  ConsumerState<ScreenMainMajorEdit> createState() =>
      _ScreenMainMajorEditState();
}

class _ScreenMainMajorEditState extends ConsumerState<ScreenMainMajorEdit> {
  late final List<Major> _originalMajors; // 입장 시 스냅샷
  bool _committed = false; // 완료 저장 여부

  @override
  void initState() {
    super.initState();
    final current = ref.read(userProvider).selectedMajors;
    _originalMajors = current
        .map(
          (m) => Major(
            id: m.id,
            department: m.department,
            major: m.major,
            receiveNotification: m.receiveNotification,
          ),
        )
        .toList(growable: false);
  }

  void _restoreIfNotCommitted() {
    if (_committed) return;
    ref.read(userProvider.notifier).replaceSelectedMajors(_originalMajors);
  }

  Future<void> _handleBack() async {
    if (_committed) {
      if (mounted) Navigator.pop(context);
      return;
    }
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

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    final isButtonEnabled = userState.selectedMajors.isNotEmpty;

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return PopScope(
      canPop: false, // ⛳️ 뒤로가기를 우리가 직접 처리
      onPopInvoked: (didPop) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 24.w),
            onPressed: _handleBack, // ✅ 앱바 뒤로가기도 동일 처리
          ),
          title: Text('학과 선택 편집'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(height: 10.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(
                  '관심 학과를 선택해주세요😀\n(학과는 최대 2개까지 가능)',
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            const Expanded(child: ListMajor()),
            SizedBox(height: 30.h),
            WideCondition(
              text: '설정 완료',
              isEnabled: isButtonEnabled,
              onPressed:
                  isButtonEnabled
                      ? () async {
                        final user = ref.read(userProvider);

                        debugPrint('-----------------------------');
                        debugPrint(
                          '⚙️ [ScreenMainMajorEdit] 학과 편집 완료 → 로딩 화면으로 이동',
                        );
                        debugPrint(
                          '선택된 학과: ${user.selectedMajors.map((m) => m.major).join(", ")}',
                        );
                        debugPrint(
                          '알림 설정(major): '
                          '${user.selectedMajors.map((m) => "${m.major}=${m.receiveNotification}").join(", ")}',
                        );
                        debugPrint('-----------------------------');

                        _committed = true; // ✅ 완료 확정 → 뒤로가기 시 원복/다이얼로그 방지

                        if (!mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => const ScreenIntroLoading(
                                  isFromAlarm: false,
                                ),
                          ),
                        );
                      }
                      : null,
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
