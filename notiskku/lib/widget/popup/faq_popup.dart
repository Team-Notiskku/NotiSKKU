import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notiskku/widget/popup/popup_ui.dart';

class FAQPopup extends StatelessWidget {
  const FAQPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final scheme = theme.colorScheme;
    return PopupUi(
      title: 'FAQ',
      onConfirm: () => Navigator.of(context).pop(),
      content: Column(
        children: [
          const SizedBox(height: 15),
          Image.asset(
            'assets/images/to_be_implemented_fix.png',
            width: 80,
            height: 80,
            color: scheme.outline,
          ),
          const SizedBox(height: 20),
          Text(
            '서비스 준비 중입니다',
            style: textTheme.headlineMedium?.copyWith(
              color: scheme.outline,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }
}
