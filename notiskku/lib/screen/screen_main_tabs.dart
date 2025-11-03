import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:notiskku/data/temp_starred_notices.dart';
import 'package:notiskku/providers/tab_providers.dart';
import 'package:notiskku/providers/user/user_provider.dart';

import 'package:notiskku/tabs/screen_main_keyword.dart';
import 'package:notiskku/tabs/screen_main_notice.dart';
import 'package:notiskku/tabs/screen_main_box.dart';
import 'package:notiskku/tabs/screen_main_calender.dart';
import 'package:notiskku/tabs/screen_main_others.dart';
import 'package:notiskku/screen/screen_intro_alarm.dart';
import 'package:notiskku/widget/dialog/dialog_set_alarm_info.dart';

import 'package:notiskku/services/preferences_app.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      builder: (context, child) {
        return const ProviderScope(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: ScreenMainTabs(),
          ),
        );
      },
    );
  }
}

class ScreenMainTabs extends ConsumerStatefulWidget {
  const ScreenMainTabs({super.key, this.showPostLoadNotice = false});
  final bool showPostLoadNotice;

  @override
  ConsumerState<ScreenMainTabs> createState() => _ScreenMainTabsState();
}

class _ScreenMainTabsState extends ConsumerState<ScreenMainTabs> {
  final List<Widget> _pages = const [
    ScreenMainNotice(),
    ScreenMainKeyword(),
    ScreenMainBox(),
    ScreenMainCalender(),
    ScreenMainOthers(),
  ];

  List<BottomNavigationBarItem> get _navItems => [
    _buildNavItem('assets/images/notice_fix.png', '공지사항'),
    _buildNavItem('assets/images/keyword_fix.png', '키워드'),
    _buildNavItem('assets/images/emptystar_fix.png', '즐겨찾기'),
    _buildNavItem('assets/images/calendar_fix.png', '학사일정'),
    _buildNavItem('assets/images/more_fix.png', '더보기'),
  ];

  BottomNavigationBarItem _buildNavItem(String assetPath, String label) {
    return BottomNavigationBarItem(
      icon: ImageIcon(AssetImage(assetPath), size: 30.w),
      label: label,
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.showPostLoadNotice) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _showPostLoadNotice(context);
      });
    }
  }

  void _onItemTapped(int newIndex) {
    final previousIndex = ref.read(tabIndexProvider);
    final userNotifier = ref.read(userProvider.notifier);

    if (previousIndex == 2) {
      userNotifier.deleteTempStarred(tempStarredNotices);
    } else {
      userNotifier.saveTempStarred(tempStarredNotices);
    }

    ref.read(tabIndexProvider.notifier).state = newIndex;
  }

  void _showPostLoadNotice(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (ctx) => DialogSetAlarmInfo(
            onTapShortcut: () {
              Navigator.of(ctx).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ScreenIntroAlarm()),
              );
            },
            onTapOk: () => Navigator.of(ctx).pop(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final currentIndex = ref.watch(tabIndexProvider);

    return Scaffold(
      body: _pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: _navItems,
        currentIndex: currentIndex,
        selectedItemColor: scheme.primary,
        unselectedItemColor: scheme.outline,
        selectedFontSize: 14.sp,
        unselectedFontSize: 14.sp,
        onTap: _onItemTapped,
      ),
    );
  }
}
