import 'package:flutter/material.dart';
import 'pickUpOrder.dart';
import 'package:cakeorder/ProviderPackage/cakeDataClass.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool refresh = true;
  TabController _tabController;
  // CalendarPickUp _calendarPickUp;
  // CalendarOrder _calendarOrder;
  // final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _calendarPickUp = CalendarPickUp();
    // _calendarOrder = CalendarOrder();
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("setState");
    return SafeArea(
      child: Scaffold(
          key: scaffoldKey,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: AppBar(
              title: Center(child: Text("Calendar.")),
              bottom: TabBar(
                controller: _tabController,
                indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 5.0),
                    insets: EdgeInsets.symmetric(horizontal: 16.0)),
                onTap: (index) {},
                tabs: [
                  Tab(
                    icon: Icon(Icons.shopping_bag_outlined),
                    text: "PickUp",
                  ),
                  Tab(
                    icon: Icon(Icons.book),
                    text: "Order",
                  )
                ],
              ),

              // bottom:
            ),
          ),
          body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [CalendarPickUp(), CalendarOrder()])),
    );
  }
}
