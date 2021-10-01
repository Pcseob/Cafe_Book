import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomDropDown extends ConsumerWidget {
  CustomDropDown(
      {this.paddingEdgeInsets, this.provider, this.textEditingController});
  //null safety
  final EdgeInsetsGeometry paddingEdgeInsets;
  final provider;
  final TextEditingController textEditingController;
  @override
  Widget build(BuildContext context, watch) {
    final watchProvider = watch(provider);
    if (watchProvider.isFetching) {
      //데이터 가지고오는 상태
      return Center(
        child: CupertinoActivityIndicator(),
      );
    } else {
      return Container(
          padding: paddingEdgeInsets,
          child: CustomDropDownWidget(
            textEditingController: textEditingController,
            dropDownDataList: watchProvider.dropDownData,
          ));
    }
  }
}

class CustomDropDownWidget extends StatefulWidget {
  CustomDropDownWidget({this.dropDownDataList, this.textEditingController});
  final List dropDownDataList;
  final TextEditingController textEditingController;

  @override
  _CustomDropDownWidgetState createState() => _CustomDropDownWidgetState();
}

class _CustomDropDownWidgetState extends State<CustomDropDownWidget> {
  List dropDownDataList = [];
  TextEditingController textEditingController;
  @override
  void initState() {
    dropDownDataList = widget.dropDownDataList;
    textEditingController = widget.textEditingController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Value : Initial Selected Value, 처음 아무것도 하지 않았을 때 설정되는 값
    //Items : DropDownbutton 데이터

    return DropdownButton(
      value:
          textEditingController.text == "" ? null : textEditingController.text,
      items: dropDownDataList
          .map((element) => DropdownMenuItem(
                child: Text(element),
                value: element,
              ))
          .toList(),
      onChanged: (value) => {
        setState(() {
          textEditingController..text = value;
        })
      },
      icon: Icon(Icons.keyboard_arrow_down),
    );
  }
}
