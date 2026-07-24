import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../firebase/firebase_options.dart'; // 경로 프로젝트에 맞게

/// 백그라운드 핸들러는 반드시 top-level + entry-point 유지!
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // 백그라운드 isolate에서는 직접 초기화 필요
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // TODO: 필요한 처리 (로깅/로컬알림 등)
  // debugPrint('[BG] ${message.messageId} ${message.data}');
}
