import 'package:cakeorder/StateManagement/DeclareData/cakeData.dart';
import 'package:cakeorder/addOrderPackage/addCategory/Customdropdown/addCake.dart';
import 'package:cakeorder/addOrderPackage/addCategory/cakeCount.dart';
import 'package:flutter/material.dart';

//OrderCake를 List<OrderCake>의 형태로 바꾸어서
//List<orderCake>를 rx처럼 stream으로 읽어들여서
//order를 추가할때 자동적으로 리스트가 생기는 방식으로 코딩을 한다.
//https://www.youtube.com/watch?v=8fOoF7icyn0

class BookingCakeCategory extends StatefulWidget {
  final List<OrderData> orderList;
  final Function countUpdateCallback;
  final bool isClickable;
  BookingCakeCategory(
      {this.orderList, this.countUpdateCallback, this.isClickable});
  @override
  State<BookingCakeCategory> createState() => _BookingCakeCategoryState();
}

class _BookingCakeCategoryState extends State<BookingCakeCategory> {
  Function updateCallback;
  bool isClickable;
  List<OrderData> currentOrder;

  @override
  void initState() {
    currentOrder = this.widget.orderList;
    this.isClickable = widget.isClickable ?? true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          for (OrderData data in currentOrder) ...[
            AddCake(
              clickable: isClickable,
              orderData: data,
            ),
            CakeCountWidget(isClickable)
          ],
          //****구현할 부분 */
          //clickable에 따라서 다르게 구현해야함
          //Text Widget과 dropdownWidget
          //Text Widget과 count부분
          //**** */
        ],
      ),
    );
  }
}
