import 'package:flutter_test/flutter_test.dart';
import 'package:notiskku/models/notice.dart';

void main() {
  test('Notice parses Firestore-style JSON data', () {
    final notice = Notice.fromJson({
      'id': 'notice-1',
      'category': 'common',
      'title': 'Test notice',
      'date': '2026-07-24',
      'uploader': 'NotiSKKU',
      'views': '10',
      'link': 'https://example.com/notices/1',
    });

    expect(notice.toJson(), {
      'id': 'notice-1',
      'category': 'common',
      'title': 'Test notice',
      'date': '2026-07-24',
      'uploader': 'NotiSKKU',
      'views': '10',
      'link': 'https://example.com/notices/1',
    });
  });
}
