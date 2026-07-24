import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/data/keyword_data.dart';
import 'package:notiskku/providers/user/user_provider.dart';

class GridKeywords extends ConsumerWidget {
  const GridKeywords({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final userNotifier = ref.read(userProvider.notifier);

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      children: [
        SizedBox(height: 10.h),

        // '선택하지 않음' 버튼 (기존과 동일)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: _PillSelectButton(
            label: '선택하지 않음',
            isSelected: userState.doNotSelectKeywords,
            width: 282.w,
            height: 36.h,
            onPressed: () => userNotifier.toggleDoNotSelectKeywords(),
          ),
        ),
        SizedBox(height: 25.h),

        // 키워드 선택 Grid
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 36.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3열
              childAspectRatio: 86.w / 37.h,
              crossAxisSpacing: 19.w, // 열 간 간격
              mainAxisSpacing: 23.h, // 행 간 간격
            ),
            itemCount: keywords.length,
            itemBuilder: (context, index) {
              final keyword = keywords[index].keyword;
              final matchedKeyword = keywords.firstWhere(
                (k) => k.keyword == keyword,
              );
              final isSelected = userState.selectedKeywords.contains(
                matchedKeyword,
              );

              return _PillSelectButton(
                label: keyword,
                isSelected: isSelected,
                width: 86.w,
                height: 37.h,
                // _DoNotSelectButton과 동일한 스타일/색 로직이 자동 적용됨
                textStyle: textTheme.headlineMedium?.copyWith(fontSize: 18.sp),
                onPressed: () => userNotifier.toggleKeyword(matchedKeyword),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// 공통 Pill 버튼: `_DoNotSelectButton`과 동일 스타일을 재사용
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
            EdgeInsets.symmetric(horizontal: 8.w),
          ),
          minimumSize: WidgetStateProperty.all(Size(width, height)),
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
