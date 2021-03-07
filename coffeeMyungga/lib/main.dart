import 'bugReportPage.dart';
import 'package:cakeorder/Alter/passwordPage.dart';
import 'package:cakeorder/ProviderPackage/cakeDataClass.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'OrderListPackage/todayPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ProviderPackage/myprovider.dart';
import 'customBottomNavi.dart';
import 'checkingOS.dart';
import 'cakeOrderRoute.dart';
import 'Calendar/calendarPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().timeout(Duration(seconds: 3));

  runApp(CakeOrderApp());
}

class CakeOrderApp extends StatefulWidget {
  @override
  _CakeOrderAppState createState() => _CakeOrderAppState();
}

class _CakeOrderAppState extends State<CakeOrderApp> {
  SetProvider db = SetProvider(); //get provider
  @override
  var _os = CurrentOSCheck.instance;
  int _selectedIndex = 0;
  bool isSavePassword;
  passwordCallback(bool wasLogin) {
    isSavePassword = wasLogin ?? false;
  }

  List<Widget> _widgetOptions;
  @override
  void initState() {
    super.initState();
    isSavePassword = false;
  }

  // List<CakeData> temp = Provider.of(context)
  TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    // _widgetOptions = <Widget>[
    //   TodayList(),
    //   CalendarPage(),
    //   AlterPage(),
    //   // PasswordPage(
    //   //     setPasswordCallback: passwordCallback,
    //   //     correctPassword: isSavePassword)
    // ];
    _widgetOptions = <Widget>[
      TodayList(),
      CalendarPage(),
      BugReportPage(),
      PasswordPage(
          setPasswordCallback: passwordCallback,
          correctPassword: isSavePassword)
    ];
    return MultiProvider(
        providers: [
          StreamProvider<List<CakeData>>.value(
            value: db.getCakeData(),
            catchError: (context, error) {
              print(error);
              return null;
            },
          ),
          StreamProvider<List<CakeDataOrder>>.value(
            value: db.getTodayOrderCakeData(),
            catchError: (context, error) {
              print(error);
              return null;
            },
          ),
          StreamProvider<List<CakeDataPickUp>>.value(
            value: db.getTodayPickCupCakeData(),
            catchError: (context, error) {
              print(error);
              return null;
            },
          ),
          StreamProvider<List<dynamic>>.value(
            value: db.getPartTimer(),
            catchError: (context, error) => null,
          ),
          StreamProvider<List<CakeCategory>>.value(
            value: db.getCakeCategory(),
            catchError: (context, error) {
              print(error);
              return null;
            },
          ),
          StreamProvider<List<CakeDataCalendarOrder>>.value(
            value: db.getCalendarOrderCakeData(),
            catchError: (context, error) {
              print(error);
              return null;
            },
          ),
          StreamProvider<List<CakeDataCalendarPickUp>>.value(
            value: db.getCalendarPickUpCakeData(),
            catchError: (context, error) {
              print(error);
              return null;
            },
          ),
          ChangeNotifierProvider<CustomerProvider>.value(
              value: new CustomerProvider()),
        ],
        child: _os['Android']
            ? MaterialApp(
                home: SafeArea(
                    child: Scaffold(
                        body: Center(
                          child: _widgetOptions.elementAt(_selectedIndex),
                        ),
                        bottomNavigationBar: CustomBottomNavi()
                            .bottomNavigationContainer(
                                selectedIndex: _selectedIndex,
                                setStateCallback: changeNaviIndex))),
                theme: ThemeData(primaryColor: Colors.white),
                initialRoute: '/',
                onGenerateRoute: CakeOrderRouteGenerator.generateRoute,
              )
            : CupertinoApp());
  }

  void changeNaviIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
