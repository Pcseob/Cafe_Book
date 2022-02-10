import 'package:cakeorder/StateManagement/DeclareData/cakePriceData.dart';
import 'package:cakeorder/StateManagement/Riverpod/defineProvider.dart';
import 'package:riverpod_context/riverpod_context.dart';

import 'package:cakeorder/addOrderPackage/Customdropdown/customDropDown.dart';
import 'package:flutter/material.dart';

class AddCake extends StatefulWidget {
  final bool clickable;
  AddCake({Key key, this.clickable}) : super(key: key);

  @override
  _AddCakeState createState() => _AddCakeState();
}

class _AddCakeState extends State<AddCake> {
  List<String> cakeData = [];
  TextEditingController textEditingController;
  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          CustomDropDown(
            callback: callbackCake,
            provider: cakePriceProvider,
          ),
          DropdownButton(
            value: textEditingController.text == ""
                ? null
                : textEditingController.text,
            items: cakeData
                .map((element) => DropdownMenuItem(
                      child: Text(element),

                      //value는 DropDownList에서 한 개가 선택되었을 때 어떤값이 반환되는 지 정한다.
                      value: element,
                    ))
                .toList(),
            onChanged: (value) => {
              setState(() {
                textEditingController..text = value;
              })
            },
          ),
          // CustomDropDownWidget(
          //   dropDownDataList: cakeData,
          // )
        ],
      ),
    );
  }

  callbackCake(String value) {
    cakeData = [];
    List<String> dropDownList = [];
    for (int i = 0; i < context.read(cakePriceProvider).getData.length; i++) {
      CakePriceData cakePriceData = context.read(cakePriceProvider).getData[i];

      if (cakePriceData.cakeName == value) {
        cakePriceData.cakeSizePrice.forEach((size, price) {
          dropDownList.add("$size : $price");
        });
        setState(() {
          textEditingController = TextEditingController();
          cakeData = dropDownList;
        });

        break;
      }
    }
  }
}
