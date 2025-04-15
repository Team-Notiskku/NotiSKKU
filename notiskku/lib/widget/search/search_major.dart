import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/providers/user/user_provider.dart';

class SearchMajor extends ConsumerStatefulWidget {
  const SearchMajor({super.key});

  @override
  ConsumerState<SearchMajor> createState() => _SearchMajorState();
}

class _SearchMajorState extends ConsumerState<SearchMajor> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: Container(
        padding: EdgeInsets.only(left: 12.w, right: 5),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF0B5B42), width: 2.5.w),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                maxLength: 50,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  hintText: '검색어를 입력하세요.',
                  hintStyle: TextStyle(
                    fontSize: 18.sp,
                    color: const Color(0xFFD9D9D9),
                  ),
                  counterText: '',
                  border: InputBorder.none,
                ),
                onChanged: (text) {
                  ref.read(userProvider.notifier).updateSearchText(text);
                },
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
                    icon: const Icon(Icons.cancel, color: Color(0xff979797)),
                    padding: EdgeInsets.zero,
                    splashRadius: 10.w, // 터치 효과 반경 설정
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      _controller.clear();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Image.asset(
                        'assets/images/green_search.png',
                        width: 37.w,
                        fit: BoxFit.contain,
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
