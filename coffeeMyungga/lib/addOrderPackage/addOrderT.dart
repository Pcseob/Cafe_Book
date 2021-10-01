import 'package:cakeorder/StateManagement/Riverpod/defineProvider.dart';
import 'package:cakeorder/addOrderPackage/Customdropdown/partTimerDropDown.dart';
import 'package:cakeorder/addOrderPackage/selectDate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TextEditingController를 사용하기 위해 State를 관리해야함 그래서 StatefulWidget을 사용
//
class AddOrder extends StatefulWidget {
  AddOrder({Key key}) : super(key: key);

  @override
  _AddOrderState createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  TextEditingController orderDateTextController;
  TextEditingController orderTimeTextController;
  TextEditingController pickUpDateTextController;
  TextEditingController pickUpTimeTextController;
  TextEditingController partTimerTextController;
  TextEditingController cakeCategoryTextController;

  @override
  void initState() {
    initTextEdit();
    context.read(partTimerProvider).fetchPartTimerData();
    context.read(cakePriceProvider).fetchCakePriceData();
    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
          child: Column(
            children: [
              setOrderDateWidget(true),
              setPickUpDateWidget(true),
              CustomDropDown(
                provider: partTimerProvider,
                textEditingController: partTimerTextController,
              ),
              CustomDropDown(
                provider: cakePriceProvider,
                textEditingController: cakeCategoryTextController,
              )
            ],
          ),
        ),
      ),
    );
  }

  setOrderDateWidget(
    bool clickable,
  ) {
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
