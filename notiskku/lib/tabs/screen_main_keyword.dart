import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notiskku/models/keyword.dart';
import 'package:notiskku/widget/bar/bar_keywords.dart';
import 'package:notiskku/widget/list/list_notices.dart';

class ScreenMainKeyword extends ConsumerWidget {
  const ScreenMainKeyword({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedKeyword = ref.watch(selectedKeywordProvider);

    Future<Widget> getNoticeByKeyword(Keyword keyword) async {
      final keywordText = keyword.keyword;

      final snapshot =
          await FirebaseFirestore.instance
              .collection('notices')
              .where('type', isEqualTo: "전체")
              .orderBy('date', descending: true)
              .get();

      final results =
          snapshot.docs
              .where(
                (doc) => doc['title'].toString().toLowerCase().contains(
                  keywordText.toLowerCase(),
                ),
              )
              .map((doc) {
                final data = doc.data();
                data['hash'] = doc.id;
                return data;
              })
              .toList();

      return ListNotices(notices: results);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(10.0),
          child: Image.asset('assets/images/greenlogo_fix.png', width: 40.w),
        ),
        title: Text(
          '키워드',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const BarKeywords(),
          SizedBox(height: 10.h),

          Expanded(
            child: FutureBuilder<Widget>(
              future:
                  selectedKeyword == null
                      ? Future.value(
                        const Center(child: Text('선택된 키워드가 없습니다.')),
                      )
                      : getNoticeByKeyword(selectedKeyword),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('오류 발생: ${snapshot.error}'));
                } else {
                  return snapshot.data ?? const Center(child: Text('공지 없음'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
