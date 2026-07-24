import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // <- .sp 사용 시 필요
import 'package:notiskku/widget/popup/popup_ui.dart';

class VersionNoticePopup extends StatelessWidget {
  const VersionNoticePopup({super.key});

  Widget _buildVersionContent(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final scheme = theme.colorScheme;

    return Column(
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
          '업데이트 준비 중입니다',
          style: textTheme.headlineMedium?.copyWith(
            color: scheme.outline,
            fontSize: 16.sp, // ScreenUtil 사용 중이므로 .sp 유지
          ),
        ),
      ],
    );
  }

  Widget _buildNotice(
    BuildContext context,
    String title,
    String date,
    String content,
  ) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          '[$date]',
          style: textTheme.bodySmall?.copyWith(color: scheme.outline),
        ),
        const SizedBox(height: 5),
        Text('- $content', style: textTheme.bodyMedium),
        Divider(color: scheme.outlineVariant, thickness: 1, height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupUi(
      title: '버전 및 공지',
      onConfirm: () => Navigator.of(context).pop(),
      // 필요에 따라 공지 리스트로 교체 가능
      content: _buildVersionContent(context),

      // 예: 과거 공지 보여주려면 아래 같이 사용
      // content: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     _buildNotice(context, '서버 정기점검 (완료)', '2024.08.21', 'NotiSKKU 정기점검 완료되었습니다.'),
      //     _buildNotice(context, '서버 정기점검 (완료)', '2024.06.15', 'NotiSKKU 서버 점검이 성공적으로 완료되었습니다.'),
      //     _buildNotice(context, '서버 정기점검 (완료)', '2024.04.10', 'NotiSKKU의 점검 작업이 정상적으로 완료되었습니다.'),
      //   ],
      // ),
    );
  }
}
