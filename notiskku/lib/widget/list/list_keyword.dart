import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 데이터 파일에 정의된 키워드 모델 리스트
import 'package:notiskku/data/keyword_data.dart';
import 'package:notiskku/providers/keyword_provider.dart';

class ListKeyword extends ConsumerWidget {
  final String searchText;

  const ListKeyword({Key? key, required this.searchText}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // provider를 통해 선택된 키워드 상태 확인
    final keywordState = ref.watch(keywordProvider);
    final keywordNotifier = ref.read(keywordProvider.notifier);

    // keyword_data.dart 파일의 키워드 리스트 (Keyword 모델의 keyword 속성만 추출)
    final availableKeywords = keywords.map((k) => k.keyword).toList();
    final filteredKeywords =
        availableKeywords.where((kw) {
          return kw.toLowerCase().contains(searchText.toLowerCase());
        }).toList();

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
      itemCount: filteredKeywords.length,
      itemBuilder: (context, index) {
        final keyword = filteredKeywords[index];
        final isSelected = keywordState.selectedKeywords.contains(keyword);
        // final isAlarm = keywordState.alarmKeywords.contains(keyword);
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                // 일반 키워드 선택/해제
                keywordNotifier.toggleKeyword(keyword);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 10.w),
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFD9D9D9), width: 1.5),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 키워드 텍스트
                    Text(
                      keyword,
                      style: TextStyle(
                        fontSize: 19.sp,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w400,
                        color:
                            isSelected
                                ? const Color(0xFF0B5B42)
                                : const Color(0xFF979797),
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check,
                        color: const Color(0xFF0B5B42),
                        size: 20.w,
                      ),
                  ],
                ),
              ),
            ),
            // Divider(color: const Color(0xFFD9D9D9), thickness: 2, height: 20.h),
          ],
        );
      },
    );
  }
}
