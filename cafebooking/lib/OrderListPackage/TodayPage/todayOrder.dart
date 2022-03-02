import 'package:cafebooking/OrderListPackage/TodayPage/todayImplement.dart';
import 'package:cafebooking/StateManagement/DeclareData/cakeData.dart';
import 'package:cafebooking/StateManagement/Riverpod/defineProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

//오늘 예약된 현황을 볼 수 있는 리스트 ConsumerWidget으로 작성하여 상태가 변화하면 변화 할 수 있도록 함.
//StreamProvider이므로 notify가 없으므로 watch.when사용으로 streambuilder처럼 사용할 수 있도록 함.\
//TodayListImplement로 TodayOrder과 TodayPickup이 비슷한 UI구성되게 함.
class TodayOrder extends ConsumerWidget with TodayListImplement {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(cakeOrderProvider).when(
        loading: () => Center(
              child: CupertinoActivityIndicator(),
            ),
        error: (error, errorStack) => Center(
              child: Text("ERROR : $error,"),
            ),
        data: (List<CakeData> todayOrderList) =>
            listViewBuilder(todayOrderList));
  }

  @override
  listViewFirstRow(OrderData cakeData) {
    bool isCakePriceNull = cakeData.price == null;
    bool isCakeCountNull = cakeData.count == null;
    int _totalPrice = cakeData.price * cakeData.count;
    List<String> _addColon = _totalPrice.toString().split('');
    int numberLength = _addColon.length;
    int dotCount = (numberLength - 1) ~/ 3;
    int firstDotLocation = ((numberLength - 1) % 3) + 1;
    for (int i = 0; i < dotCount; i++) {
      _addColon.insert(firstDotLocation + i * 4, ',');
    }

    return Flexible(
      child: Container(
          child: Row(children: [
        Icon(
          Icons.cake_outlined,
          size: 20.sp,
        ),
        Text(
          !isCakePriceNull
              ? cakeData.bookCategory +
                  cakeData.size +
                  " X" +
                  cakeData.count.toString()
              : "EMPTY",
          style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp),
        ),
        Spacer(),
        Icon(Icons.money),
        Text(!isCakeCountNull ? _addColon.join() : "EMPTY")
      ])),
    );
  }

  @override
  listViewSecondRow(CakeData cakeData) {
    bool payStatus;
    if (cakeData.payStatus != null)
      payStatus = cakeData.payStatus;
    else
      payStatus = cakeData.payInCash || cakeData.payInStore;

    return Flexible(
      child: Container(
          // margin: EdgeInsets.only(top: 3.h),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Icon(
          Icons.payment,
          size: 20.sp,
        ),
        Icon(
          payStatus ? Icons.check : Icons.close,
          color: Colors.redAccent,
          size: 18.sp,
        )
      ])),
    );
  }

  @override
  listViewThirdRow(CakeData cakeData) {
    bool isOrderDateNull = cakeData.orderDate == null;
    bool isPickUpDateNull = cakeData.pickUpDate == null;
    var orderDateData = cakeData.orderDate.toString().split('');
    var pickUpDateData = cakeData.pickUpDate.toString().split('');
    String partTimerName = cakeData.partTimer;
    int dateLength = cakeData.orderDate.toString().split('').length;

    orderDateData.removeRange(dateLength - 7, dateLength);
    pickUpDateData.removeRange(dateLength - 7, dateLength);
    if (partTimerName.length > 5)
      partTimerName = partTimerName.split('').getRange(0, 5).join();

    return Flexible(
      child: Container(
        // margin: EdgeInsets.symmetric(vertical: 3.h),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Icon(
                    Icons.event,
                    size: 20.sp,
                  ),
                ),
                Container(
                  child: Expanded(
                    child: Text(
                      !isPickUpDateNull ? pickUpDateData.join() : "EMPTY",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              // mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: Icon(
                    Icons.person,
                    size: 15.sp,
                  ),
                ),
                Container(
                  child: Flexible(
                    child: Text(
                      !isOrderDateNull
                          ? partTimerName + "  " + orderDateData.join()
                          : "EMPTY",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }

  @override
  Widget listViewFourthdRow(CakeData cakeData) {
    String remark;
    if (cakeData.remark == "")
      remark = "작성된 메모가 없습니다.";
    else
      remark = cakeData.remark;
    return Flexible(
      child: Container(
        // margin: EdgeInsets.only(bottom: 1.h),
        child: Row(
          children: [
            Container(
                child: Icon(
              Icons.comment,
              size: 20.sp,
            )),
            Expanded(
              child: Text(
                remark,
                style: TextStyle(fontSize: 13.sp),
                maxLines: 1,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  swipeAction() {
    throw UnimplementedError();
  }
}
