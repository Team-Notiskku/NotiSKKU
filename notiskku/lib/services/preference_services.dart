// import 'dart:convert';

// import 'package:notiskku/models/keyword.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// Future<void> saveKeywordPreferences(List<Keyword> prefs) async {
//   final sp = await SharedPreferences.getInstance();
//   final jsonList = prefs.map((p) => jsonEncode(p.toJson())).toList();
//   await sp.setStringList('keywordPrefs', jsonList);
// }

// Future<List<Keyword>> loadKeywordPreferences() async {
//   final sp = await SharedPreferences.getInstance();
//   final jsonList = sp.getStringList('keywordPrefs') ?? [];
//   return jsonList.map((str) => Keyword.fromJson(jsonDecode(str))).toList();
// }

// // 선택 전공 목록 저장
// Future<void> saveSelectedMajors(List<String> majors) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setStringList('selectedMajors', majors);
// }

// // 선택 전공 목록 불러오기
// Future<List<String>?> getSelectedMajors() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getStringList('selectedMajors');
// }

// // 알림 전공 목록 저장
// Future<void> saveAlarmMajors(List<String> majors) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setStringList('alarmMajors', majors);
// }

// // 알림 전공 목록 불러오기
// Future<List<String>?> getAlarmMajors() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getStringList('alarmMajors');
// }

// // 선택 키워드 목록 저장
// Future<void> saveSelectedKeywords(List<String> keywords) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setStringList(('selectedKeywords'), keywords);
// }

// // 선택 키워드 목록 불러오기
// Future<List<String>?> getSelectedKeywords() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getStringList('selectedKeywords');
// }

// // 알림 키워드 목록 저장
// Future<void> saveAlarmKeywords(List<String> alarmkeywords) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setStringList(('alarmKeywords'), alarmkeywords);
// }

// // 알림 키워드 목록 불러오기
// Future<List<String>?> getAlarmKeywords() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getStringList('alarmKeywords');
// }

// // URL 목록 저장
// Future<void> saveUrl(List<String> url) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setStringList('savedUrl', url);
// }

// // URL 불러오기
// Future<List<String>?> getSavedUrl() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getStringList('savedUrl');
// }

// // 최근 검색어 저장
// Future<void> saveSearch(List<String> word) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setStringList('savedSearch', word);
// }

// // 최근 검색어 불러오기
// Future<List<String>?> getSavedSearch() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getStringList('savedSearch');
// }
