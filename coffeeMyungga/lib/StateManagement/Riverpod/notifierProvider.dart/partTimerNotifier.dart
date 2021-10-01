import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class PartTimer {
  final name;
  final position;
  PartTimer({this.name, this.position});
}

class PartTimerProvider with ChangeNotifier {
  final _partTimerList = <PartTimer>[];
  final _dropDownList = [];
  bool _isFetch = false;
  get isFetching => _isFetch;
  get getData => _partTimerList;
  get dropDownData => _dropDownList;
  fetchPartTimerData() async {
    if (_isFetch) return;
    _isFetch = true;
    _partTimerList.clear();
    _dropDownList.clear();
    try {
      //Realtime Database에 있는 partTimer에서 Key-Value형식의 데이터를 가지고 옴.
      DataSnapshot dataSnapshot =
          await FirebaseDatabase.instance.reference().child("partTimer").once();
      //Iterable에서 Map으로 변경한다.
      Map<String, dynamic> partTimerMap =
          Map<String, dynamic>.from(dataSnapshot.value);
      //PartTimer의 position(key)와 name(value)를 저장한다.
      partTimerMap.forEach((partTimerPosition, partTimerName) {
        print("$partTimerPosition");
        _partTimerList.add(
            new PartTimer(position: partTimerPosition, name: partTimerName));
        _dropDownList.add("$partTimerPosition : $partTimerName");
      });

      notifyListeners();
    } catch (error) {
      print("ERROR fetchPartTimerData in PartTimerProvider.dart : $error");
    } finally {
      _isFetch = false;
    }
  }
}
