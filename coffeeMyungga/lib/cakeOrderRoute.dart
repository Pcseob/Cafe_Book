import 'package:cakeorder/Alter/alterMainPage.dart';
import 'package:cakeorder/Alter/customPhone.dart';
import 'package:cakeorder/Alter/passwordPage.dart';
import 'package:cakeorder/Alter/reportPage.dart';
import 'package:cakeorder/Alter/settingPartTimer.dart';
import 'package:cakeorder/Alter/alterCake.dart';
import 'package:cakeorder/ProviderPackage/myprovider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'addOrderPackage/addOrder.dart';
import 'checkingOS.dart';
import 'main.dart';

import 'package:path/path.dart' as p;
import 'OrderListPackage/alterDetailPage.dart';

class CakeOrderRouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    assert(settings.name.indexOf("/") == 0,
        "[ROUTER] routing MUST Begin with '/'");

    var _reDefine = settings.name.replaceFirst("/", "");
    var _pathParams = p.split(
        _reDefine.split("?").length > 1 ? _reDefine.split("?")[0] : _reDefine);

    //QueryParameters example
    // print(Uri.base.toString()); // http://localhost:8082/game.html?id=15&randomNumber=3.14
    // print(Uri.base.query);  // id=15&randomNumber=3.14
    // print(Uri.base.queryParameters['randomNumber']); // 3.14

    Map<String, dynamic> arguments = settings.arguments ??
        Uri.parse(settings.name.replaceFirst("/", "")).queryParameters ??
        {};
    var _pageName = _pathParams.isNotEmpty ? _pathParams.first : null;
    Widget _pageWidget;

    switch (_pageName) {
      case 'home':
        _pageWidget = CakeOrderApp();
        break;
      case 'AddOrder':
        _pageWidget = AddOrder();
        break;
      case 'DetailPage':
        _pageWidget = DetailPage(
          cakeData: arguments["DATA"],
        );
        break;
      case 'OrderAlterPage':
        _pageWidget = OrderAlterPage(
          cakeData: arguments["DATA"],
        );
        break;
      case 'AlterPage':
        _pageWidget = AlterPage();
        break;
      case 'SettingPartTimer':
        _pageWidget = SettingPartTimer();
        break;
      case 'ReportPage':
        _pageWidget = ReportPage();
        break;
      case 'CakeSetting':
        _pageWidget = CakeSetting();
        break;
      case 'CustomerList':
        _pageWidget =
            Consumer<CustomerProvider>(builder: (context, customerProvider, _) {
          return CustomerPhone(
            customerProvider: customerProvider,
          );
        });
        break;
      case 'PasswordPage':
        _pageWidget = PasswordPage();
        break;
    }
    return CurrentOSCheck.instance['Android']
        ? MaterialPageRoute(
            settings: RouteSettings(name: settings.name),
            builder: (context) => _pageWidget)
        : CupertinoPageRoute(
            settings: RouteSettings(name: settings.name),
            builder: (context) => _pageWidget,
          );
  }
}
