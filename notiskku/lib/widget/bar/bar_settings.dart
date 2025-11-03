import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/bar_providers.dart';

class BarSettings extends ConsumerWidget {
  const BarSettings.barSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton(ref, Settings.major, "학과", 130.w, context),
        SizedBox(width: 12.w),
        _buildButton(ref, Settings.keyword, "키워드", 130.w, context),
      ],
    );
  }

  Widget _buildButton(
    WidgetRef ref,
    Settings settings,
    String text,
    double buttonWidth,
    BuildContext context,
  ) {
    final isSelected = ref.watch(settingsProvider) == settings;

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final scheme = theme.colorScheme;

    // 선택/비선택 색상 결정
    final textColor = isSelected ? scheme.primary : scheme.outline;

    return GestureDetector(
      onTap: () => ref.read(settingsProvider.notifier).state = settings,
      child: Container(
        width: buttonWidth,
        padding: EdgeInsets.symmetric(vertical: 6.5.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: textColor, width: isSelected ? 2.h : 1.h),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: textTheme.headlineMedium?.copyWith(
              color: textColor,
              fontSize: 20.sp,
            ),
          ),
        ),
      ),
    );
  }
}
