// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:notiskku/models/notice.dart';
// import 'package:notiskku/providers/starred_provider.dart';
// import 'package:notiskku/edit/screen_main_box_edit.dart';
// import 'package:notiskku/widget/list/list_starred_notices.dart';

// class ScreenMainBox extends ConsumerStatefulWidget {
//   const ScreenMainBox({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() {
//     return _ScreenMainBoxState();
//   }
// }

// class _ScreenMainBoxState extends ConsumerState<ScreenMainBox> {
//   bool editMode = false; // 편집 모드 여부
//   final Set<Notice> _selectedNotices = {}; // 편집 모드에서 선택된 공지 저장

//   @override
//   Widget build(BuildContext context) {
//     final starredNotices = ref.watch(starredProvider).starredNotices;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         scrolledUnderElevation: 0,
//         leading:
//             editMode
//                 ? Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         editMode = false;
//                         _selectedNotices.clear();
//                       });
//                     },
//                     child: Center(
//                       child: Text(
//                         '취소',
//                         style: TextStyle(
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//                 : Padding(
//                   padding: EdgeInsets.all(10.0),
//                   child: Image.asset(
//                     'assets/images/greenlogo_fix.png',
//                     width: 40,
//                   ),
//                 ),
//         title: Text(
//           '공지보관함',
//           style: TextStyle(
//             fontSize: 20.sp,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const ScreenMainBoxEdit(),
//                   ),
//                 );
//               },
//               child: Text(
//                 '편집',
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           SizedBox(height: 10.h),
//           Expanded(child: ListStarredNotices(notices: starredNotices)),
//         ],
//       ),
//     );
//   }
// }
