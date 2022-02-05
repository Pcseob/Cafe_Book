import 'package:cakeorder/addOrderPackage/orderAbstract.dart';
import 'package:flutter/material.dart';

class ViewOrder extends StatefulWidget {
  ViewOrder({Key key}) : super(key: key);

  @override
  _ViewOrderState createState() => _ViewOrderState();
}

class _ViewOrderState extends State<ViewOrder> with OrderPage {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  setClickable() {
    isClickable = false;
    context = context;
  }

  @override
  setData() {
    // TODO: implement setData
    throw UnimplementedError();
  }
}
