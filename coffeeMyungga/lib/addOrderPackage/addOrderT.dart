import 'package:cakeorder/StateManagement/Riverpod/defineProvider.dart';
import 'package:cakeorder/addOrderPackage/Customdropdown/addCake.dart';
import 'package:cakeorder/addOrderPackage/Customdropdown/customDropDown.dart';
import 'package:cakeorder/addOrderPackage/cakeCount.dart';
import 'package:cakeorder/addOrderPackage/orderAbstract.dart';
import 'package:cakeorder/addOrderPackage/selectDate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TextEditingController를 사용하기 위해 State를 관리해야함 그래서 StatefulWidget을 사용
class AddOrder extends StatefulWidget {
  AddOrder({Key key}) : super(key: key);

  @override
  _AddOrderState createState() => _AddOrderState();
}

//OrderPage with
//Must set clickable
class _AddOrderState extends State<AddOrder> with OrderPage{
  TextEditingController orderDateTextController;
  TextEditingController orderTimeTextController;
  TextEditingController pickUpDateTextController;
  TextEditingController pickUpTimeTextController;
  TextEditingController partTimerTextController;
  TextEditingController cakeCategoryTextController;

  @override
  setData() {

  }
  
  @override
  setClickable() {
    isClickable = true;
    context = context;
  }

  //statefulWidget에서 Build되기 전 state를 하는 단계
  @override
  void initState() {
    initTextEdit();
    context.read(partTimerProvider).fetchData();
    context.read(cakePriceProvider).fetchData();
    super.initState();
  }

  @override
  void dispose() {
    partTimerTextController.dispose();
    super.dispose();
  }

  aboutCake(bool isClickable) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "케이크",
            style: TextStyle(fontSize: 18),
          ),
          AddCake(),
          CakeCountWidget(isClickable,orderCake: ,)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
          child: Column(
            children: [
              setOrderDateWidget(isClickable),
              setPickUpDateWidget(isClickable),
              aboutCake(isClickable),
              CustomDropDown(
                provider: partTimerProvider,
                textEditingController: partTimerTextController,
              ),
            ],
          ),
        ),
      ),
    );
  }

}
