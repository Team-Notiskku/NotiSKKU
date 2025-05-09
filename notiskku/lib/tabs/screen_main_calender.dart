import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:notiskku/services/calendar_service.dart';
import 'package:notiskku/data/event_data_source.dart';

class ScreenMainCalender extends StatelessWidget {
  const ScreenMainCalender({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(10.0),
          child: Image.asset('assets/images/greenlogo_fix.png', width: 40),
        ),
        title: Text(
          '학사일정',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Appointment>>(
        future: loadAppointments(), // JSON에서 Appointment 리스트 불러오는 함수
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final appointments = snapshot.data!;
            return SfCalendar(
              headerStyle: CalendarHeaderStyle(
                textStyle: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                backgroundColor: Colors.white,
              ),
              view: CalendarView.month,
              initialSelectedDate: DateTime.now(),
              todayHighlightColor: const Color(0xFF0B5B42),
              selectionDecoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromRGBO(11, 91, 66, 0.2),
                  width: 2.w,
                ), // 테두리 초록색
              ),
              dataSource: EventDataSource(appointments),
              showNavigationArrow: true,
              // 월간 뷰 설정
              monthViewSettings: MonthViewSettings(
                // 날짜 칸에는 점(dot) 표시
                appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
                // 하단에 Agenda 표시
                showAgenda: true,
                // 기본 Agenda 아이템 높이 조정 가능
                agendaItemHeight: 60.h,
                // 필요하다면 Agenda 스타일이나 높이 등을 더 설정 가능
              ),
            );
          }
        },
      ),
    );
  }
}
