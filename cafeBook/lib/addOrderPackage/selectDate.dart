import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//시간 및 날짜를 정할 때 사용하는 위젯
//isclickable로 dialog를 띄울 수 있는지 없는 지 확인한다.
//enablePastDate로 현재 이 전을 선택할 수 있는 지 체크.
//TextEditingController로 데이터 반환
//name으로 이름 띄워줌
//Icon으로 앞에 아이콘 설정
//CustomDate는 DatePicker가 띄워짐

class CustomDate extends StatelessWidget {
  final BuildContext context;
  final Function setStateCallback;
  final bool isClickable;
  final bool enablePastDate;
  final TextEditingController textEditingController;
  final String name;
  final Color textColor;
  final Icon decoIcon;
  CustomDate(
      {this.context,
      this.setStateCallback,
      this.isClickable,
      this.enablePastDate,
      this.textEditingController,
      this.name,
      this.textColor,
      this.decoIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 5.w),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            return isClickable
                ? showDialog(
                    context: context,
                    barrierColor: Colors.white,
                    builder: (context) => Container(
                      child: SfDateRangePicker(
                        monthCellStyle: DateRangePickerMonthCellStyle(
                            weekendTextStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                                color: Colors.red)),
                        monthViewSettings: DateRangePickerMonthViewSettings(
                            weekendDays: <int>[
                              DateTime.saturday,
                              DateTime.sunday
                            ]),
                        todayHighlightColor: Colors.red,
                        enablePastDates: enablePastDate,
                        onSelectionChanged: (arg) => _onSelectionChanged(arg),
                      ),
                    ),
                  )
                : null;
          },
          child: _customTextField(
            textEditingController,
          ),
        )
        // : Container(child: Text(dateText ?? '')),
        );
    // Setting time

    // SfDateRangePicker()
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs arg) {
    var _selectDate = arg.value.toString().split(' ')[0];
    textEditingController..text = _selectDate;
    Navigator.pop(context);
  }

  _customTextField(
    TextEditingController textEditingController,
  ) {
    return TextField(
      enabled: false,
      controller: textEditingController,
      decoration: InputDecoration(
        labelText: '$name 날짜',
        labelStyle: TextStyle(color: textColor),
        icon: decoIcon,
      ),
    );
  }

}

class CustomTimePicker extends StatelessWidget {
  final BuildContext context;
  final bool isClickable;

  final TextEditingController textEditingController;
  final String name;
  final Color textColor;
  final Icon decoIcon;
  final int minutesInterval;
  final bool setinitialTimeNow;
  CustomTimePicker(
      {this.context,
      this.isClickable,
      this.textEditingController,
      this.name,
      this.textColor,
      this.minutesInterval,
      this.setinitialTimeNow,
      this.decoIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(right: 5.w),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            return isClickable
                ? showAlertDialog(context,
                    pickUpTime: textEditingController.text)
                : null;
          },
          child: _customTextField(
            textEditingController,
          ),
        ));

    // Setting time

    // SfDateRangePicker()
  }

  _customTextField(
    TextEditingController textEditingController,
  ) {
    return TextField(
      enabled: false,
      controller: textEditingController,
      decoration: InputDecoration(
        labelText: '$name 시간',
        labelStyle: TextStyle(color: textColor),
        icon: decoIcon,
      ),
    );
  }

  void showAlertDialog(BuildContext context, {String pickUpTime}) async {
    await showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$name시간 설정'),
          content: TimePickerSpinner(
            is24HourMode: true,
            time: setInitDateTime(pickUpTime),
            minutesInterval: minutesInterval,
            spacing: 50,
            itemHeight: 80.h,
            isForce2Digits: true,
            onTimeChange: (time) {
              String selectTime = DateFormat('kk:mm').format(time);
              textEditingController..text = selectTime;
            },
          ),
        );
      },
    );
  }

  setInitDateTime(String pickUpTime) {
    DateTime _now = DateTime.now();
    return pickUpTime == ''
        ? setinitialTimeNow
            ? _now //set Current Time
            : DateTime.parse(DateTime.now().toString().split(' ')[0] +
                " 12:00:00.000") //set 00
        : DateTime.parse(DateTime.now().toString().split(' ')[0] +
            " " +
            pickUpTime +
            ":00.000"); //set previous time
  }
}
