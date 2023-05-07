// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:intl/intl.dart';
// import 'package:scadule/repository/sqlite.dart';


// class CalendarPage2 extends StatefulWidget {
//   const CalendarPage2({super.key});

//   @override
//   State<CalendarPage2> createState() => _CalendarPage2State();
// }

// class _CalendarPage2State extends State<CalendarPage2> {
//   var f = NumberFormat('###,###,###,###');
//   late DatabaseHandler handler; // DatabaseHandler 클라스로 만들어준 클라스
//   late DateTime _dateTime;
//   late TextEditingController startController;
//   late TextEditingController endController;
//   late List<String> year;
//   late List<String> month;
//   late List<String> day;
//   late Future<List<Calendar>> calList;

//   // 수입 지출 스위치
//   late bool _switch;
//   // 수입 지출
//   late String _status;

//   final titleController = TextEditingController(); // 제목
//   final amountController = TextEditingController(); // 금액
//   final contentController = TextEditingController(); // 메모
//   final categoryList = ["식비", "교통", "취미", "생활", "의류", "의료", "기타"];
//   late String _selectedList = "식비";

//   @override
//   void initState() {
//     super.initState();
//     handler = DatabaseHandler(); //생성자
//     _dateTime = DateTime.now();
//     startController = TextEditingController();
//     endController = TextEditingController();

//     Date.year = [];
//     Date.month = [];
//     Date.day = [];

//     for (var i = 1900; i <= _dateTime.year; i++) {
//       Date.year.add('$i');
//     }

//     for (var i = 1; i <= 12; i++) {
//       if (i < 10) {
//         Date.month.add('0$i');
//       } else {
//         Date.month.add('$i');
//       }
//     }

//     for (var i = 1; i <= 31; i++) {
//       if (i < 10) {
//         Date.day.add('0$i');
//       } else {
//         Date.day.add('$i');
//       }
//     }

//     year = [
//       _dateTime.year.toString(),
//       _dateTime.year.toString(),
//     ];

//     month = [
//       _dateTime.month < 10 ? '0${_dateTime.month}' : _dateTime.month.toString(),
//       _dateTime.month < 10 ? '0${_dateTime.month}' : _dateTime.month.toString(),
//     ];

//     day = [
//       _dateTime.day < 10 ? '0${_dateTime.day}' : _dateTime.day.toString(),
//       _dateTime.day < 10 ? '0${_dateTime.day}' : _dateTime.day.toString(),
//     ];

//     endController.text = '${year[1]}-${month[1]}-${day[1]}';
//     startController.text = '2000-01-01';

//     calList = handler.querySelectDate();

//     _switch = true;
//     _status = "지출";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Expanded(
//             child: FutureBuilder(
//               future: calList, //데이터베이스 부르는거
//               builder: (BuildContext context,
//                   AsyncSnapshot<List<Calendar>> snapshot) {
//                 //데이터는 스냅샷에 들어있다
//                 if (snapshot.hasData) {
//                   //데이터 있을경우
//                   return ListView.builder(
//                     itemCount: snapshot.data?.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       late Widget cardWidget;

