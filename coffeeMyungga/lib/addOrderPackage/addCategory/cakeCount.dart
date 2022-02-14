import 'package:cakeorder/StateManagement/DeclareData/cakeData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CakeCountWidget extends StatelessWidget {
  final OrderData orderCake;
  final Function callback;
  final bool isChangeable;
  CakeCountWidget(this.isChangeable, {this.orderCake, this.callback});

  @override
  Widget build(BuildContext context) {
    return isChangeable
        ? Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15.h),
                  child: Text(
                    '수량',
                    style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  // margin: EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _minusButton(),
                      _countTextField(),
                      _plusButton()
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container(
            child: Text("${orderCake.count}개"),
          );
  }

  // Widget countWidget({bool isvisible}) {
  //   cakeCount = cakeCount ?? 0;
  //   isvisible = isvisible ?? false;
  //   return Visibility(
  //     visible: isvisible,
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Container(
  //           margin: EdgeInsets.only(top: 15.h),
  //           child: Text(
  //             '수량',
  //             style: TextStyle(
  //                 fontSize: 15.sp,
  //                 color: Colors.redAccent,
  //                 fontWeight: FontWeight.bold),
  //           ),
  //         ),
  //         Container(
  //           // margin: EdgeInsets.only(top: 15),
  //           child: Row(
  //             mainAxisAlignment: !isDetailPage
  //                 ? MainAxisAlignment.end
  //                 : MainAxisAlignment.center,
  //             children: [_minusButton(), _countTextField(), _plusButton()],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  _minusButton() {
    int count = orderCake.count ?? 0;
    return Visibility(
        visible: orderCake.count > 1,
        child: Container(
            child: IconButton(
          icon: Icon(Icons.horizontal_rule),
          onPressed: () {
            callback(--count);
          },
        )));
  }

  _countTextField() {
    int count = orderCake.count;
    return Container(
        child: Text(
      count == 0 ? "수량" : count.toString(),
      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
    ));
  }

  _plusButton() {
    int count = orderCake.count;
    return Container(
        child: IconButton(
      icon: Icon(Icons.add),
      onPressed: () {
        callback(++count);
      },
    ));
  }
}
