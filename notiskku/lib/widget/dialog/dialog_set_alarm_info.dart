// lib/widget/dialog/dialog_set_alarm_info.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogSetAlarmInfo extends StatelessWidget {
  const DialogSetAlarmInfo({
    super.key,
    required this.onTapShortcut,
    required this.onTapOk,
  });

  final VoidCallback onTapShortcut;
  final VoidCallback onTapOk;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final scheme = theme.colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      title: Text('편집이 완료되었습니다!', style: textTheme.headlineMedium),
      content: Text(
        '새로 추가된 학과/키워드에 대한 알림은\n'
        '\'더보기 > 학과 및 키워드 알림 설정\'에서\n설정할 수 있습니다.',
        style: textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 12.sp,
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.all(3.0.w),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize: Size.zero,
          ),
          onPressed: onTapShortcut,
          child: Text(
            '알림 설정 바로가기',
            style: TextStyle(
              color: scheme.outline,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextButton(
          // style: TextButton.styleFrom(
          //   padding: EdgeInsets.all(3.0.w),
          //   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          //   minimumSize: Size.zero,
          // ),
          onPressed: onTapOk,
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
