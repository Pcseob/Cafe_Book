import 'package:firebase_database/firebase_database.dart';

class PartTimer {
  final String name;
  PartTimer({this.name});

  factory PartTimer.fromFirebaseDatabase(DataSnapshot dataSnapshot) {
    Map<dynamic, dynamic> value = dataSnapshot.value ?? {};
    return PartTimer(name: value["name"]);
  }
}