//                       if (snapshot.data![index].inex != '샘플') {
//                         cardWidget = Card(
//                           margin: const EdgeInsets.all(0), // 카드간의 간격
//                           // elevation: 0,
//                           child: SizedBox(
//                             height: MediaQuery.of(context).size.height * 0.1,
//                             child: Row(
//                               children: [
//                                 SizedBox(
//                                   width: MediaQuery.of(context).size.width *
//                                       0.02,
//                                 ),
//                                 SizedBox(
//                                   width: MediaQuery.of(context).size.width *
//                                       0.13,
//                                   height: MediaQuery.of(context).size.width *
//                                       0.13,
//                                   child: CircleAvatar(
//                                     backgroundColor:
//                                         snapshot.data![index].inex == "수입"
//                                             ? const Color.fromARGB(
//                                                 255, 250, 187, 187)
//                                             : const Color.fromARGB(
//                                                 255, 177, 195, 255),
//                                     child: Text(
//                                       snapshot.data![index].inex == "수입"
//                                           ? '수입'
//                                           : '지출',
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: MediaQuery.of(context).size.width *
//                                       0.02,
//                                 ),
//                                 Container(
//                                   width: MediaQuery.of(context).size.width *
//                                       0.08,
//                                   height: 18,
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(30),
//                                       border: Border.all(
//                                         color: Colors.grey,
//                                       )),
//                                   child: Center(
//                                     child: Text(
//                                       snapshot.data![index].category,
//                                       style: const TextStyle(
//                                         color: Colors.grey,
//                                         fontSize: 10,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: MediaQuery.of(context).size.width *
//                                       0.02,
//                                 ),
//                                 SizedBox(
//                                   width: MediaQuery.of(context).size.width *
//                                       0.35,
//                                   child: Text(
//                                     snapshot.data![index].title,
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 17,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: MediaQuery.of(context).size.width *
//                                       0.01,
//                                 ),
//                                 SizedBox(
//                                   width: MediaQuery.of(context).size.width *
//                                       0.35,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.end,
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         snapshot.data![index].expenditure == 0
//                                             ? "+ ${f.format(snapshot.data![index].income)}원"
//                                             : "- ${f.format(snapshot.data![index].expenditure)}원",
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold,
//                                           color: snapshot.data![index]
//                                                       .expenditure ==
//                                                   0
//                                               ? const Color.fromARGB(
//                                                   255, 250, 187, 187)
//                                               : const Color.fromARGB(
//                                                   255, 177, 195, 255),
//                                         ),
//                                       ),
//                                       if (snapshot.data![index].content !=
//                                           "") ...[
//                                         const SizedBox(
//                                           height: 5,
//                                         ),
//                                         Text(
//                                           snapshot.data![index].content,
//                                           style: const TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.grey,
//                                           ),
//                                         ),
//                                       ]
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: MediaQuery.of(context).size.width *
//                                       0.02,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       }

//                       // query에서 불러온 결과 중에 내용이 들어있을 경우와 아닐경우에 각각 맞는 card를 만들기 위해서

//                       // 일별이 들어갈 텍스트 위젯
//                       late Text day;

//                       // 같은 일별로 카드를 하나씩만 찍어주기 위해서
//                       if (index == 0) {
//                         List<String> dayList =
//                             snapshot.data![index].writeday.split('-');
//                         day = Text(
//                           '${dayList[0]}년 ${dayList[1]}월 ${dayList[2]}일',
//                           textAlign: TextAlign.start,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         );
//                       } else if (snapshot.data![index - 1].writeday ==
//                           snapshot.data![index].writeday) {
//                         day = const Text('');
//                       } else {
//                         List<String> dayList =
//                             snapshot.data![index].writeday.split('-');

//                         day = Text(
//                           '${dayList[0]}년 ${dayList[1]}월 ${dayList[2]}일',
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         );
//                       }

