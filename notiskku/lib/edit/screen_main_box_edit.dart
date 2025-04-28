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
    final docs = <DocumentSnapshot>[];
    for (final chunk in chunks) {
      final query = await FirebaseFirestore.instance
          .collection('notices')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      docs.addAll(query.docs);
    }
    setState(() => _noticeDocs = docs);
  }

  @override
  Widget build(BuildContext context) {
    final starredHashes = ref.watch(userProvider).starredNotices;
    final bool isAllSelected =
        _selectedHashes.length == starredHashes.length && starredHashes.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Center(
            child: Text(
              '취소',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        ),
        title: Text(
          '공지 편집',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
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
              padding: EdgeInsets.all(10.0),
              child: Text(
                '전체선택',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: isAllSelected ? const Color(0xFF0B5B42) : const Color(0xFF979797),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: _noticeDocs == null
          ? const Center(child: CircularProgressIndicator())
          : _noticeDocs!.isEmpty
              ? Center(
                  child: Text(
                    '저장된 공지가 없습니다',
                    style: TextStyle(fontSize: 18.sp, color: Colors.grey),
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
                                title: Text(
                                  title,
                                  style: TextStyle(fontSize: 15.sp, color: Colors.black),
                                ),
                                subtitle: Text(
                                  '$date | 조회수: $views',
                                  style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                                ),
                                trailing: Icon(
                                  isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                                  color: isSelected ? const Color(0xFF0B5B42) : Colors.grey,
                                  size: 26.sp,
                                ),
                              ),
                              Divider(
                                color: Colors.grey,
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
                          onPressed: _selectedHashes.isEmpty
                              ? null
                              : () {
                                  final userNotifier = ref.read(userProvider.notifier);
                                  for (final notice in _selectedHashes) {
                                    userNotifier.toggleStarredNotice(notice);
                                  }
                                  Navigator.pop(context);
                                },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFFE64343),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                          ),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '삭제',
                                style: TextStyle(fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.w400, fontFamily: 'Inter'),
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
