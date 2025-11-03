import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogLimitMajor extends StatelessWidget {
  final List<String> selectedMajors;

  const DialogLimitMajor({super.key, required this.selectedMajors});

  // 한글 줄바꿈 개선 함수
  String applyWordBreakFix(String text) {
    final RegExp emoji = RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])',
    );
    String fullText = '';
    List<String> words = text.split(' ');
    for (var i = 0; i < words.length; i++) {
      fullText +=
          emoji.hasMatch(words[i])
              ? words[i]
              : words[i].replaceAllMapped(
                RegExp(r'(\S)(?=\S)'),
                (m) => '${m[1]}\u200D',
              );
      if (i < words.length - 1) fullText += ' ';
    }
    return fullText;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final scheme = theme.colorScheme;

    final String fixedInstruction = applyWordBreakFix(
      '전공은 최대 두 개까지 선택할 수 있습니다.',
    );

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      title: Text('⚠️ 전공 선택 제한', style: textTheme.headlineMedium),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fixedInstruction,
            style: textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 20.h),
          Text(
            "선택한 전공:",
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: scheme.primary,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            selectedMajors.join(', '),
            style: textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
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
