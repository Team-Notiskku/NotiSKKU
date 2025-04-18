import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/models/major.dart';
import 'package:notiskku/services/preferences_major.dart';
import 'package:notiskku/data/major_data.dart';

class MajorState {
  final List<Major> selectedMajors;
  final List<String> majors; // 전체 전공 리스트
  final String searchText;

  const MajorState({
    this.selectedMajors = const [],
    this.majors = const [],
    this.searchText = '',
  });

  MajorState copyWith({
    List<Major>? selectedMajors,
    List<String>? majors,
    String? searchText,
  }) {
    return MajorState(
      selectedMajors: selectedMajors ?? this.selectedMajors,
      majors: majors ?? this.majors,
      searchText: searchText ?? this.searchText,
    );
  }
}

// Major 관련 정보 관리 Notifier
class MajorNotifier extends StateNotifier<MajorState> {
  MajorNotifier()
    : super(MajorState(majors: majors.map((e) => e.major).toList())) {
    _loadSelectedMajors();
  }

  // 저장된 selectedMajors 불러오기
  Future<void> _loadSelectedMajors() async {
    final savedMajors = await MajorPreferences.load();

    state = state.copyWith(selectedMajors: savedMajors);
  }

  // selectedMajors 추가/제거 관리
  bool toggleMajor(Major major) {
    final currentMajors = List<Major>.from(state.selectedMajors);

    if (currentMajors.contains(major)) {
      currentMajors.remove(major);
    } else if (currentMajors.length < 2) {
      currentMajors.add(major);
    } else {
      return false; // 2개 이상 선택 시 팝업 출력
    }

    state = state.copyWith(selectedMajors: currentMajors);
    MajorPreferences.save(currentMajors);
    return true;
  }

  void toggleAlarm(Major major) {
    final updatedMajors =
        state.selectedMajors.map((m) {
          if (m.major == major.major) {
            return m.copyWith(receiveNotification: !m.receiveNotification);
          }
          return m;
        }).toList();

    state = state.copyWith(selectedMajors: updatedMajors);
    MajorPreferences.save(updatedMajors);
  }

  // 검색어 업데이트
  void updateSearchText(String text) {
    state = state.copyWith(searchText: text);
  }
}

// Provider 등록, major 관련 정보 관리
final majorProvider = StateNotifierProvider<MajorNotifier, MajorState>((ref) {
  return MajorNotifier();
});
