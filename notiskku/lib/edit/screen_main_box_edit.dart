import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notiskku/providers/user/user_provider.dart';

class ScreenMainBoxEdit extends ConsumerStatefulWidget {
  const ScreenMainBoxEdit({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ScreenMainBoxEditState();
  }
}

class _ScreenMainBoxEditState extends ConsumerState<ScreenMainBoxEdit> {
  final Set<String> _selectedHashes = {};
  List<DocumentSnapshot>? _noticeDocs;

  @override
  void initState() {
    super.initState();
    _loadNotices();
  }

  Future<void> _loadNotices() async {
    final starredHashes = ref.read(userProvider).starredNotices;
    if (starredHashes.isEmpty) {
      setState(() => _noticeDocs = []);
      return;
    }

    final chunks = <List<String>>[];
    for (var i = 0; i < starredHashes.length; i += 10) {
      chunks.add(starredHashes.skip(i).take(10).toList());
    }

    final Map<String, DocumentSnapshot> docMap = {};
    for (final chunk in chunks) {
      final query =
          await FirebaseFirestore.instance
              .collection('notices')
              .where(FieldPath.documentId, whereIn: chunk)
              .get();
      for (var doc in query.docs) {
        docMap[doc.id] = doc;
      }
    }

    final orderedDocs =
        starredHashes.reversed
            .where((hash) => docMap.containsKey(hash))
            .map((hash) => docMap[hash]!)
            .toList();

    setState(() => _noticeDocs = orderedDocs);
  }

  // ====== NoticeTile과 동일한 한글 줄바꿈 개선 함수 ======
  String applyWordBreakFix(String text) {
    final RegExp emoji = RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])',
    );
    String fullText = '';
    List<String> words = text.split(' ');
    for (var i = 0; i < words.length; i++) {
      fullText +=
          emoji.hasMatch(words[i])
              ? words[i]
              : words[i].replaceAllMapped(
                RegExp(r'(\S)(?=\S)'),
                (m) => '${m[1]}\u200D',
              );
      if (i < words.length - 1) fullText += ' ';
    }
    return fullText;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final scheme = theme.colorScheme;

    final starredHashes = ref.watch(userProvider).starredNotices;
    final bool isAllSelected =
        _selectedHashes.length == starredHashes.length &&
        starredHashes.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Center(
            child: Text(
              '취소',
              style: textTheme.headlineMedium?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: scheme.error,
              ),
            ),
          ),
        ),
        title: Text(
          '공지 편집',
          style: textTheme.headlineMedium?.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                if (_selectedHashes.length == starredHashes.length) {
                  _selectedHashes.clear();
                } else {
                  _selectedHashes
                    ..clear()
                    ..addAll(starredHashes);
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                '전체선택',
                style: textTheme.headlineMedium?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isAllSelected ? scheme.primary : scheme.outline,
                ),
              ),
            ),
          ),
        ],
      ),
      body:
          _noticeDocs == null
              ? const Center(child: CircularProgressIndicator())
              : _noticeDocs!.isEmpty
              ? Center(
                child: Text(
                  '저장된 공지가 없습니다.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: scheme.outline,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
              : Column(
                children: [
                  SizedBox(height: 10.h),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _noticeDocs!.length,
                      itemBuilder: (context, index) {
                        final doc = _noticeDocs![index];
                        final hash = doc.id;
                        final data = doc.data() as Map<String, dynamic>;
                        final title = data['title'] ?? '';
                        final date = data['date'] ?? '';
                        final views = data['views'] ?? 0;
                        final isSelected = _selectedHashes.contains(hash);

                        return Column(
                          children: [
                            ListTile(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedHashes.remove(hash);
                                  } else {
                                    _selectedHashes.add(hash);
                                  }
                                });
                              },
                              title: Padding(
                                padding: const EdgeInsets.only(
                                  left: 1.0,
                                  right: 1.0,
                                  top: 4.0,
                                  bottom: 3.0,
                                ),
                                child: Text(
                                  applyWordBreakFix(title),
                                  style: textTheme.headlineMedium?.copyWith(
                                    fontSize: 12.sp,
                                    height: 1.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  '$date | 조회수: $views',
                                  style: textTheme.labelSmall?.copyWith(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                    color: scheme.outline,
                                  ),
                                ),
                              ),
                              trailing: Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color:
                                    isSelected
                                        ? scheme.primary
                                        : scheme.outline,
                                size: 26.sp,
                              ),
                            ),
                            Divider(
                              color: scheme.outline,
                              thickness: 1.h,
                              indent: 16.w,
                              endIndent: 16.w,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 30.h),
                    child: SizedBox(
                      width: 301.w,
                      height: 43.h,
                      child: TextButton(
                        onPressed:
                            _selectedHashes.isEmpty
                                ? null
                                : () {
                                  final userNotifier = ref.read(
                                    userProvider.notifier,
                                  );
                                  for (final notice in _selectedHashes) {
                                    userNotifier.toggleStarredNotice(notice);
                                  }
                                  Navigator.pop(context);
                                },
                        style: TextButton.styleFrom(
                          foregroundColor: scheme.surface,
                          backgroundColor: scheme.error,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '삭제',
                              style: textTheme.headlineMedium?.copyWith(
                                color: scheme.surface,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
