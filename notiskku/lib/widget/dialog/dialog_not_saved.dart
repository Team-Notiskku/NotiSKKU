import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogNotSaved extends StatelessWidget {
  final VoidCallback onConfirm;

  const DialogNotSaved({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final scheme = theme.colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      title: Text('편집을 종료하시겠습니까?', style: textTheme.headlineMedium),
      content: Text(
        '변경 사항이 저장되지 않습니다.\n계속하시겠습니까?',
        style: textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
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
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm(); // 확인 누르면 다음 화면 이동
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
