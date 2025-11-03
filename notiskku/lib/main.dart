// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';

// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase/firebase_options.dart';
import 'firebase/background_handler.dart';

// 전역 초기화 + FCM 리스너
import 'package:notiskku/firebase/fcm_initializer.dart';
import 'package:notiskku/firebase/foreground_message_listener.dart';

// 테마
import 'package:notiskku/theme/app_theme_light.dart';
import 'package:notiskku/theme/app_theme_dark.dart';

import 'package:notiskku/screen/screen_intro_logo.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,

          // 여기서 커스텀 테마 적용
          theme: buildLightTheme(fontFamily: 'NanumSquareNeo'),
          darkTheme: buildDarkTheme(fontFamily: 'NanumSquareNeo'),
          themeMode: ThemeMode.system, // 시스템 라이트/다크 따라가기

          debugShowCheckedModeBanner: false,

          // 전역 초기화 + 전역 포그라운드 리스너
          builder:
              (context, child) => Stack(
                children: [
                  if (child != null) child,
                  const FcmInitializer(),
                  const ForegroundMessageListener(),
                ],
              ),
          home: const ScreenLogoIntro(),
        );
      },
    );
  }
}
