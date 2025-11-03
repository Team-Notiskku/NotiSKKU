import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogNoAlarm extends StatelessWidget {
  final VoidCallback onConfirm;

  const DialogNoAlarm({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final scheme = theme.colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      title: Text('알림 설정 안내', style: textTheme.headlineMedium),
      content: Text(
        '선택한 학과와 키워드가 없어 알림이 발송되지 않습니다.\n그래도 계속하시겠습니까?',
        style: textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700),
      ),
      actions: [
        TextButton(
          // 취소: false 반환 → 호출부에서 복원 로직 수행
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            '취소',
            style: textTheme.headlineMedium?.copyWith(
              color: scheme.error,
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        TextButton(
          // 확인: true 반환 → 호출부에서 커밋 & 다음 화면 이동
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirm(); // 필요 시 부가 사이드 이펙트 유지
          },
          child: Text(
            '확인',
            style: textTheme.headlineMedium?.copyWith(
              color: scheme.primary,
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
