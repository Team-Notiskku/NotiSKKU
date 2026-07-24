import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/user/user_provider.dart';

class GridAlarmKeyword extends ConsumerWidget {
  const GridAlarmKeyword({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final userNotifier = ref.read(userProvider.notifier);

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final scheme = theme.colorScheme;

    final selectedKeywords = userState.selectedKeywords;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child:
            selectedKeywords.isEmpty
                ? Center(
                  child: Text(
                    '선택된 키워드가 없습니다.',
                    style: textTheme.bodyMedium?.copyWith(
                      fontSize: 16.sp,
                      color: scheme.onSurface.withOpacity(0.60),
                    ),
                  ),
                )
                : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 86.w / 37.h,
                    crossAxisSpacing: 19.w,
                    mainAxisSpacing: 23.h,
                  ),
                  itemCount: selectedKeywords.length,
                  itemBuilder: (context, index) {
                    final keyword = selectedKeywords[index];
                    final isSelectedForAlarm = keyword.receiveNotification;

                    return _PillSelectButton(
                      label: keyword.keyword,
                      isSelected: isSelectedForAlarm,
                      width: 86.w,
                      height: 37.h,
                      textStyle: textTheme.headlineMedium?.copyWith(
                        fontSize: 18.sp,
                      ),
                      onPressed: () => userNotifier.toggleKeywordAlarm(keyword),
                    );
                  },
                ),
      ),
    );
  }
}

/// ====== 아래 두 개는 GridKeywords에 쓰던 코드와 동일 스타일 ======

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
          backgroundColor: MaterialStateProperty.all(bgColor),
          foregroundColor: MaterialStateProperty.all(fgColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          ),
          padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(horizontal: 8.w),
          ),
          minimumSize: MaterialStateProperty.all(Size(width, height)),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: (textStyle ?? theme.textTheme.headlineMedium)?.copyWith(
              fontSize: 18.sp,
              color: fgColor,
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
