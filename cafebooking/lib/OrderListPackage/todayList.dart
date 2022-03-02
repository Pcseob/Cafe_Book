// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:provider/provider.dart';
// // import 'package:flutter/material.dart';
// // import 'package:cakeorder/ProviderPackage/cakeDataClass.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter_slidable/flutter_slidable.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';

// class OrderPage extends StatefulWidget {
//   @override
//   _AddOrderState createState() => _AddOrderState();
//   // State createState() => new MyAppState();
// }

// class _AddOrderState extends _TodayParent<OrderPage> {
//   @override
//   setListData() => Provider.of<List<CakeDataOrder>>(context);

//   @override
//   listViewSecondRow(int index) {
//     String customerName = _listData[index].customerName;
//     bool payStatus;
//     if (customerName.length > 5)
//       customerName = customerName.split('').getRange(0, 5).join() + "..";
//     if (_listData[index].payStatus != null)
//       payStatus = _listData[index].payStatus;
//     else
//       payStatus = _listData[index].payInCash || _listData[index].payInStore;

//     return Flexible(
//         // width: MediaQuery.of(context).size.width,
//         // margin: EdgeInsets.symmetric(vertical: 3.h),
//         child:
//             Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//       Row(
//         children: [
//           Icon(
//             Icons.payment,
//             size: 20.sp,
//           ),
//           Icon(
//             payStatus ? Icons.check : Icons.close,
//             color: Colors.redAccent,
//             size: 18.sp,
//           ),
//         ],
//       ),
//       Row(
//         children: [
//           Icon(
//             Icons.person,
//             size: 15.sp,
//           ),
//           Container(
//             child: Text(customerName),
//           ),
//         ],
//       )
//     ]));
//   }

//   @override
//   List<Widget> customSwipeIconWidget(int index) {
//     var _cakeData = _listData[index];
//     return [
//       IconSlideAction(
//         caption: 'Delete!',
//         color: Colors.redAccent,
//         icon: Icons.delete,
//         closeOnTap: false,
//         onTap: () {
//           setState(() {
//             _firestoreDataUpdate(_cakeData, isUndo: false);
//             _listData.remove(_cakeData);
//           });
//           ScaffoldMessenger.of(context)
//               .showSnackBar(_deleteSnackBar(_cakeData, index: index));
//         },
//       )
//     ];
//   }

//   _deleteSnackBar(var cakeData, {int index}) {
//     return SnackBar(
//       behavior: SnackBarBehavior.floating,
//       content: Text('삭제 완료!'),
//       action: SnackBarAction(
//         label: '취소',
//         textColor: Colors.redAccent,
//         onPressed: () {
//           setState(() {
//             _firestoreDataUpdate(cakeData, isUndo: true);
//             _listData.insert(index, cakeData);
//           });
//         },
//       ),
//     );
//   }

//   Future _firestoreDataUpdate(CakeData cakeData,
//       {@required bool isUndo}) async {
//     if (isUndo) {
//       cakeData.unDoFireStore();
//     } else {
//       FirebaseFirestore.instance
//           .collection("Cake")
//           .doc(cakeData.documentId)
//           .delete();
//     }
//   }

//   @override
//   setSlidableDrawerActionPane(int index) {
//     var _cakeData = _listData[index];
//     return SlidableDismissal(
//       child: SlidableDrawerDismissal(
//         key: UniqueKey(),
//       ),
//       onDismissed: (actionType) {
//         setState(() {
//           _listData.remove(_cakeData);
//           _firestoreDataUpdate(_cakeData, isUndo: false);
//         });
//         ScaffoldMessenger.of(context)
//             .showSnackBar(_deleteSnackBar(_cakeData, index: index));
//       },
//     );
//     // return super.setSlidableDrawerActionPane();
//   }

//   @override
//   bool get wantKeepAlive => true;
// }

// class PickUpPage extends StatefulWidget {
//   @override
//   _PickUpPageState createState() => _PickUpPageState();
//   // State createState() => new MyAppState();

// }

