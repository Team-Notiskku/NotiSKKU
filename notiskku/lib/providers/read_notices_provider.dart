import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 로컬에 저장되는 key
const _readNoticesKey = 'read_notices_hashes';

/// 읽은 공지 hash 집합을 관리하는 Notifier
class ReadNoticesNotifier extends StateNotifier<Set<String>> {
  ReadNoticesNotifier() : super({}) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_readNoticesKey) ?? [];
    state = list.toSet();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_readNoticesKey, state.toList());
  }

  /// 공지를 읽음 처리
  Future<void> markAsRead(String hash) async {
    if (hash.isEmpty) return;
    if (state.contains(hash)) return; // 이미 읽은 경우는 패스

    state = {...state, hash};
    await _saveToPrefs();
  }

  /// (선택) 디버깅용 전체 초기화
  Future<void> clearAll() async {
    state = {};
    await _saveToPrefs();
  }
}

/// 읽은 공지 hash들을 담고 있는 Provider
final readNoticesProvider =
    StateNotifierProvider<ReadNoticesNotifier, Set<String>>(
      (ref) => ReadNoticesNotifier(),
    );
