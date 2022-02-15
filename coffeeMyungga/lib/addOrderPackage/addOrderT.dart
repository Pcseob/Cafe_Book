import 'package:cakeorder/StateManagement/Riverpod/defineProvider.dart';
import 'package:cakeorder/addOrderPackage/addCategory/Customdropdown/addCake.dart';
import 'package:cakeorder/addOrderPackage/addCategory/Customdropdown/customDropDown.dart';
import 'package:cakeorder/addOrderPackage/addCategory/addBookMain.dart';
import 'package:cakeorder/addOrderPackage/addCategory/cakeCount.dart';
import 'package:cakeorder/addOrderPackage/orderAbstract.dart';
import 'package:cakeorder/addOrderPackage/selectDate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpod_context/riverpod_context.dart';

// TextEditingController를 사용하기 위해 State를 관리해야함 그래서 StatefulWidget을 사용
class AddOrder extends StatefulWidget {
  AddOrder({Key key}) : super(key: key);

  @override
  _AddOrderState createState() => _AddOrderState();
}

//OrderPage with
//Must set clickable
class _AddOrderState extends State<AddOrder> with OrderPage {
  @override
  setData() {
    debugPrint("statement");
    //Remark PartTimer name set empty
    remarkTextController = TextEditingController();
    partTimerTextController = TextEditingController();
    cakeOrderTextController = TextEditingController();
  }

  @override
  setClickable() {
    //Clickable
    isClickable = true;
    context = context;
  }

  //statefulWidget에서 Build되기 전 state를 하는 단계
  @override
  void initState() {
    initTextEdit();
    // debugPrint("1");
    // context.read(partTimerProvider).fetchData();
    // debugPrint("2");
    // context.read(cakePriceProvider).fetchData();
    // debugPrint("3");
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
          BookingCakeCategory(
            isClickable: true,
          )
          //*******추가해야하는 부분 */
          //addBookMain을 추가해야할 부분
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
