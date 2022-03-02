import 'package:cakeorder/addOrderPackage/selectDate.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//Default Create Order Page
abstract class OrderPage {
  bool isClickable;
  BuildContext context;

  TextEditingController orderDateTextController;
  TextEditingController orderTimeTextController;
  TextEditingController pickUpDateTextController;
  TextEditingController pickUpTimeTextController;
  TextEditingController partTimerTextController;
  TextEditingController cakeCategoryTextController;
  TextEditingController remarkTextController;
  TextEditingController cakeOrderTextController;

  //set Clickable and BuildContext
  setClickable();
  //set data about cakeCategory, count, size, name and memo
  setData();

  //initialization TextEdit controlller
  //using  Alter Order page or Detail Order page
  initTextEdit() {
    var _todayDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .toString()
            .split(' ')[0];
    String _todayTime = DateFormat('kk:mm').format(DateTime.now());
    orderDateTextController = TextEditingController(text: _todayDate);
    orderTimeTextController = TextEditingController(text: _todayTime);
    pickUpDateTextController = TextEditingController();
    pickUpTimeTextController = TextEditingController();
    partTimerTextController = TextEditingController();
    cakeCategoryTextController = TextEditingController();
  }

  setOrderDateWidget(bool clickable) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "주문 날짜",
            style: TextStyle(fontSize: 18),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: CustomDate(
                  context: context,
                  decoIcon: Icon(Icons.calendar_today),
                  isClickable: clickable,
                  enablePastDate: false,
                  textColor: Colors.black,
                  textEditingController: orderDateTextController,
                  name: "주문",
                ),
              ),
              Expanded(
                child: CustomTimePicker(
                  context: context,
                  decoIcon: Icon(Icons.alarm),
                  isClickable: clickable,
                  minutesInterval: 10,
                  name: "주문",
                  setinitialTimeNow: true,
                  textEditingController: orderTimeTextController,
                  textColor: Colors.black,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  setPickUpDateWidget(
    bool clickable,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "픽업 날짜",
            style: TextStyle(fontSize: 18),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: CustomDate(
                  context: context,
                  decoIcon: Icon(Icons.calendar_today),
                  isClickable: clickable,
                  enablePastDate: false,
                  textColor: Colors.redAccent,
                  textEditingController: pickUpDateTextController,
                  name: "픽업",
                ),
              ),
              Expanded(
                child: CustomTimePicker(
                  context: context,
                  decoIcon: Icon(Icons.alarm),
                  isClickable: clickable,
                  minutesInterval: 30,
                  name: "픽업",
                  setinitialTimeNow: true,
                  textEditingController: pickUpTimeTextController,
                  textColor: Colors.redAccent,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
