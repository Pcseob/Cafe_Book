import 'package:flutter/material.dart';

class AlterPage extends StatefulWidget {
  AlterPage({Key key}) : super(key: key);

  @override
  _AlterPageState createState() => _AlterPageState();
}

class _AlterPageState extends State<AlterPage> {
  var device_width;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    device_width = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Center(child: Text("Setting.")),
        ),
        body: _selectionButtonMethod());
  }

  _selectionButtonMethod() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/CakeSetting");
            },
            child: Container(
                width: device_width,
                margin:
                    EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Icon(
                        Icons.cake,
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text("Cake Setting",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text("케이크 종류, 사이즈 및 가격을 설정합니다.",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/SettingPartTimer');
            },
            child: Container(
                width: device_width,
                margin:
                    EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Icon(Icons.person, color: Colors.grey),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text("PartTimer Setting",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text("아르바이트를 설정합니다.",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
          Container(
              width: device_width,
              margin: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pushNamed('/ReportPage'),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Stack(alignment: Alignment.center, children: [
                        Icon(Icons.calendar_today, color: Colors.grey),
                        Icon(
                          Icons.money,
                          color: Colors.grey,
                          size: 18,
                        )
                      ]),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text("Report",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text("매출현황을 볼 수 있습니다.",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/CustomerList");
            },
            child: Container(
                width: device_width,
                margin:
                    EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text("Customer",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text("주문한 고객들의 성함 및 전화번호를 보여줍니다.",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
