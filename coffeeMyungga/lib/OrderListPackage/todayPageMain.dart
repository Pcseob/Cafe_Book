import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TodayList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.h),
          child: AppBar(
            title: Center(child: Text("Today.")),
            bottom: TabBar(
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 5.0.w),
                  insets: EdgeInsets.symmetric(horizontal: 16.0.w)),
              onTap: (index) {},
              tabs: [
                Tab(
                  icon: Icon(Icons.book),
                  text: "Order",
                ),
                Tab(
                  icon: Icon(Icons.shopping_bag_outlined),
                  text: "PickUp",
                )
              ],
            ),

            // bottom:
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/AddOrder');
          },
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: Icon(Icons.cake),
          // label: Text("추가"),
        ),
        body: TabBarView(children: [
          Text("hi"),
          Text("hi")
          OrderPage(),
          // OrderPage(),
          // PickUpPage()
        ]),
      ),
    );
  }
}
