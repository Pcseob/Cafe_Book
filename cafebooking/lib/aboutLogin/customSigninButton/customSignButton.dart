import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'dart:io' show Platform;

//커스텀 구글 로그인 버튼
class CustomSignButton {
  var logger = Logger();

  Future<void> googleSignIn() async {
    try {} catch (e) {
      logger.e("Google SignIn Error");
    }
  }

  Future<void> appleSignIn() async {
    try {} catch (e) {
      logger.e("Apple SignIn Error");
    }
  }

  Future<void> kakaoSignIn() async {
    try {} catch (e) {
      logger.e("KaKao SignIn Error");
    }
  }
}
