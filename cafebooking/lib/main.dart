import 'package:cafebooking/StateManagement/Riverpod/defineProvider.dart';
import 'package:cafebooking/aboutLogin/loginMain.dart';
import 'package:cafebooking/routeGenerator.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Alter/setCakePrice/cakeSetMain.dart';
import 'OrderListPackage/todayPageMain.dart';

//google로그인을 위함
final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

void main() async {
  //For kakao oauth
  KakaoContext.clientId = "a02190e545741ae61daa0d059ddb9529";
  KakaoContext.javascriptClientId = "fdf1cf30bcfccd9841e73559d6c33c93";

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().timeout(Duration(seconds: 3));
  //회전 금지.
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(ProviderScope(child: CakeOrderApp()));
}

class CakeOrderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        builder: () => MaterialApp(
              initialRoute: '/',
              onGenerateRoute: RouteGenerator.generateRoute,
              home: SafeArea(
                child: CheckLoginPage(),
              ),
            ));
  }
}

class CheckLoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //로그인 시도.
    final checkLog = ref.watch(loginProvider);
    bool checkLogin = checkLog;

    //로그인이 되어있다면 바로 Main으로 넘어가고, 아니면 LoginPage로 변경된다.
    return checkLogin ? MainBody() : LoginPage();
  }
}

class MainBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(), //스와이프 작동하지 않게 함.
          children: [TodayList(), Text('채팅 스크린'), CakeSetting()],
        ),
        bottomNavigationBar: TabBar(tabs: [
          Tab(
            icon: Icon(Icons.home),
            text: 'home',
          ),
          Tab(
            icon: Icon(Icons.chat),
            text: 'chat',
          ),
          Tab(
            icon: Icon(Icons.people),
            text: 'my',
          )
        ]),
      ),
    );
  }
}

// class CakeOrderApp extends StatefulWidget {
//   @override
//   _CakeOrderAppState createState() => _CakeOrderAppState();
// }

// class _CakeOrderAppState extends State<CakeOrderApp> {
//   var _os = CurrentOSCheck.instance;
  
  
//   }

//   List<Widget> _widgetOptions;
//   @override
//   void initState() {
//     super.initState();
//     isSavePassword = false;
//   }

//   // List<CakeData> temp = Provider.of(context)
//   TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

//   @override
//   Widget build(BuildContext context) {
//     _widgetOptions = <Widget>[
//       TodayList(),
//       CalendarPage(),
//       BugReportPage(),
//       PasswordPage(
//           setPasswordCallback: passwordCallback,
//           correctPassword: isSavePassword)
//     ];
//     return MultiProvider(
//         providers: [
//           StreamProvider<List<CakeData>>.value(
//             value: db.getCakeData(),
//             catchError: (context, error) {
//               print(error);
//               return null;
//             },
//           ),
//           StreamProvider<List<CakeDataOrder>>.value(
//             value: db.getTodayOrderCakeData(),
//             catchError: (context, error) {
//               print(error);
//               return null;
//             },
//           ),
//           StreamProvider<List<CakeDataPickUp>>.value(
//             value: db.getTodayPickCupCakeData(),
//             catchError: (context, error) {
//               print(error);
//               return null;
//             },
//           ),
//           StreamProvider<List<dynamic>>.value(
//             value: db.getPartTimer(),
//             catchError: (context, error) => null,
//           ),
//           StreamProvider<List<CakeCategory>>.value(
//             value: db.getCakeCategory(),
//             catchError: (context, error) {
//               print(error);
//               return null;
//             },
//           ),
//           StreamProvider<List<CakeDataCalendarOrder>>.value(
//             value: db.getCalendarOrderCakeData(),
//             catchError: (context, error) {
//               print(error);
//               return null;
//             },
//           ),
//           StreamProvider<List<CakeDataCalendarPickUp>>.value(
//             value: db.getCalendarPickUpCakeData(),
//             catchError: (context, error) {
//               print(error);
//               return null;
//             },
//           ),
//           ChangeNotifierProvider<CustomerProvider>.value(
//               value: new CustomerProvider()),
//         ],
//         child: _os['Android']
//             ? ScreenUtilInit(
//                 builder: () => MaterialApp(
//                   home: SafeArea(
//                       child: Scaffold(
//                           body: Center(
//                             child: _widgetOptions.elementAt(_selectedIndex),
//                           ),
//                           bottomNavigationBar: CustomBottomNavi()
//                               .bottomNavigationContainer(
//                                   selectedIndex: _selectedIndex,
//                                   setStateCallback: changeNaviIndex))),
//                   theme: ThemeData(primaryColor: Colors.white),
//                   initialRoute: '/',
//                   onGenerateRoute: CakeOrderRouteGenerator.generateRoute,
//                 ),
//               )
//             : CupertinoApp());
//   }

//   void changeNaviIndex(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
// }