// class _PickUpPageState extends _TodayParent<PickUpPage> {
//   @override
//   setListData() => Provider.of<List<CakeDataPickUp>>(context);
//   @override
//   listViewThirdRow(int index) {
//     bool isPickUpDateNull = _listData[index].pickUpDate == null;
//     String customerName = _listData[index].customerName;
//     var pickUpDateData = _listData[index].pickUpDate.toString().split('');
//     String customerPhone = _listData[index].customerPhone;
//     int dateLength = _listData[index].orderDate.toString().split('').length;
//     if (customerName.length > 5)
//       customerName = customerName.split('').getRange(0, 5).join() + "..";
//     if (customerPhone.length > 11)
//       customerPhone = customerPhone.split('').getRange(0, 11).join() + "..";
//     pickUpDateData.removeRange(dateLength - 7, dateLength);

//     return Flexible(
//       child: Container(
//         // margin: EdgeInsets.symmetric(vertical: 3.h),
//         child:
//             Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//           Flexible(
//             flex: 1,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Container(
//                   child: Icon(
//                     Icons.event,
//                     size: 20.sp,
//                   ),
//                 ),
//                 Container(
//                   child: Expanded(
//                     child: Text(
//                       !isPickUpDateNull ? pickUpDateData.join() : "EMPTY",
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                           color: Colors.redAccent,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 12.sp),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Flexible(
//             flex: 1,
//             child: Row(
//               // mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Container(
//                   child: Icon(
//                     Icons.person,
//                     size: 15.sp,
//                   ),
//                 ),
//                 Container(
//                   child: Flexible(
//                     child: Text(
//                       customerName + " " + customerPhone,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 12.sp,
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ]),
//       ),
//     );
//   }

//   @override
//   listViewSecondRow(int index) {
//     bool payStatus;
//     if (_listData[index].payStatus != null)
//       payStatus = _listData[index].payStatus;
//     else
//       payStatus = _listData[index].payInCash || _listData[index].payInStore;
//     return Flexible(
//         child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
//       Icon(
//         Icons.payment,
//         size: 20.sp,
//       ),
//       Icon(
//         payStatus ? Icons.check : Icons.close,
//         color: Colors.redAccent,
//         size: 18.sp,
//       ),
//       Container(
//         margin: EdgeInsets.only(left: 10.w),
//         child: Icon(
//           Icons.shopping_bag_outlined,
//           size: 20.sp,
//         ),
//       ),
//       Icon(
//         _listData[index].pickUpStatus ? Icons.check : Icons.close,
//         color: Colors.redAccent,
//         size: 18.sp,
//       ),
//     ]));
//   }

//   @override
//   List<Widget> customSwipeIconWidget(int index) {
//     var _cakeData = _listData[index];
//     if (!_listData[index].pickUpStatus) {
//       return [
//         IconSlideAction(
//           caption: 'Pick Up!',
//           color: Colors.yellowAccent,
//           icon: Icons.shopping_bag_outlined,
//           closeOnTap: true,
//           onTap: () {
//             setState(() {
//               _firestoreDataUpdate(_cakeData, isUndo: false);
//               // _listData.remove(_cakeData);
//               // _listData.add(_cakeData);
//             });
//             ScaffoldMessenger.of(context)
//                 .showSnackBar(_pickUpSnackBar(_cakeData));
//           },
//         )
//       ];
//     }
//     return [];
//   }

//   _pickUpSnackBar(var _cakeData) {
//     return SnackBar(
//       behavior: SnackBarBehavior.floating,
//       content: Text('픽업 완료!'),
//       action: SnackBarAction(
//         label: '취소',
//         textColor: Colors.redAccent,
//         onPressed: () {
//           setState(() {
//             // _listData.add(_cakeData);
//             _firestoreDataUpdate(_cakeData, isUndo: true);
//           });
//         },
//       ),
//     );
//   }

//   @override
//   setSlidableDrawerActionPane(int index) {
//     return;
//   }

//   Future _firestoreDataUpdate(CakeData cakeData,
//       {@required bool isUndo}) async {
//     FirebaseFirestore.instance
//         .collection("Cake")
//         .doc(cakeData.documentId)
//         .update({"pickUpStatus": !isUndo ? true : false});
//   }

