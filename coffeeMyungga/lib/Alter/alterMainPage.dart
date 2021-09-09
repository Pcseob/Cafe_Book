import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlterPage extends StatefulWidget {
  AlterPage({Key? key}) : super(key: key);

  @override
  _AlterPageState createState() => _AlterPageState();
}

class _AlterPageState extends State<AlterPage> {
  double? deviceWidth;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    deviceWidth = MediaQuery.of(context).size.width;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                width: deviceWidth,
                margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
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
                      margin: EdgeInsets.only(left: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text("Cake Setting",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20.sp,
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5.w),
                            child: Text("케이크 종류, 사이즈 및 가격을 설정합니다.",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.sp,
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
                width: deviceWidth,
                margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Icon(Icons.person, color: Colors.grey),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text("PartTimer Setting",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20.sp,
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5.w),
                            child: Text("아르바이트를 설정합니다.",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.sp,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
          Container(
              width: deviceWidth,
              margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
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
                          size: 18.sp,
                        )
                      ]),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text("Report",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20.sp,
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5.w),
                            child: Text("매출현황을 볼 수 있습니다.",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.sp,
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
                width: deviceWidth,
                margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
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
                      margin: EdgeInsets.only(left: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text("Customer",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20.sp,
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5.w),
                            child: Text("주문한 고객들의 성함 및 전화번호를 보여줍니다.",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.sp,
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
