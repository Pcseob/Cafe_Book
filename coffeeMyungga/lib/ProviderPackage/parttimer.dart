import 'package:cloud_firestore/cloud_firestore.dart';

class PartTimer {
  final String name;
  PartTimer({this.name});

  factory PartTimer.fromMap(Map map) {
    return PartTimer(name: map['']);
  }
}
