import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../ProviderPackage/cakeDataClass.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CalendarPickUp extends StatefulWidget {
  @override
  _CalendarPickUpState createState() => _CalendarPickUpState();
}

class _CalendarPickUpState extends _CalendarParent<CalendarPickUp> {
  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }

  // calendarRefreshButton(bool refresh) {
  //   if (refresh) {
  //     setState(() {
  //       selectedEvents = [];
  //       _events = {};
  //       // setCalendarCakeData();
  //     });
  //   }
  // }

  @override
  bool get isPickUpCalendar => true;
  @override
  setCalendarCakeData() =>
      Provider.of<List<CakeDataCalendarPickUp>>(context, listen: true);

  @override
  bool get wantKeepAlive => true;
}

class CalendarOrder extends StatefulWidget {
  @override
  _CalendarOrderState createState() => _CalendarOrderState();
}

class _CalendarOrderState extends _CalendarParent<CalendarOrder> {
  @override
  bool get isPickUpCalendar => false;
  @override
  setCalendarCakeData() =>
      Provider.of<List<CakeDataCalendarOrder>>(context, listen: true);

  @override
  bool get wantKeepAlive => true;
}

abstract class _CalendarParent<T extends StatefulWidget> extends State<T>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey _refresherKey = GlobalKey();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<CakeData> thisMonthCakeDataList;
  Map<DateTime, List> _events;
  List<dynamic> selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  bool payStatus;
  bool isPickUpCalendar;

  @override
  void initState() {
    super.initState();

    // initEventData();
    final _selectedDay = DateTime.now();
    _events = {};

    selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  Future initEventData() async {
    var a;
    if (thisMonthCakeDataList != null) {
      thisMonthCakeDataList.forEach((element) {
        var convertDate =
            isPickUpCalendar ? element.pickUpDate : element.orderDate;
        if (convertDate.runtimeType == Timestamp)
          convertDate = convertDate.toDate();
        DateTime _date = convertDate;
        DateTime _day = DateTime(_date.year, _date.month, _date.day);

        if (a == _day) {
          _events.update(_day, (value) {
            List<dynamic> _temp = [];
            _temp.addAll(value);
            _temp.add(element);
            return _temp;
          });
        } else {
          _events.addAll({
            _day: [element]
          });
        }
        a = _day;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {}

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     key: scaffoldKey,
  //     body: builder(),
  //     resizeToAvoidBottomPadding: false,
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SmartRefresher(
      key: _refresherKey,
      controller: _refreshController,
      enablePullUp: false,
      enablePullDown: true,
      child: builder(),
      header: ClassicHeader(),
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 500));
        if (mounted)
          setState(() {
            selectedEvents = [];
            _events = {};
          });
        _refreshController.refreshCompleted();
      },
    );
  }

  setCalendarCakeData();

  builder() {
    thisMonthCakeDataList = setCalendarCakeData() ?? [];
    initEventData();
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        _buildTableCalendar(),
        const SizedBox(height: 8.0),
        Flexible(
          child: _buildEventList(),
        ),
      ],
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return _events != null
        ? TableCalendar(
            calendarController: _calendarController,
            events: _events,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              selectedColor: Colors.deepOrange[400],
              todayColor: Colors.deepOrange[200],
              markersColor: Colors.brown[700],
              outsideDaysVisible: false,
            ),
            headerStyle: HeaderStyle(
              formatButtonTextStyle:
                  TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
              formatButtonDecoration: BoxDecoration(
                color: Colors.deepOrange[400],
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            onDaySelected: _onDaySelected,
            onVisibleDaysChanged: _onVisibleDaysChanged,
            onCalendarCreated: _onCalendarCreated,
          )
        : Center(
            child: CupertinoActivityIndicator(),
          );
  }

  Widget _buildEventList() {
    return _events != null
        ? ListView(
            children: selectedEvents.map((event) {
              var _date = isPickUpCalendar
                  ? event.pickUpDate.toString().split('')
                  : event.orderDate.toString().split('');
              _date.removeRange(_date.length - 7, _date.length);
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                    leading: Icon(Icons.cake),
                    title: Text(event.cakeCategory +
                        event.cakeSize +
                        " X" +
                        event.cakeCount.toString() +
                        "개 "),
                    subtitle: Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_date.join()),
                          Text(
                            event.customerName,
                            style: TextStyle(fontSize: 13),
                          )
                        ],
                      ),
                    ),
                    trailing: Container(
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                          margin: EdgeInsets.only(left: 5, right: 5),
                          child: Icon(
                            Icons.payment,
                            color: event.payStatus != null
                                ? event.payStatus
                                    ? Colors.red
                                    : Colors.grey
                                : (event.payInCash || event.payInStore)
                                    ? Colors.red
                                    : Colors.grey,
                            // color: event.payStatus ? Colors.red : Colors.grey,
                          )),
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          color: event.pickUpStatus ? Colors.red : Colors.grey,
                        ),
                      ),
                    ])),
                    onTap: () async {
                      await Navigator.pushNamed(context, '/DetailPage',
                          arguments: {
                            "DATA": event,
                          }).then((value) {});
                    }),

                // ),
              );
            }).toList(),
          )
        : Container();
  }
}
