import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notiskku/widget/list/list_notices.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/user/user_provider.dart';

class ListStarredNotices extends ConsumerWidget {
  const ListStarredNotices({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final scheme = theme.colorScheme;

    final userState = ref.watch(userProvider);
    final hashedStarredNotices = userState.starredNotices;

    if (hashedStarredNotices.isEmpty) {
      return Center(
        child: Text(
          '저장된 공지가 없습니다.',
          style: textTheme.bodyMedium?.copyWith(
            color: scheme.outline,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    Future<Widget> getStarredNoticesWidget(List<String> hashes) async {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('notices')
              .where(FieldPath.documentId, whereIn: hashes)
              .get();

      final noticeMap = {
        for (var doc in snapshot.docs) doc.id: {...doc.data(), 'hash': doc.id},
      };

      final orderedNotices =
          hashes.reversed
              .where((hash) => noticeMap.containsKey(hash))
              .map((hash) => noticeMap[hash]!)
              .toList();

      return ListNotices(notices: orderedNotices);
    }

    return FutureBuilder<Widget>(
      future: getStarredNoticesWidget(hashedStarredNotices),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('오류 발생: ${snapshot.error}'));
        } else {
          return snapshot.data ?? const Center(child: Text('공지 없음'));
        }
      },
    );
  }
}
