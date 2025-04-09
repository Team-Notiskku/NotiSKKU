import 'package:flutter/material.dart';
import 'package:notiskku/widget/popup/popup_ui.dart';

class ServiceIntroPopup extends StatelessWidget {
  const ServiceIntroPopup({Key? key}) : super(key: key);

  Widget _buildServiceIntroContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '서비스 소개',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            '노티스꾸는 여러 학과의 학생들이 학교의 다양한 홈페이지를 매번 일일이 방문해 공지사항을 확인해야 하는 불편함을 줄이기 위해 제작된 앱입니다.\n\n'
            '각 단과대학 및 학과의 공지사항을 한 화면에 모아 확인할 수 있도록 하여, 학생들의 정보 접근성을 높이고 시간과 노력을 절약할 수 있도록 돕습니다.',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupUi(
      title: '서비스 소개',
      onConfirm: () => Navigator.of(context).pop(),
      content: _buildServiceIntroContent(),
    );
  }
}
