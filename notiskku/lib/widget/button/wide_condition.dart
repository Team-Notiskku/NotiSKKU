import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WideCondition extends StatelessWidget {
  final String text;
  final bool isEnabled;
  final VoidCallback? onPressed;

  const WideCondition({
    super.key,
    required this.text,
    required this.isEnabled,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final scheme = theme.colorScheme;

    final Color enabledBg = scheme.primary; // 메인 초록
    final Color disabledBg = scheme.secondary; // 라인 그레이
    final Color enabledFg = scheme.surface; // 텍스트 프라이머리
    final Color disabledFg = scheme.outline; // 회색 텍스트

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 40.h, minWidth: 301.w),
      child: SizedBox(
        width: 301.w,
        height: 40.h,
        child: TextButton(
          onPressed: isEnabled ? onPressed : null,
          style: ButtonStyle(
            // 배경색
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) return disabledBg;
              if (states.contains(WidgetState.pressed)) {
                return enabledBg;
              }
              return enabledBg;
            }),
            // 전경(텍스트/아이콘) 색
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) return disabledFg;
              return enabledFg;
            }),
          ),
          child: Center(
            child: Text(
              text,
              style: textTheme.headlineMedium?.copyWith(
                color: isEnabled ? enabledFg : disabledFg,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
