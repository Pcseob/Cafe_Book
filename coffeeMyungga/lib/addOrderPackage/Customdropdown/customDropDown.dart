import 'package:cakeorder/StateManagement/Riverpod/defineProvider.dart';
import 'package:cakeorder/StateManagement/Riverpod/stateScreen/loadingScreen/loadingMain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomDropDown extends ConsumerWidget {
  //padding값이 필요한 경우,
  //현재 상황에 맞는 provider를 받아오기
  //DropDownButton에서 선택된 값을 띄워주기 위한 textEditingController를 받아온다.
  //textEditingController를 매개변수로 가져오는 것이 아닌 Callback함수를 받아와서 textEditingController를 업데이트 시켜도 무방하다.
  CustomDropDown(
      {this.paddingEdgeInsets,
      this.provider,
      this.textEditingController,
      this.callback});

  //null safety
  final EdgeInsetsGeometry paddingEdgeInsets;
  final provider;
  final TextEditingController textEditingController;
  final Function callback;

  @override
  //watch는 Provider를 관찰하는 역할
  //watch된 Provider에서 notifyListener()가 작동하는지 확인한다.
  Widget build(BuildContext context, ScopedReader watch) {
    //Provider를 watch
    final watchProvider = watch(provider);

    //Provider에서 isFetch가 true인 경우 데이터를 가져오는 중
    if (watchProvider.isFetching) {
      return Center(
        child: CupertinoActivityIndicator(),
      );
    } else {
      //Provider에서 isFetch가 false인 경우 widget을 띄운다.
      return Container(
          padding: paddingEdgeInsets,
          child: CustomDropDownWidget(
            textEditingController: textEditingController,
            callback: callback,
            //Provider에서 DropDownList를 매개변수로 넘겨준다.
            dropDownDataList: watchProvider.dropDownData,
          ));
    }
  }
}

//DropDown은 StatefulWidget으로 상속받아 만들어져있다.
class CustomDropDownWidget extends StatefulWidget {
  //매개변수로 받아온 List와 textEditingController.
  CustomDropDownWidget({
    this.dropDownDataList,
    this.textEditingController,
    this.callback,
  });
  final List dropDownDataList;
  final TextEditingController textEditingController;
  final Function callback;

  @override
  _CustomDropDownWidgetState createState() => _CustomDropDownWidgetState();
}

class _CustomDropDownWidgetState extends State<CustomDropDownWidget> {
  List dropDownDataList = [];
  TextEditingController textEditingController;
  Function callback;
  bool isInitValue;

  @override
  void initState() {
    //'widget. '으로 선언된 데이터를 가져올 수 있다.
    // dropDownDataList = widget.dropDownDataList;
    textEditingController =
        widget.textEditingController ?? TextEditingController();
    callback = widget.callback;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Value : DropDownButton에서 선택된 값.
    //Items : DropDownbutton 데이터
    dropDownDataList = widget.dropDownDataList;
    // if (dropDownDataList.contains(textEditingController.text))
    //   textEditingController.text = "";

    return DropdownButton(
      //textEditingController에 있는 text를 value로 띄워준다.
      //null이라면 아무것도 선택되지 않은 상태이다.
      value:
          textEditingController.text == "" ? null : textEditingController.text,

      //Items는 DropDown에서 보여주는 목록리스트이다.
      items: dropDownDataList
          .map((element) => DropdownMenuItem(
                child: Text(element),

                //value는 DropDownList에서 한 개가 선택되었을 때 어떤값이 반환되는 지 정한다.
                value: element,
              ))
          .toList(),

      //DropDownButton에서 선택된 데이터를 띄워주기 위한 setState.
      //setState는 DropDownButton에만 작동한다.
      onChanged: (value) {
        setState(() {
          if (callback != null) {
            callback(value);
          }

          textEditingController..text = value;
        });
      },

      icon: Icon(Icons.keyboard_arrow_down),
    );
  }
}
