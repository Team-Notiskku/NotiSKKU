import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/user/user_provider.dart';

class SearchKeyword extends ConsumerStatefulWidget {
  const SearchKeyword({super.key});

  @override
  ConsumerState<SearchKeyword> createState() => _SearchKeywordState();
}

class _SearchKeywordState extends ConsumerState<SearchKeyword> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final scheme = theme.colorScheme;

    return SizedBox(
      height: 40.h,
      child: Container(
        padding: EdgeInsets.only(left: 12.w, right: 5.w),
        decoration: BoxDecoration(
          border: Border.all(color: scheme.primary, width: 2.5.w),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: TextField(
                  controller: _controller,
                  maxLength: 50,
                  style: textTheme.bodyMedium?.copyWith(
                    color: scheme.onPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: '키워드를 입력하세요.',
                    hintStyle: textTheme.bodyMedium?.copyWith(
                      color: scheme.outline,
                    ),
                    counterText: '',
                    border: InputBorder.none,
                  ),
                  onChanged: (text) {
                    // 검색어가 바뀔 때마다 userProvider에 상태 업데이트
                    ref.read(userProvider.notifier).updateSearchText(text);
                    setState(() {}); // X 버튼 토글용
                  },
                ),
              ),
            ),
            Row(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      _controller.clear();
                      ref.read(userProvider.notifier).updateSearchText('');
                    },
                    icon: Icon(Icons.cancel, color: scheme.secondary),
                    padding: EdgeInsets.zero,
                    splashRadius: 10.w, // 터치 효과 반경 설정
                  ),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      _controller.clear();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Image.asset(
                        'assets/images/green_search.png',
                        width: 37.w,
                        fit: BoxFit.contain,
                        color: scheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