//                       if (day.data == '') {
//                         return cardWidget;
//                       } else {
//                         return Column(
//                           children: [
//                             Row(children: [
//                               Padding(
//                                 padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
//                                 child: day,
//                               ),
//                             ]),
//                             cardWidget,
//                           ],
//                         );
//                       }
//                     },
//                   );
//                 } else {
//                   //데이터 없으면
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   _selectDate(
//       BuildContext context, TextEditingController controller, int index) {
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(30.0),
//       ),
//       builder: (context) {
//         return SizedBox(
//           height: MediaQuery.of(context).size.height * 0.5,
//           child: Column(
//             children: [
//               SizedBox(
//                 height: MediaQuery.of(context).size.height * 0.01,
//               ),
//               SizedBox(
//                 height: MediaQuery.of(context).size.height * 0.07,
//                 child: const Center(
//                   child: Text(
//                     '날짜 선택',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Color.fromARGB(255, 254, 155, 55),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: MediaQuery.of(context).size.height * 0.3,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width * 0.4,
//                       child: CupertinoPicker.builder(
//                         itemExtent: MediaQuery.of(context).size.width * 0.1,
//                         childCount: Date.year.length,
//                         scrollController: FixedExtentScrollController(
//                           initialItem: Date.year.length - 1,
//                         ),
//                         onSelectedItemChanged: (value) {
//                           setState(() {
//                             year[index] = Date.year[value];
//                             controller.text =
//                                 '${year[index]}-${month[index]}-${day[index]}';
//                           });
//                         },
//                         itemBuilder: (context, index) {
//                           return Center(
//                             child: Text(
//                               '${Date.year[index]}년',
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width * 0.3,
//                       child: CupertinoPicker(
//                         itemExtent: MediaQuery.of(context).size.width * 0.1,
//                         looping: true,
//                         scrollController: FixedExtentScrollController(
//                           initialItem: Date.month.indexOf(
//                             _dateTime.month < 10
//                                 ? '0${_dateTime.month}'
//                                 : _dateTime.month.toString(),
//                           ),
//                         ),
//                         onSelectedItemChanged: (value) {
//                           setState(() {
//                             month[index] = Date.month[value];
//                             controller.text =
//                                 '${year[index]}-${month[index]}-${day[index]}';
//                           });
//                         },
//                         children: Date.month
//                             .map(
//                               (e) => Center(
//                                 child: Text(
//                                   '$e월',
//                                 ),
//                               ),
//                             )
//                             .toList(),
//                       ),
//                     ),
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width * 0.3,
//                       child: CupertinoPicker(
//                         itemExtent: MediaQuery.of(context).size.width * 0.1,
//                         looping: true,
//                         scrollController: FixedExtentScrollController(
//                           initialItem: Date.day.indexOf(
//                             _dateTime.day < 10
//                                 ? '0${_dateTime.day}'
//                                 : _dateTime.day.toString(),
//                           ),
//                         ),
//                         onSelectedItemChanged: (value) {
//                           setState(() {
//                             day[index] = Date.day[value];
//                             controller.text =
//                                 '${year[index]}-${month[index]}-${day[index]}';
//                           });
//                         },
//                         children: Date.day
//                             .map(
//                               (e) => Center(
//                                 child: Text(
//                                   '$e일',
//                                 ),
//                               ),
//                             )
//                             .toList(),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
//                 child: Divider(
//                   height: MediaQuery.of(context).size.height * 0.03,
//                   color: Colors.black45,
//                 ),
//               ),
//               SizedBox(
//                 height: MediaQuery.of(context).size.height * 0.05,
//                 width: MediaQuery.of(context).size.width * 0.9,
//                 child: TextButton(
//                   child: const Text(
//                     '확인',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   onPressed: () => Navigator.of(context).pop(),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // function
//   _showUpdateEventDialog(Calendar calendar) async {
//     var id = calendar.id;

//     var title = calendar.title;
//     var category = calendar.category;
//     var content = calendar.content;

//     var inex = calendar.inex;
//     var income = calendar.income;
//     var expenditure = calendar.expenditure;

//     var writeday = calendar.writeday;

//     titleController.text = title;
//     amountController.text =
//         inex == '지출' ? expenditure.toString() : income.toString();
//     contentController.text = content;

//     setState(() {
//       _status = inex;
//       _switch = inex == '지출' ? true : false;
//       _selectedList = category;
//     });

//     await showDialog(
//         barrierDismissible: false, // 바깥영역 터치시 창닫기 x
//         context: context,
//         builder: (BuildContext context) {
//           return StatefulBuilder(builder: (context, setState) {
//             return AlertDialog(
//               title: const Text(
//                 "가계부 입력",
//                 textAlign: TextAlign.center,
//               ),
//               content: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Text(_status),
//                         Switch(
//                           value: _switch,
//                           onChanged: (value) {
//                             setState(() {
//                               _switch = value;
//                               _swichOnOff();
//                             });
//                           },
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         const Text("카테고리 선택 : "),
//                         DropdownButton(
//                           underline: const SizedBox.shrink(),
//                           value: _selectedList,
//                           items: categoryList.map((String item) {
//                             return DropdownMenuItem<String>(
//                               value: item,
//                               child: Text(item),
//                             );
//                           }).toList(),
//                           onChanged: (dynamic value) {
//                             setState(() {
//                               _selectedList = value;
//                             });
//                           },
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Text(
//                           "선택된 카테고리 : $_selectedList",
//                           style: const TextStyle(
//                             fontSize: 13,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//                     TextField(
//                       maxLength: 8,
//                       controller: titleController,
//                       textCapitalization: TextCapitalization.words,
//                       decoration: const InputDecoration(labelText: "제목"),
//                     ),
//                     TextField(
//                       maxLength: 8,
//                       controller: amountController,
//                       textCapitalization: TextCapitalization.words,
//                       decoration: const InputDecoration(labelText: "금액"),
//                       keyboardType: TextInputType.number,
//                       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                     ),
//                     TextField(
//                       maxLength: 8, // 글자수 제한
//                       controller: contentController,
//                       textCapitalization: TextCapitalization.words,
//                       decoration: const InputDecoration(labelText: "메모"),
//                     ),
//                   ],
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     titleController.clear();
//                     amountController.clear();
//                     contentController.clear();
//                     Navigator.pop(context);
//                   },
//                   child: const Text("취소"),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     if (titleController.text.isEmpty ||
//                         amountController.text.isEmpty) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text("제목과 가격을 모두 입력해 주세요!"),
//                           duration: Duration(seconds: 2),
//                           backgroundColor: Colors.red,
//                         ),
//                       );
//                     } else {
//                       updateCal(Calendar(
//                           id: id,
//                           title: titleController.text,
//                           inex: _status,
//                           income: _status == "지출"
//                               ? 0
//                               : int.parse(amountController.text),
//                           expenditure: _status == "수입"
//                               ? 0
//                               : int.parse(amountController.text),
//                           content: contentController.text,
//                           writeday: writeday,
//                           category: _selectedList));

//                       titleController.clear();
//                       amountController.clear();
//                       contentController.clear();
//                       Navigator.pop(context);
//                       return;
//                     }
//                   },
//                   child: const Text("수정"),
//                 ),
//               ],
//             );
//           });
//         });
//   }

//   _swichOnOff() {
//     if (_switch == true) {
//       setState(() {
//         _status = "지출";
//         _switch = true;
//       });
//     } else {
//       setState(() {
//         _status = "수입";
//         _switch = false;
//       });
//     }
//   }

//   // db에 데이터 저장
//   Future<int> updateCal(Calendar calendar) async {
//     Calendar updateCal = Calendar(
//         id: calendar.id,
//         title: calendar.title,
//         inex: calendar.inex,
//         income: calendar.income,
//         expenditure: calendar.expenditure,
//         content: calendar.content,
//         writeday: calendar.writeday,
//         category: calendar.category);

//     await handler.updateCal(updateCal);
//     setState(() {
//       calList = handler.querySelectDate();
//     });
//     return 0;
//   }

//   _showDeleteEventDialog(int id) {
//     showDialog(
//       barrierDismissible: false, // 바깥영역 터치시 창닫기 x
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text(
//             '정말 삭제하시겠습니까?',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text(
//                 '아니요',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Color.fromARGB(255, 255, 123, 123),
//                 ),
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 handler.deleteCal(id);
//                 setState(() {
//                   calList = handler.querySelectDate();
//                 });
//                 Navigator.of(context).pop();
//               },
//               child: const Text(
//                 '예',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Color.fromARGB(255, 107, 141, 252),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
