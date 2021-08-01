import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:date_util/date_util.dart';
import 'package:async/async.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReportPage extends StatefulWidget {
  ReportPage({Key key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  AsyncMemoizer _memoizer;
  bool isMemoizerRefresh;
  bool showAvg = false;
  bool isShowingMainData;
  double bestEarning;
  double totalEarning;
  String totalEarningIncludeDot;

  double deviceWidth;
  double deviceHeight;

  DateTime today;
  DateTime monthStart;
  DateTime monthEnd;
  DateTime selectedDate;
  @override
  void initState() {
    super.initState();
    bestEarning = 0;
    totalEarning = 0;
    _memoizer = AsyncMemoizer();
    isMemoizerRefresh = true;
    selectedDate = DateTime.now();
    monthStart = new DateTime(selectedDate.year, selectedDate.month);
    monthEnd =
        new DateTime(selectedDate.year, selectedDate.month + 1, 0, 23, 59, 59);
    isShowingMainData = false;
  }

  @override
  void didChangeDependencies() {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report"),
      ),
      body: SlidingUpPanel(
          onPanelClosed: () {},
          maxHeight: deviceHeight / 3,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
          minHeight: deviceHeight / 12,
          panel: Column(
            children: [
              Center(
                  child: Container(
                      margin: EdgeInsets.only(top: 5.h),
                      height: deviceHeight / 130,
                      width: deviceWidth / 10,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all(Radius.circular(5))))),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                height: deviceHeight / 15,
                width: deviceWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      // margin: EdgeInsets.only(top: deviceHeight / 100),
                      child: Text(
                        "YEAR : " + selectedDate.year.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: deviceWidth / 10,
                      ),
                      child: Text(
                        "MONTH : " + selectedDate.month.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              _calendarYearButton(),
              _calendarMonthButton()
            ],
          ),
          body: Column(
            children: [
              Container(child: setFuturebuilder()),
            ],
          )),
    );
  }

  LineChartData settingChartData(List<FlSpot> spotList) {
    return LineChartData(
        lineTouchData: LineTouchData(
          enabled: true,
        ),
        gridData: FlGridData(
          show: false,
        ),
        titlesData: FlTitlesData(
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            getTextStyles: (value) => TextStyle(
              color: Color(0xff72719b),
              // fontWeight: FontWeight.bold,
              fontSize: 7.sp,
            ),
            margin: 10,
            getTitles: (value) {
              return '${value.toInt() + 1}';
            },
          ),
          leftTitles: SideTitles(
            interval: bestEarning / 4,
            showTitles: true,
            getTextStyles: (value) => TextStyle(
              color: Color(0xff75729e),
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
            getTitles: (value) {
              return "${value.toDouble().toString().split('.')[0]}";
            },
            margin: 8,
            reservedSize: 30,
          ),
        ),
        borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 4.w,
              ),
              left: BorderSide(
                color: Colors.transparent,
              ),
              right: BorderSide(
                color: Colors.transparent,
              ),
              top: BorderSide(
                color: Colors.transparent,
              ),
            )),
        minX: 0,
        maxX:
            //  spotList.length.toDouble(),
            DateUtil()
                    .daysInMonth(selectedDate.month, selectedDate.year)
                    .toDouble() -
                1,
        maxY: bestEarning,
        minY: 0,
        lineBarsData: [
          LineChartBarData(
            spots: spotList,
            isCurved: true,
            curveSmoothness: 0,
            colors: const [
              Colors.redAccent,
            ],
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
              // getDotPainter: (spot, percent, bar, index, {size}) {
              //   return FlDotCirclePainter(
              //     radius: size,
              //   );
              // },
              show: true,
            ),
            belowBarData: BarAreaData(
              show: false,
            ),
          ),
        ]);
  }

  setFlSpotList(QuerySnapshot snapshot) {
    totalEarningIncludeDot = '';
    bestEarning = 0;
    totalEarning = 0;
    List<FlSpot> result = [];
    List<double> totalMoneybyDays = List<double>.generate(
        DateUtil().daysInMonth(selectedDate.month, selectedDate.year),
        (index) => 0);

    snapshot.docs.forEach((element) {
      double income = element["cakePrice"] * element["cakeCount"] / 1000;
      int day = element["orderDate"].toDate().day;
      totalMoneybyDays[day - 1] = totalMoneybyDays[day - 1] + income;
    });

    totalMoneybyDays.asMap().forEach((index, element) {
      totalEarning += element;
      if (bestEarning < element) bestEarning = element;
      result.add(new FlSpot(index.toDouble(), element));
    });
    //Set Total Text include Dot
    totalEarningIncludeDot = (totalEarning * 1000).toString().split('.')[0];
    int numberLength = totalEarningIncludeDot.split('').length;
    int dotCount = (numberLength - 1) ~/ 3;

    int firstDotLocation = ((numberLength - 1) % 3) + 1;
    for (int i = 0; i < dotCount; i++) {
      List<String> totalEarningIncludeDotList =
          totalEarningIncludeDot.split('');
      totalEarningIncludeDotList.insert(firstDotLocation + i * 4, ',');
      totalEarningIncludeDot = totalEarningIncludeDotList.join();
    }
    return result;
  }

  _calendarYearButton() {
    return Container(
      height: deviceHeight / 15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: deviceWidth / 8,
            child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 15,
                ),
                onPressed: () {
                  setState(() {
                    isMemoizerRefresh = true;

                    selectedDate =
                        DateTime(selectedDate.year - 1, selectedDate.month, 1);
                    monthStart =
                        new DateTime(selectedDate.year, selectedDate.month);
                    monthEnd = new DateTime(selectedDate.year,
                        selectedDate.month + 1, 0, 23, 59, 59);
                  });
                }),
          ),
          Text(
            selectedDate.year.toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          selectedDate.year != DateTime.now().year
              ? Container(
                  width: deviceWidth / 8,
                  child: IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 15.sp,
                      ),
                      onPressed: () {
                        setState(() {
                          isMemoizerRefresh = true;

                          selectedDate = DateTime(
                              selectedDate.year + 1, selectedDate.month, 1);
                          monthStart = new DateTime(
                              selectedDate.year, selectedDate.month);
                          monthEnd = new DateTime(selectedDate.year,
                              selectedDate.month + 1, 0, 23, 59, 59);
                        });
                      }),
                )
              : Container(
                  width: deviceWidth / 8,
                )
        ],
      ),
    );
  }

  _calendarMonthButton() {
    List calendarList = [
      "Jan",
      "Fab",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    List<Widget> columnWidgetList = [];
    for (int i = 0; i < 2; i++) {
      List<Widget> rowWidgetList = [];
      for (int j = 0; j < 6; j++) {
        int currentMonth = (i * 6) + j + 1;
        rowWidgetList.add(Container(
          padding: EdgeInsets.all(5),
          height: deviceHeight / 12,
          width: deviceWidth / 6,
          child: Container(
            decoration: BoxDecoration(
              color: currentMonth != selectedDate.month.toInt()
                  ? Colors.grey[300]
                  : Colors.orangeAccent,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[500],
                  offset: Offset(4.0, 4.0),
                  blurRadius: 15.0,
                  spreadRadius: 1.0,
                ),
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4.0, -4.0),
                  blurRadius: 15.0,
                  spreadRadius: 1.0,
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isMemoizerRefresh = true;
                  selectedDate = DateTime(selectedDate.year, currentMonth, 1);
                  monthStart =
                      new DateTime(selectedDate.year, selectedDate.month);
                  monthEnd = new DateTime(
                      selectedDate.year, selectedDate.month + 1, 0, 23, 59, 59);
                });
              },
              child: Center(
                child: Text(
                  calendarList[(i * 6) + j],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ));
      }
      columnWidgetList.add(Row(
        children: rowWidgetList,
      ));
    }
    return Column(children: columnWidgetList);
  }

  Widget setFuturebuilder() {
    return FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(
                child: CupertinoActivityIndicator(),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    children: [
                      Text("데이터 불러오기에 실패하였습니다."),
                      Text("${snapshot.hasError}")
                    ],
                  ),
                );
              } else {
                if (snapshot.data.size != 0) {
                  return Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 1.23,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.yellow[200],
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                          ),
                          child: Stack(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: deviceHeight / 100),
                                    child: Text(
                                      '커피명가 ${selectedDate.year.toString()}년 ${selectedDate.month.toString()}월',
                                      style: TextStyle(
                                        color: Color(0xff827daa),
                                        fontSize: 16.sp,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Text(
                                    'Daily Sales',
                                    style: TextStyle(
                                        color: Colors.orange[300],
                                        fontSize: 30.sp,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          right: 16.w, left: 6.w),
                                      child: LineChart(
                                        settingChartData(
                                            setFlSpotList(snapshot.data)),
                                      ),
                                    ),
                                    // ),
                                  ),
                                  Container(
                                      margin:
                                          EdgeInsets.only(left: 5.w, top: 10.h),
                                      child: Text(
                                        "단위 : 1000원",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.redAccent),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5.h),
                        child: Center(
                          child: Text(
                            // "TOTAL : ${(totalEarning * 1000).toString().split('.')[0]}원",
                            "TOTAL : $totalEarningIncludeDot원",
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  TextStyle textStyle = TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.redAccent);
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${selectedDate.year}년 ${selectedDate.month}월",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        "등록된 매출액이 없습니다!",
                        style: textStyle,
                      ),
                    ],
                  ));
                }
              }
          }
        });
  }

  Future fetchData() {
    final _db = FirebaseFirestore.instance;
    if (isMemoizerRefresh) {
      _memoizer = AsyncMemoizer();
      isMemoizerRefresh = false;
    }
    return this._memoizer.runOnce(() async {
      return await _db
          .collection("Cake")
          .where("orderDate", isGreaterThanOrEqualTo: monthStart)
          .where("orderDate", isLessThanOrEqualTo: monthEnd)
          .get();
    });
  }
}
