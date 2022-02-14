import 'package:cakeorder/StateManagement/DeclareData/cakeData.dart';
import 'package:cakeorder/addOrderPackage/addCategory/Customdropdown/addCake.dart';
import 'package:cakeorder/addOrderPackage/addCategory/cakeCount.dart';
import 'package:flutter/material.dart';

class BookingCakeCategory extends StatefulWidget {
  final OrderData orderCake;
  final Function countUpdateCallback;
  final bool isClickable;
  BookingCakeCategory(
      {this.orderCake, this.countUpdateCallback, this.isClickable});
  @override
  State<BookingCakeCategory> createState() => _BookingCakeCategoryState();
}

class _BookingCakeCategoryState extends State<BookingCakeCategory> {
  Function updateCallback;
  bool isClickable;

  @override
  void initState() {
    this.isClickable = widget.isClickable;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          //****구현할 부분 */
          //clickable에 따라서 다르게 구현해야함
          //Text Widget과 dropdownWidget
          //Text Widget과 count부분
          //**** */
          AddCake(clickable: isClickable, bookName: this.widget.bookName ?? ""),
          CakeCountWidget(
            isClickable,
          )
        ],
      ),
    );
  }
}
