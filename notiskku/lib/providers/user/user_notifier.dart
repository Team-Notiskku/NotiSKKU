import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/models/keyword.dart';
import 'package:notiskku/models/major.dart';
import 'package:notiskku/providers/user/user_state.dart';
import 'package:notiskku/services/preference_user.dart';

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(const UserState()) {
    _loadAll();
  }

  // Helper
  // 필요 시 각각 분리해서 추가 가능
  Future<void> _loadAll() async {
    final savedMajors = await UserPreferences.loadMajor();
    final savedKeywords = await UserPreferences.loadKeywords();
    final savedNotices = await UserPreferences.loadStarred();
    final savedSearchedText = await UserPreferences.loadRecentSearch();

    state = state.copyWith(
      selectedMajors: savedMajors,
      selectedKeywords: savedKeywords,
      starredNotices: savedNotices,
      recentSearchedText: savedSearchedText,
    );
  }

  // ------------------- 수정된 부분 ------------------ //
  // 1) 학과(전공) 선택 교체: 최대 2개, 중복 제거
  void replaceSelectedMajors(List<Major> majors) {
    final dedup = <String, Major>{};
    for (final m in majors) {
      if (dedup.length >= 2) break; // 최대 2개 제한
      dedup[m.major] = m;
    }
    final next = dedup.values.toList(growable: false);
    state = state.copyWith(selectedMajors: next);
    UserPreferences.saveMajor(next);
  }

  // 2) 키워드 선택 교체: 중복 제거, "선택하지 않음"은 자동 해제
  void replaceSelectedKeywords(List<Keyword> keywords) {
    final dedup = <String, Keyword>{};
    for (final k in keywords) {
      dedup[k.keyword] = k;
    }
    final next = dedup.values.toList(growable: false);

    state = state.copyWith(selectedKeywords: next, doNotSelectKeywords: false);
    UserPreferences.saveKeywords(next);
  }

  // 3-A) 학과 알림 선택 교체: 전달된 majorName -> receive 로 일괄 반영
  //     (맵에 없는 학과는 기존 값 유지)
  void replaceMajorNotifications(Map<String, bool> receiveByMajor) {
    final next = state.selectedMajors
        .map(
          (m) =>
              receiveByMajor.containsKey(m.major)
                  ? m.copyWith(receiveNotification: receiveByMajor[m.major]!)
                  : m,
        )
        .toList(growable: false);

    state = state.copyWith(selectedMajors: next);
    UserPreferences.saveMajor(next);
  }

  // 3-B) 키워드 알림 선택 교체: 전달된 keyword -> receive 로 일괄 반영
  //     (맵에 없는 키워드는 기존 값 유지)
  void replaceKeywordNotifications(Map<String, bool> receiveByKeyword) {
    final next = state.selectedKeywords
        .map(
          (k) =>
              receiveByKeyword.containsKey(k.keyword)
                  ? k.copyWith(
                    receiveNotification: receiveByKeyword[k.keyword]!,
                  )
                  : k,
        )
        .toList(growable: false);

    state = state.copyWith(selectedKeywords: next);
    UserPreferences.saveKeywords(next);
  }

  // ------------------- 기존 부분 ------------------ //

  // 전공 선택
  bool toggleMajor(Major major) {
    final currentMajors = List<Major>.from(state.selectedMajors);

    if (currentMajors.contains(major)) {
      currentMajors.remove(major);
    } else if (currentMajors.length < 2) {
      currentMajors.add(major);
    } else {
      return false;
    }

    state = state.copyWith(selectedMajors: currentMajors);
    UserPreferences.saveMajor(currentMajors);
    return true;
  }

  // 선택된 전공별 알림 여부 선택
  void toggleMajorAlarm(Major major) {
    final updatedMajors =
        state.selectedMajors.map((m) {
          if (m.major == major.major) {
            return m.copyWith(receiveNotification: !m.receiveNotification);
          }
          return m;
        }).toList();

    state = state.copyWith(selectedMajors: updatedMajors);
    UserPreferences.saveMajor(updatedMajors);
  }

  // 키워드 선택
  // "선택하지 않음" 버그 확인하지 않음
  void toggleKeyword(Keyword keyword) {
    final currentKeywords = List<Keyword>.from(state.selectedKeywords);
    if (state.doNotSelectKeywords == true) {
      toggleDoNotSelectKeywords();
    }
    if (currentKeywords.contains(keyword)) {
      currentKeywords.remove(keyword);
    } else {
      currentKeywords.add(keyword);
    }

    state = state.copyWith(selectedKeywords: currentKeywords);
    UserPreferences.saveKeywords(currentKeywords);
  }

  // "선택하지 않음" 토글 관리
  void toggleDoNotSelectKeywords() {
    state = state.copyWith(
      selectedKeywords: [],
      doNotSelectKeywords: !state.doNotSelectKeywords,
    );

    UserPreferences.saveKeywords([]);
  }

  // 선택된 키워드별 알림 여부 선택
  void toggleKeywordAlarm(Keyword keyword) {
    final updatedKeywords =
        state.selectedKeywords.map((k) {
          if (k.keyword == keyword.keyword) {
            return k.copyWith(receiveNotification: !k.receiveNotification);
          }
          return k;
        }).toList();

    state = state.copyWith(selectedKeywords: updatedKeywords);
    UserPreferences.saveKeywords(updatedKeywords);
  }

  /// 즐겨찾기 '제거'를 명시적으로 수행
  /// (메인 홈에서 채운 별 -> 빈 별 전환 시 이 메서드를 호출)
  void unstarNotice(String hash) {
    if (!state.starredNotices.contains(hash)) return;
    final next = List<String>.from(state.starredNotices)..remove(hash);
    state = state.copyWith(starredNotices: next);
    UserPreferences.saveStarred(next);
  }

  // 별표 등록/제거
  void toggleStarredNotice(String hash) async {
    final currentStarredList = List<String>.from(state.starredNotices);
    if (currentStarredList.contains(hash)) {
      currentStarredList.remove(hash);
    } else {
      currentStarredList.add(hash);
    }
    state = state.copyWith(starredNotices: currentStarredList);
    UserPreferences.saveStarred(currentStarredList);
  }

  void saveTempStarred(List<String> tempList) {
    final currentStarred = List<String>.from(state.starredNotices);
    final newHashes =
        tempList.where((hash) => !currentStarred.contains(hash)).toList();

    if (newHashes.isEmpty) return;

    currentStarred.addAll(newHashes);
    state = state.copyWith(starredNotices: currentStarred);
    UserPreferences.saveStarred(currentStarred);
    tempList.clear();
  }

  void deleteTempStarred(List<String> tempList) {
    final currentStarred = List<String>.from(state.starredNotices);
    final targetHashes =
        tempList.where((hash) => currentStarred.contains(hash)).toList();

    if (targetHashes.isEmpty) return;

    currentStarred.removeWhere((element) => targetHashes.contains(element));
    state = state.copyWith(starredNotices: currentStarred);
    UserPreferences.saveStarred(currentStarred);
    tempList.clear();
  }

  // 현재 검색어 업데이트
  void updateSearchText(String text) {
    state = state.copyWith(currentSearchText: text);
  }

  // 최근 검색어 추가 (중복 시 상단으로)
  void addRecentSearch(String text) {
    final currentRecentSearchedList = List<String>.from(
      state.recentSearchedText,
    );

    currentRecentSearchedList.remove(text);
    currentRecentSearchedList.add(text);

    state = state.copyWith(recentSearchedText: currentRecentSearchedList);
    UserPreferences.saveRecentSearch(currentRecentSearchedList);
  }

  // 최근 검색어 삭제
  void deleteRecentSearch(String text) {
    final currentRecentSearchedList = List<String>.from(
      state.recentSearchedText,
    );

    currentRecentSearchedList.remove(text);

    state = state.copyWith(recentSearchedText: currentRecentSearchedList);
    UserPreferences.saveRecentSearch(currentRecentSearchedList);
  }
}
