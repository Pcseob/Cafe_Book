import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'cakeDataClass.dart';

class SetProvider {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<dynamic>> getPartTimer() {
    return _db
        .collection("PartTimer")
        .doc("partTimerDoc")
        .snapshots()
        .map((list) => list.data()["PartTimerList"]);
  }

  Stream<List<CakeCategory>> getCakeCategory() {
    return _db.collection("CakeList").snapshots().map((list) =>
        list.docs.map((doc) => CakeCategory.fromFireStore(doc)).toList());
  }

  Stream<List<CakeData>> getCakeData() {
    return _db.collection("Cake").snapshots().map(
        (list) => list.docs.map((doc) => CakeData.fromFireStore(doc)).toList());
  }

  Stream<List<CakeDataOrder>> getTodayOrderCakeData() {
    var today = new DateTime.now();
    DateTime _todayStart =
        new DateTime(today.year, today.month, today.day, 0, 0);
    DateTime _todayEnd =
        new DateTime(today.year, today.month, today.day, 23, 59, 59);
    return _db
        .collection("Cake")
        .where("orderDate", isGreaterThanOrEqualTo: _todayStart)
        .where("orderDate", isLessThanOrEqualTo: _todayEnd)
        .snapshots()
        .map((list) =>
            list.docs.map((doc) => CakeDataOrder.fromFireStore(doc)).toList()
              ..sort((a, b) => a.pickUpDate.compareTo(b.pickUpDate)));
  }

  Stream<List<CakeDataPickUp>> getTodayPickCupCakeData() {
    var today = new DateTime.now();
    DateTime _todayStart =
        new DateTime(today.year, today.month, today.day, 0, 0);
    DateTime _todayEnd =
        new DateTime(today.year, today.month, today.day, 23, 59, 59);

    return _db
        .collection("Cake")
        .where("pickUpDate",
            isGreaterThanOrEqualTo: _todayStart, isLessThanOrEqualTo: _todayEnd)
        // .where("pickUpStatus", isEqualTo: false)
        .orderBy("pickUpDate")
        .snapshots()
        .map((list) =>
            list.docs.map((doc) => CakeDataPickUp.fromFireStore(doc)).toList()
              ..sort((a, b) {
                if (a.pickUpStatus) return 1;
                return -1;
              }));
  }

  Stream<List<CakeDataCalendarPickUp>> getCalendarPickUpCakeData() {
    var today = new DateTime.now();
    DateTime _monthStart = new DateTime(today.year, today.month - 3);
    DateTime _monthEnd = new DateTime(today.year, today.month + 3, 0);
    return _db
        .collection("Cake")
        .where("pickUpDate", isGreaterThanOrEqualTo: _monthStart)
        .where("pickUpDate", isLessThanOrEqualTo: _monthEnd)
        .orderBy("pickUpDate")
        .snapshots()
        .map((list) => list.docs
            .map((doc) => CakeDataCalendarPickUp.fromFireStore(doc))
            .toList());
  }

  Stream<List<CakeDataCalendarOrder>> getCalendarOrderCakeData() {
    var today = new DateTime.now();
    DateTime _monthStart = new DateTime(today.year, today.month - 3);
    DateTime _monthEnd = new DateTime(today.year, today.month + 3, 0);
    return _db
        .collection("Cake")
        .where("orderDate", isGreaterThanOrEqualTo: _monthStart)
        .where("orderDate", isLessThanOrEqualTo: _monthEnd)
        .orderBy("orderDate")
        .snapshots()
        .map((list) => list.docs
            .map((doc) => CakeDataCalendarOrder.fromFireStore(doc))
            .toList());
  }
}

class CustomerProvider with ChangeNotifier {
  final _productsSnapshot = <DocumentSnapshot>[];
  String _errorMessage = "Customer Provider RuntimeError";
  int documentLimit = 15;
  bool _hasNext = true;
  bool _isFetchingUsers = false;

  String get errorMessage => _errorMessage;
  bool get hasNext => _hasNext;

  List<CustomerData> get data => _productsSnapshot.map((snap) {
        return CustomerData.fromFireStore(snap);
      }).toList();

  Future fetchNextProducts() async {
    if (_isFetchingUsers) return;
    _isFetchingUsers = true;

    try {
      final snap = await FirebaseApi.getBoard(
        documentLimit,
        startAfter:
            _productsSnapshot.isNotEmpty ? _productsSnapshot.last : null,
      );
      _productsSnapshot.addAll(snap.docs);

      if (snap.docs.length < documentLimit) _hasNext = false;
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }

    _isFetchingUsers = false;
  }
}

class FirebaseApi {
  static Future<QuerySnapshot> getBoard(
    // 장터 상품 불러오기
    int limit, {
    DocumentSnapshot startAfter,
  }) async {
    var refProducts;

    refProducts = FirebaseFirestore.instance
        .collection('Cake')
        .orderBy("orderDate", descending: true)
        .limit(limit);

    if (startAfter == null) {
      return refProducts.get();
    } else {
      return refProducts.startAfterDocument(startAfter).get();
    }
  }
}
