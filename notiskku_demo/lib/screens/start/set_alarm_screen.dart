import 'package:flutter/material.dart';
import 'package:notiskku_demo/widgets/alarm_major_list.dart';
import 'package:notiskku_demo/widgets/alarm_setup_complete_button.dart';
import 'package:notiskku_demo/widgets/alarm_keywords_grid.dart';

class SetAlarmScreen extends StatefulWidget {
  const SetAlarmScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SetAlarmScreenState();
}

class _SetAlarmScreenState extends State<SetAlarmScreen> {
  List<String> alarmMajor = [];
  List<String> alarmKeyword = [];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // 화면 너비 가져오기
    final buttonWidth = (screenWidth - 80) / 3; // 버튼 너비 조정 (여백을 고려하여 3개로 나누기)

    // 비율 86:37로 버튼 높이 계산
    final buttonHeight = buttonWidth * (37 / 86);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 80),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                '알림 받을 학과와 키워드를 선택해주세요😀\n미선택 시 알림이 발송되지 않습니다.',
                textAlign: TextAlign.left, // 텍스트 왼쪽 정렬
                style: TextStyle(
                  color: Colors.black.withOpacity(0.8999999761581421),
                  fontSize: 18,
                  fontFamily: 'GmarketSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                '선택한 학과',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          AlarmMajorList(
            alarmMajor: alarmMajor,
            onAlarmMajorChanged: (majors) {
              setState(() {
                alarmMajor = majors;
              });
            },
          ),
          const SizedBox(height: 30),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                '선택한 키워드',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: AlarmKeywordsGrid(
              alarmKeyword: alarmKeyword,
              onAlarmKeywordChanged: (keywords) {
                setState(() {
                  alarmKeyword = keywords;
                });
              },
            ),
          ),
          const AlarmSetupCompleteButton(),
        ],
      ),
    );
  }
}