//   @override
//   setListContainerBoxDecoration(int index) {
//     if (_listData[index].pickUpStatus) {
//       return BoxDecoration(
//           color: Colors.yellowAccent,
//           borderRadius: BorderRadius.all(Radius.circular(5.0)));
//     } else {
//       return super.setListContainerBoxDecoration(index);
//     }
//   }

//   @override
//   bool get wantKeepAlive => true;
// }

// abstract class _TodayParent<T extends StatefulWidget> extends State<T>
//     with AutomaticKeepAliveClientMixin {
//   // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   List<CakeData> _listData;
//   SlidableController slidableController;
//   // Animation<double> _rotationAnimation;
//   // Color _fabColor = Colors.blue;
//   @override
//   void initState() {
//     // slidableController = SlidableController(
//     //     onSlideAnimationChanged: handleSlideAnimationChanged,
//     //     onSlideIsOpenChanged: handleSlideIsOpenChanged);
//     super.initState();
//   }

//   // void handleSlideAnimationChanged(Animation<double> slideAnimation) {
//   //   setState(() {
//   //     _rotationAnimation = slideAnimation;
//   //   });
//   // }

//   // void handleSlideIsOpenChanged(bool isOpen) {
//   //   setState(() {
//   //     _fabColor = isOpen ? Colors.green : Colors.blue;
//   //   });
//   // }

//   setSlidableDrawerActionPane(int index);
//   setListContainerBoxDecoration(int index) {
//     return BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(5.0)),
//         border: Border.all(width: 1.0));
//   }

//   setListData();
//   @override
//   // ignore: must_call_super
//   Widget build(BuildContext context) {
//     _listData = setListData();

//     return _listData != null
//         ? _listData.length != 0
//             ? Container(
//                 // margin: EdgeInsets.only(top: 5.h),
//                 padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
//                 child: ListView.builder(
//                   itemCount: _listData.length,
//                   itemBuilder: (context, index) {
//                     return Slidable(
//                       key: ValueKey(_listData[index].documentId),
//                       actionPane: SlidableDrawerActionPane(),
//                       secondaryActions: customSwipeIconWidget(index),
//                       dismissal: setSlidableDrawerActionPane(index),
//                       child: GestureDetector(
//                         onTap: () {
//                           // Navigator.pushNamed(context, '/DetailPage',
//                           //     arguments: {"DATA": _listData[index]});
//                           Navigator.pushNamed(context, '/DetailPage',
//                               arguments: {"DATA": _listData[index]});
//                         },
//                         child: Container(
//                             padding: EdgeInsets.symmetric(
//                                 vertical: 5.h, horizontal: 3.w),
//                             // padding: EdgeInsets.only(
//                             //     left: 5.w, right: 5.w, top: 3.h),
//                             decoration: setListContainerBoxDecoration(index),
//                             // height: MediaQuery.of(context).size.height / 7,
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 listViewFirstRow(index),
//                                 listViewSecondRow(index),
//                                 listViewThirdRow(index),
//                                 listViewFourthdRow(index)
//                               ],
//                             )),
//                       ),
//                     );
//                   },
//                 ),
//               )
//             : Center(
//                 child: Container(
//                   child: Text("오늘 예약한 케이크가 없습니다."),
//                 ),
//               )
//         : Center(
//             child: Container(child: CupertinoActivityIndicator()),
//           );
//   }

//   Widget listViewFourthdRow(int index) {
//     String remark;
//     if (_listData[index].remark == "")
//       remark = "작성된 메모가 없습니다.";
//     else
//       remark = _listData[index].remark;
//     return Flexible(
//       child: Container(
//         // margin: EdgeInsets.only(bottom: 1.h),
//         child: Row(
//           children: [
//             Container(
//                 child: Icon(
//               Icons.comment,
//               size: 20.sp,
//             )),
//             Expanded(
//               child: Text(
//                 remark,
//                 style: TextStyle(fontSize: 13.sp),
//                 maxLines: 1,
//                 textAlign: TextAlign.start,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   List<Widget> customSwipeIconWidget(int index) {
//     return [
//       // IconSlideAction(
//       //   caption: 'Update',
//       //   color: Colors.grey,
//       //   icon: Icons.edit,
//       //   closeOnTap: false,
//       //   onTap: () {
//       //     // Navigator.pushNamed(context, '/AddOrder',arguments: );
//       //   },
//       // ),
//       IconSlideAction(
//         caption: 'PickUp!',
//         color: Colors.redAccent,
//         icon: Icons.close,
//         closeOnTap: false,
//         onTap: () {},
//       )
//     ];
//   }

