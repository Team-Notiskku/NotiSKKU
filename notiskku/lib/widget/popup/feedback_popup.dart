import 'package:flutter/material.dart';
import 'package:notiskku/widget/popup/popup_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackPopup extends StatelessWidget {
  const FeedbackPopup({super.key});

  Future<void> _launchChat() async {
    final Uri uri = Uri.parse('https://open.kakao.com/o/sxNn0mIh');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $uri';
    }
  }

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
    final String guideText = applyWordBreakFix(
      '문의 및 건의는 아래의 카카오톡 오픈채팅을 이용해 주세요.\n답변은 2~3일 정도 소요될 수 있습니다.',
    );

    return PopupUi(
      title: '문의 / 건의',
      onConfirm: () => Navigator.of(context).pop(),
      content: Column(
        children: [
          Text(
            guideText,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _launchChat,
            child: Container(
              padding: const EdgeInsets.all(10),
              color: scheme.secondary.withAlpha(150),
              child: Text(
                'https://open.kakao.com/o/gKYMY3Wg',
                textAlign: TextAlign.center,
                style: textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: scheme.outline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
