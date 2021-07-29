import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDate {
  final BuildContext context;
  Function setStateCallback;
  final bool isClickable;
  CustomDate({this.context, this.setStateCallback, this.isClickable});

  Widget dateNtimeRow({
    @required bool isOrderRow,
    @required TextEditingController controllerCalendar,
    @required TextEditingController controllerTimer,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        //Pick Calendar
        Flexible(
            child: Container(
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
                                monthViewSettings:
                                    DateRangePickerMonthViewSettings(
                                        weekendDays: <int>[
                                      DateTime.saturday,
                                      DateTime.sunday
                                    ]),
                                todayHighlightColor: Colors.red,
                                enablePastDates: isOrderRow ? true : false,
                                onSelectionChanged: (arg) =>
                                    _onSelectionChanged(arg, isOrderRow),
                              ),
                            ),
                          )
                        : null;
                  },
                  child: _customTextField(
                    controllerCalendar,
                    isOrderDate: isOrderRow,
                    isCalendar: true,
                  ),
                )
                // : Container(child: Text(dateText ?? '')),
                )),
        // Setting time
        Flexible(
          child: Container(
              padding: EdgeInsets.only(right: 5.w),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  return isClickable
                      ? showAlertDialog(context,
                          isOrderTime: isOrderRow, pickUpTime: controllerTimer)
                      : null;
                },
                child: _customTextField(
                  controllerTimer,
                  isOrderDate: isOrderRow,
                  isCalendar: false,
                ),
              )),
        ),
        // SfDateRangePicker()
      ],
    );
  }

  void _onSelectionChanged(
      DateRangePickerSelectionChangedArgs arg, bool isOrder) {
    var _selectDate = arg.value.toString().split(' ')[0];
    if (isOrder)
      this.setStateCallback("?isOrder=true&isCalendar=true&data=$_selectDate");
    else
      this.setStateCallback("?isOrder=false&isCalendar=true&data=$_selectDate");
    Navigator.pop(context);
  }

  _customTextField(
    TextEditingController textEditingController, {
    @required bool isOrderDate,
    @required bool isCalendar,
  }) {
    return TextField(
      enabled: false,
      controller: textEditingController,
      decoration: InputDecoration(
        labelText: isOrderDate ?? '날짜' ? '주문 날짜' : '픽업 날짜',
        labelStyle:
            TextStyle(color: isOrderDate ? Colors.black : Colors.redAccent),
        icon: isCalendar ? Icon(Icons.calendar_today) : Icon(Icons.timer),
      ),
    );
  }

  void showAlertDialog(BuildContext context,
      {@required bool isOrderTime, var pickUpTime}) async {
    await showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: isOrderTime ? Text('주문시간 설정') : Text('픽업시간 설정'),
          content: TimePickerSpinner(
            is24HourMode: true,
            time: setInitDateTime(isOrderTime, pickUpTime),
            minutesInterval: isOrderTime ? 10 : 30,
            spacing: 50,
            itemHeight: 80.h,
            isForce2Digits: true,
            onTimeChange: (time) {
              print(time);
              String selectTime = DateFormat('kk:mm').format(time);
              print("selectTime" + selectTime);
              if (isOrderTime)
                this.setStateCallback(
                    "?isOrder=true&isCalendar=false&data=$selectTime");
              else
                this.setStateCallback(
                    "?isOrder=false&isCalendar=false&data=$selectTime");
            },
          ),
        );
      },
    );
  }

  setInitDateTime(bool isOrder, var pickUpTime) {
    DateTime _now = DateTime.now();
    return pickUpTime.text == ''
        ? isOrder
            ? _now //set Current Time
            : DateTime.parse(DateTime.now().toString().split(' ')[0] +
                " 12:00:00.000") //set 00
        : DateTime.parse(DateTime.now().toString().split(' ')[0] +
            " " +
            pickUpTime.text +
            ":00.000"); //set previous time
  }
}
