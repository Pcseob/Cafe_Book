import 'package:cakeorder/StateManagement/DeclareData/cakePriceData.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class CakePriceProvider with ChangeNotifier {
  final _cakePriceDataList = <CakePriceData>[];
  bool _isFetch = false;
  get isFetching => _isFetch;
  get cakePriceList => _cakePriceDataList;

  fetchCakePriceData() async {
    if (_isFetch) return;
    _isFetch = true;
    _cakePriceDataList.clear();
    try {
      //Realtime Database에 있는 cakePrice에서 Key-Value형식의 데이터를 가지고 옴.
      DataSnapshot dataSnapshot =
          await FirebaseDatabase.instance.reference().child("cakePrice").once();
      //Iterable에서 Map으로 변경한다.
      Map<String, dynamic> cakePriceMap =
          Map<String, dynamic>.from(dataSnapshot.value);
      //Cake이름을 기준으로 사이즈-가격(Key-Value)형식으로 데이터를 저장한다.
      cakePriceMap.forEach((cakeName, value) {
        _cakePriceDataList.add(new CakePriceData(
            cakeName: cakeName, cakeSizePrice: Map<String, int>.from(value)));
      });
      notifyListeners();
    } catch (error) {
      print("ERROR fetchCakePriceData in CakePrice.dart : $error");
    } finally {
      //모든 작업이 끝나면 fetch status를 false로 바꿔준다.
      _isFetch = false;
    }
  }
}
