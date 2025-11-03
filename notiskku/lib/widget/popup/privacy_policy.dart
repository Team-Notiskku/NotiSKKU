import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notiskku/widget/popup/popup_ui.dart';

class PrivacyPolicyPopup extends StatelessWidget {
  const PrivacyPolicyPopup({super.key});

  Widget _buildPrivacyContent(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(right: 4.0), // 스크롤바 영역 여유
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 개요
          Text(
            '개요',
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            '팀 노티스꾸(이하 "저희 팀")은 「개인정보 보호법」 제30조에 따라 법령을 준수하며, '
            '이용자의 개인정보를 보호하고 그 권익을 보장하기 위해 다음과 같이 개인정보처리방침을 수립하고 이를 준수합니다. '
            '본 개인정보처리방침은 2025년 4월 2일부터 적용됩니다.\n',
            style: textTheme.bodyMedium?.copyWith(fontSize: 13.sp),
          ),

          // 제1조
          Text(
            '제1조 (개인정보의 처리 목적)',
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            '• 푸시 알림 제공\n'
            '본 앱은 공지사항 등 서비스 관련 정보를 효율적으로 전달하기 위해 푸시 알림 기능을 제공합니다.\n'
            '이 과정에서 기기 식별자(푸시 토큰 등)가 자동으로 수집될 수 있으나, 이는 알림 발송 이외의 목적으로 사용되지 않습니다.\n\n'
            '• 회원가입 및 기타 개인정보 미수집\n'
            '본 앱은 회원가입 절차가 없으며, 이름, 전화번호, 이메일 등 개인을 식별할 수 있는 정보를 일절 수집하지 않습니다.\n',
            style: textTheme.bodyMedium?.copyWith(fontSize: 13.sp),
          ),

          // 제2조
          Text(
            '제2조 (개인정보의 처리 및 보유 기간)',
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            '• 보유 기간\n'
            '본 앱에서 수집하는 푸시 토큰(기기 식별자)은 알림 발송을 위해 필요한 동안만 보유·이용합니다.\n'
            '이용자가 앱을 삭제하거나, 기기·앱 설정을 통해 푸시 알림 수신을 거부할 경우 해당 식별자는 즉시 파기되거나 별도 보관되지 않습니다.\n\n'
            '• 파기 절차 및 방법\n'
            '파기 사유가 발생한 개인정보(푸시 토큰)는 지체 없이 안전한 방법(재생 불가능한 기술 조치 등)을 통해 삭제합니다.\n',
            style: textTheme.bodyMedium?.copyWith(fontSize: 13.sp),
          ),

          // 제3조
          Text(
            '제3조 (처리하는 개인정보 항목)',
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            '본 앱은 다음의 항목만 자동으로 수집·처리합니다.\n\n'
            '• 수집 항목 \n푸시 알림 발송을 위한 기기 식별자(푸시 토큰 등)\n\n'
            '• 그 외 항목 \n없음(이름, 전화번호 등은 수집하지 않음)\n',
            style: textTheme.bodyMedium?.copyWith(fontSize: 13.sp),
          ),

          // 제4조
          Text(
            '제4조 (개인정보의 제3자 제공)',
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            '본 앱은 이용자의 개인정보를 제3자에게 제공하지 않습니다.\n'
            '다만, 푸시 알림 발송을 위해 애플 푸시 알림 서비스(APNs) 또는 기타 외부 서비스(Firebase Cloud Messaging 등)를 사용할 수 있으며, '
            '이 과정에서 기기 식별자가 해당 서비스 제공자에게 전송될 수 있습니다.\n'
            '이 경우 해당 서비스 제공자의 개인정보처리방침이 별도로 적용될 수 있습니다.\n',
            style: textTheme.bodyMedium?.copyWith(fontSize: 13.sp),
          ),

          // 제5조
          Text(
            '제5조 (이용자 권리 및 행사 방법)',
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            '• 알림 수신 거부\n'
            '이용자는 언제든지 기기 설정(알림 허용/차단) 또는 앱 내 알림 설정을 통해 푸시 알림을 차단하거나 해제할 수 있습니다.\n'
            '알림 수신을 거부하면 본 앱에서 더 이상 기기 식별자를 이용하지 않으며, 알림 역시 발송되지 않습니다.\n\n'
            '• 개인정보 열람·삭제 요청\n'
            '본 앱은 개인 식별 정보를 보유하고 있지 않으므로, 열람·정정·삭제 대상 정보가 존재하지 않습니다.\n'
            '다만, 푸시 토큰이 불필요하게 되었을 때(앱 삭제, 알림 차단 등) 해당 데이터는 즉시 파기됩니다.\n',
            style: textTheme.bodyMedium?.copyWith(fontSize: 13.sp),
          ),

          // 제6조
          Text(
            '제6조 (개인정보의 안전성 확보 조치)',
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            '본 앱은 기기 식별자 이외에 별도의 개인정보를 보유하지 않으나, 개인정보 보호를 위해 다음과 같은 조치를 취하고 있습니다.\n\n'
            '• 개인정보 취급 최소화 \n회원가입이나 별도 개인정보 입력 과정을 두지 않으며, 필수적인 푸시 토큰만을 제한적으로 취급합니다.\n'
            '• 기술적·관리적 보안 강화 \n외부로부터 접근이 제한된 안전한 서버 환경을 이용하며, 필요 시 암호화·접근권한 관리 등 기술적 조치를 적용합니다.\n',
            style: textTheme.bodyMedium?.copyWith(fontSize: 13.sp),
          ),

          // 제7조
          Text(
            '제7조 (개인정보처리방침 변경)',
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            '이 개인정보처리방침은 2025년 4월 2일부터 적용됩니다.\n'
            '본 방침을 변경할 경우, 앱 내 공지 또는 업데이트 안내를 통해 사전에 고지합니다.\n',
            style: textTheme.bodyMedium?.copyWith(fontSize: 13.sp),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupUi(
      title: '개인정보처리방침',
      onConfirm: () => Navigator.of(context).pop(),
      content: _buildPrivacyContent(context), // ← context 전달
    );
  }
}
