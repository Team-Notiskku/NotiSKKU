// lib/screen/screen_intro_loading.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:notiskku/firebase/topic_subscription.dart';
import 'package:notiskku/providers/user/user_provider.dart';
import 'package:notiskku/screen/screen_intro_ready.dart';
import 'package:notiskku/screen/screen_main_tabs.dart';
import 'package:notiskku/services/preferences_app.dart';

class ScreenIntroLoading extends ConsumerStatefulWidget {
  const ScreenIntroLoading({
    super.key,
    this.isFromAlarm = false,
    this.isFromIntro = false, // 추가
  });

  /// 기존 로직 유지
  final bool isFromIntro;
  final bool isFromAlarm;

  @override
  ConsumerState<ScreenIntroLoading> createState() => _ScreenIntroLoadingState();
}

class _ScreenIntroLoadingState extends ConsumerState<ScreenIntroLoading> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initSubscriptions();
    });
  }

  Future<void> _initSubscriptions() async {
    final user = ref.read(userProvider);

    final enabledMajors =
        user.selectedMajors
            .where((m) => m.receiveNotification == true)
            .toList();
    final enabledKeywords =
        user.selectedKeywords
            .where((k) => k.receiveNotification == true)
            .toList();

    debugPrint('✅ [ScreenIntroLoading] isFromAlarm: ${widget.isFromAlarm}');
    debugPrint(
      '✅ [ScreenIntroLoading] isFromIntro: ${widget.isFromIntro}',
    ); // ✅ 로그 추가
    debugPrint(
      '✅ [ScreenIntroLoading] majors (all): ${user.selectedMajors.map((m) => m.major).join(", ")}',
    );
    debugPrint(
      '✅ [ScreenIntroLoading] majors (ON): ${enabledMajors.map((m) => m.major).join(", ")}',
    );
    debugPrint(
      '✅ [ScreenIntroLoading] keywords (all): ${user.selectedKeywords.map((k) => k.keyword).join(", ")}',
    );
    debugPrint(
      '✅ [ScreenIntroLoading] keywords (ON): ${enabledKeywords.map((k) => k.keyword).join(", ")}',
    );

    try {
      await TopicSubscription.syncAll(
        majors: user.selectedMajors,
        keywords: user.selectedKeywords,
      );

      if (!mounted) return;

      _showSnack('알림 구독이 완료되었습니다.');

      final Widget next =
          widget.isFromIntro
              ? const ScreenIntroReady()
              : (widget.isFromAlarm
                  ? const ScreenMainTabs(showPostLoadNotice: false)
                  : const ScreenMainTabs(showPostLoadNotice: true));

      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => next));
    } catch (e) {
      if (!mounted) return;

      _showSnack('알림 구독에 실패했습니다: $e', isError: true);

      final Widget next =
          widget.isFromIntro
              ? const ScreenIntroReady()
              : (widget.isFromAlarm
                  ? const ScreenMainTabs(showPostLoadNotice: false)
                  : const ScreenMainTabs(showPostLoadNotice: true));

      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => next));
    }
  }

  void _showSnack(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/loadinglogo.png',
                  height: 170.h,
                  width: 170.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 23.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '설정을 완료하는 중이에요.',
                      style: TextStyle(
                        color: scheme.primary,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    SizedBox(
                      height: 16.w,
                      width: 16.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 3.0,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          scheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  '조금만 더 기다려주세요 :)',
                  style: TextStyle(
                    color: scheme.outline,
                    fontSize: 18.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 5.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
