import 'package:cafebooking/addOrderPackage/addOrderT.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

class RouteGenerator {
  static bool _isIOS =
      foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
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
    //example:
    //case에는 /를 제외하고 원하는 이름으로 설정, pushNamed할 때는 /를 포함하여 자신이 설정한 이름으로 불러옴.
    switch (_pageName) {
      case 'AddOrder':
        _pageWidget = AddOrder();
        break;
    }
    // return PageTransition(
    //     child: _pageWidget,
    //     type: PageTransitionType.fade,
    // settings: RouteSettings(name: settings.name.toString()));
    return _isIOS
        ? CupertinoPageRoute(
            builder: (context) => _pageWidget,
            settings: RouteSettings(name: settings.name.toString()))
        : MaterialPageRoute(
            builder: (context) => _pageWidget,
            settings: RouteSettings(name: settings.name.toString()));
  }
}
