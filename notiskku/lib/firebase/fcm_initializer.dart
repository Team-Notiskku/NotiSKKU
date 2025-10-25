// widget/notify/fcm_initializer.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/firebase/notification_provider.dart';

class FcmInitializer extends ConsumerStatefulWidget {
  const FcmInitializer({super.key});

  @override
  ConsumerState<FcmInitializer> createState() => _FcmInitializerState();
}

class _FcmInitializerState extends ConsumerState<FcmInitializer> {
  bool _didInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInit) return;
    _didInit = true;

    // 🔹 Provider 인스턴스로 전역 1회 init
    Future.microtask(() => ref.read(notificationProvider).init());
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
