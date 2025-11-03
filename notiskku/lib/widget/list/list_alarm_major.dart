import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/user/user_provider.dart';

class ListAlarmMajor extends ConsumerWidget {
  const ListAlarmMajor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final userNotifier = ref.read(userProvider.notifier);

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final filteredMajors = userState.selectedMajors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          filteredMajors.map((major) {
            final isSelected = major.receiveNotification;

            return FractionallySizedBox(
              widthFactor: 0.85, // 버튼 너비 동일 유지
              child: Padding(
                padding: EdgeInsets.only(bottom: 13.h),
                child: _PillSelectButton(
                  label: major.major,
                  isSelected: isSelected,
                  width: 294.w,
                  height: 36.h,
                  textStyle: textTheme.headlineMedium?.copyWith(
                    fontSize: 18.sp,
                  ),
                  onPressed: () => userNotifier.toggleMajorAlarm(major),
                ),
              ),
            );
          }).toList(),
    );
  }
}

/// ====== GridKeywords와 동일 스타일 재사용 ======
class _PillSelectButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final TextStyle? textStyle;

  const _PillSelectButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
    required this.width,
    required this.height,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (bgColor, fgColor) = _pillColors(theme, isSelected);

    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(bgColor),
          foregroundColor: WidgetStateProperty.all(fgColor),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          ),
          padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
          ),
          minimumSize: WidgetStateProperty.all(Size(width, height)),
          alignment: Alignment.center,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: (textStyle ?? theme.textTheme.headlineMedium)?.copyWith(
              fontSize: 18.sp,
              color: fgColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

(Color, Color) _pillColors(ThemeData theme, bool isSelected) {
  final scheme = theme.colorScheme;
  final bgColor =
      isSelected
          ? scheme.primary.withOpacity(0.7)
          : scheme.secondary.withOpacity(0.6);
  final fgColor = isSelected ? scheme.surface : scheme.outline;
  return (bgColor, fgColor);
}