//   listViewFirstRow(int index) {
//     bool isCakePriceNull = _listData[index].cakePrice == null;
//     bool isCakeCountNull = _listData[index].cakeCount == null;
//     int _totalPrice = _listData[index].cakePrice * _listData[index].cakeCount;
//     List<String> _addColon = _totalPrice.toString().split('');
//     int numberLength = _addColon.length;
//     int dotCount = (numberLength - 1) ~/ 3;
//     int firstDotLocation = ((numberLength - 1) % 3) + 1;
//     for (int i = 0; i < dotCount; i++) {
//       _addColon.insert(firstDotLocation + i * 4, ',');
//     }

//     return Flexible(
//       child: Container(
//           child: Row(children: [
//         Icon(
//           Icons.cake_outlined,
//           size: 20.sp,
//         ),
//         Text(
//           !isCakePriceNull
//               ? _listData[index].cakeCategory +
//                   _listData[index].cakeSize +
//                   " X" +
//                   _listData[index].cakeCount.toString()
//               : "EMPTY",
//           style: TextStyle(
//               color: Colors.redAccent,
//               fontWeight: FontWeight.bold,
//               fontSize: 13.sp),
//         ),
//         Spacer(),
//         Icon(Icons.money),
//         Text(!isCakeCountNull ? _addColon.join() : "EMPTY")
//       ])),
//     );
//   }

//   listViewSecondRow(int index) {
//     bool payStatus;
//     if (_listData[index].payStatus != null)
//       payStatus = _listData[index].payStatus;
//     else
//       payStatus = _listData[index].payInCash || _listData[index].payInStore;

//     return Flexible(
//       child: Container(
//           // margin: EdgeInsets.only(top: 3.h),
//           child:
//               Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//         Icon(
//           Icons.payment,
//           size: 20.sp,
//         ),
//         Icon(
//           payStatus ? Icons.check : Icons.close,
//           color: Colors.redAccent,
//           size: 18.sp,
//         )
//       ])),
//     );
//   }

//   listViewThirdRow(int index) {
//     bool isOrderDateNull = _listData[index].orderDate == null;
//     bool isPickUpDateNull = _listData[index].pickUpDate == null;
//     var orderDateData = _listData[index].orderDate.toString().split('');
//     var pickUpDateData = _listData[index].pickUpDate.toString().split('');
//     String partTimerName = _listData[index].partTimer;
//     int dateLength = _listData[index].orderDate.toString().split('').length;

//     orderDateData.removeRange(dateLength - 7, dateLength);
//     pickUpDateData.removeRange(dateLength - 7, dateLength);
//     if (partTimerName.length > 5)
//       partTimerName = partTimerName.split('').getRange(0, 5).join();

//     return Flexible(
//       child: Container(
//         // margin: EdgeInsets.symmetric(vertical: 3.h),
//         child:
//             Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//           Flexible(
//             flex: 1,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Container(
//                   child: Icon(
//                     Icons.event,
//                     size: 20.sp,
//                   ),
//                 ),
//                 Container(
//                   child: Expanded(
//                     child: Text(
//                       !isPickUpDateNull ? pickUpDateData.join() : "EMPTY",
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                           color: Colors.redAccent,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 12.sp),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Flexible(
//             flex: 1,
//             child: Row(
//               // mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Container(
//                   child: Icon(
//                     Icons.person,
//                     size: 15.sp,
//                   ),
//                 ),
//                 Container(
//                   child: Flexible(
//                     child: Text(
//                       !isOrderDateNull
//                           ? partTimerName + "  " + orderDateData.join()
//                           : "EMPTY",
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 10.sp,
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
// }
