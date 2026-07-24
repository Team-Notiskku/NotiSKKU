import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notiskku/data/temp_starred_notices.dart';
import 'package:notiskku/edit/screen_main_keyword_edit.dart';
import 'package:notiskku/models/keyword.dart';
import 'package:notiskku/providers/user/user_provider.dart';
import 'package:notiskku/widget/bar/bar_keywords.dart';
import 'package:notiskku/widget/list/list_notices.dart';

class ScreenMainKeyword extends ConsumerWidget {
  const ScreenMainKeyword({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final selectedKeyword = ref.watch(selectedKeywordProvider);

    Future<Widget> getNoticeByKeyword(Keyword keyword) async {
      ref.read(userProvider.notifier).saveTempStarred(tempStarredNotices);
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
        leading: Padding(
          padding: EdgeInsets.all(15.0),
          child: Image.asset(
            'assets/images/green_logo_2025.png',
            width: 28.w,
            color: scheme.primary,
          ),
        ),
        title: Text('키워드'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const BarKeywords(),
          Expanded(
            child: FutureBuilder<Widget>(
              future:
                  selectedKeyword == null
                      ? Future.value(
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/no_major_exception.png',
                              width: 206.w,
                              height: 202.h,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              '키워드 선택 후 키워드별 공지를 볼 수 있어요.',
                              style: TextStyle(fontSize: 14.sp),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16.h),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            const ScreenMainKeywordEdit(),
                                  ),
                                );
                              },
                              child: Text(
                                '→ 키워드 선택하러 가기',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
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
