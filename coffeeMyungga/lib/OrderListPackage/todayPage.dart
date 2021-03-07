import 'package:flutter/material.dart';
import 'package:cakeorder/ProviderPackage/cakeDataClass.dart';
import 'package:provider/provider.dart';
import 'todayList.dart';

class TodayList extends StatefulWidget {
  @override
  _TodayListState createState() => _TodayListState();
}

class _TodayListState extends State<TodayList>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<CakeData> temp;

  // final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // key: scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBar(
            title: Center(child: Text("Today.")),
            bottom: TabBar(
              controller: _tabController,
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 5.0),
                  insets: EdgeInsets.symmetric(horizontal: 16.0)),
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
        body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              OrderPage(),
              // OrderPage(),
              PickUpPage()
            ]),
      ),
    );
  }

  _test() {
    Navigator.of(context).pushNamed('/temp');
  }
}
