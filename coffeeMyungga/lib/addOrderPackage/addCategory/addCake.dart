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
  TextEditingController bookName;
  TextEditingController bookCount;
  Function updateCallback;
  bool isClickable;

  initialBook({OrderData orderData}) {
    bookName = TextEditingController(text: orderData.bookCategory);
    bookCount = TextEditingController(text: orderData.count);
  }

  @override
  void initState() {
    initialBook(name: this.widget.bookName, count: this.bookCount);
    this.isClickable = widget.isClickable;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          AddCake(clickable: isClickable, bookName: this.widget.bookName ?? ""),
          CakeCountWidget(
            isClickable,
          )
        ],
      ),
    );
  }
}
