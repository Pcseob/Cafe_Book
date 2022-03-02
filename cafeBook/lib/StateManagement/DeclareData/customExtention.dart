import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//DateTime을 TimeStamp로 바꾸는 extension
extension dateTimeToTimeStamp on DateTime {
  get toTimeStamp => Timestamp.fromDate(this);
}

//TimeStamp를 DateTime로 바꾸는 extension
//TimeStamp를 Extension해야하지만, Firestore에서 timestamp를 저장하는 DataType은 Int이므로
//Int를 extension한다.
extension timestampToDateTime on int {
  get toDateTimeMilli => DateTime.fromMillisecondsSinceEpoch(this);
  get toDateTimeMicro => DateTime.fromMicrosecondsSinceEpoch(this);
}
