import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

//Singleton Design
class CurrentOSCheck {
  static get instance => {'IOS': Platform.isIOS, 'Android': Platform.isAndroid};
}
