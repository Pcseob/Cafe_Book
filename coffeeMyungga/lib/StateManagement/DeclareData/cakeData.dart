import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OrderData {
  final int count;
  final int price;
  final String size;
  final String bookCategory;
  OrderData({this.bookCategory, this.count, this.price, this.size});
}

class CakeData {
  //hh : 12, HH : 24
  DateFormat f = DateFormat("yyyy-MM-dd HH:mm");
  var orderDate;
  var pickUpDate;
  // final String cakeCategory;
  // final String cakeSize;
  // final int cakePrice;
  // final int cakeCount;
  final List<OrderData> orderCakeData;

  final String customerName;
  final String customerPhone;
  final String partTimer;
  final String remark;
  final bool payStatus;
  final bool pickUpStatus;
  final bool decoStatus;
  final bool payInStore;
  final bool payInCash;

  String documentId;

  CakeData({
    this.orderDate,
    this.pickUpDate,
    this.customerName,
    this.customerPhone,
    this.partTimer,
    this.remark,
    this.payStatus,
    this.pickUpStatus,
    this.documentId,
    this.decoStatus,
    this.payInCash,
    this.payInStore,

    // this.cakeCategory,
    // this.cakeSize,
    // this.cakePrice,
    // this.cakeCount,
    this.orderCakeData,
  });

  convertCakeData(List<OrderData> data) {
    List<Map> cakeData = [];
    data.forEach((OrderData element) => cakeData.add({
          "cakeCategory": element.bookCategory,
          "cakeSize": element.size,
          "cakePrice": element.price,
          "cakeCount": element.count
        }));
    return cakeData;
  }

  Future toFireStore(callback) async {
    this.orderDate = Timestamp.fromDate(f.parse(orderDate));
    this.pickUpDate = Timestamp.fromDate(f.parse(pickUpDate));

    await FirebaseFirestore.instance.collection("Cake").add({
      "orderDate": orderDate,
      "pickUpDate": pickUpDate,

      // "cakeCategory": cakeCategory,
      // "cakeSize": cakeSize,
      // "cakePrice": cakePrice,
      // "cakeCount": cakeCount,
      "orderCakeData": convertCakeData(orderCakeData),

      "customerName": customerName,
      "customerPhone": customerPhone,
      "partTimer": partTimer,
      "remark": remark,
      "payStatus": payStatus,
      "payInCash": payInCash ?? false,
      "payInStore": payInStore ?? false,
      "pickUpStatus": pickUpStatus ?? false,

      "decoStatus": decoStatus ?? false,
    }).then((value) {
      callback();
    });
  }

  // Future unDoFireStore() async {
  //   this.orderDate = Timestamp.fromDate(orderDate);
  //   this.pickUpDate = Timestamp.fromDate(pickUpDate);

  //   await FirebaseFirestore.instance.collection("Cake").doc(documentId).set({
  //     "orderDate": orderDate,
  //     "pickUpDate": pickUpDate,

  //     "customerName": customerName,
  //     "customerPhone": customerPhone,
  //     "partTimer": partTimer,
  //     "remark": remark,
  //     "payStatus": payStatus,
  //     "payInCash": payInCash ?? false,
  //     "payInStore": payInStore ?? false,
  //     "pickUpStatus": pickUpStatus ?? false,

  //     "orderCakeData": convertCakeData(orderCakeData),
  //     "decoStatus": decoStatus ?? false,
  //     // "cakeCategory": cakeCategory,
  //     // "cakeSize": cakeSize,
  //     // "cakePrice": cakePrice,
  //     // "cakeCount": cakeCount,
  //   }).then((value) {});
  // }

  Future updateFireStore(callback) async {
    this.orderDate = Timestamp.fromDate(f.parse(orderDate));
    this.pickUpDate = Timestamp.fromDate(f.parse(pickUpDate));

    await FirebaseFirestore.instance.collection("Cake").doc(documentId).set({
      "orderDate": orderDate,
      "pickUpDate": pickUpDate,
      "orderCakeData": convertCakeData(orderCakeData),
      "customerName": customerName,
      "customerPhone": customerPhone,
      "partTimer": partTimer,
      "remark": remark,
      "payStatus": payStatus,
      "payInCash": payInCash ?? false,
      "payInStore": payInStore ?? false,
      "pickUpStatus": pickUpStatus ?? false,
      "decoStatus": decoStatus ?? false,
    }).then((value) {
      callback();
    });
  }

  forRead() {
    this.orderDate = orderDate.toDate();
    this.pickUpDate = pickUpDate.toDate();
  }

  factory CakeData.fromFireStore(DocumentSnapshot snapshot) {
    Map<dynamic, dynamic> _cakeData = snapshot.data();
    List<OrderData> ordercakeData = [];
    _cakeData["orderCakeData"].foreach((element) => ordercakeData.add(OrderData(
        bookCategory: element["cakeCategory"],
        count: element["cakeCount"],
        price: element["cakePrice"],
        size: element["cakeSize"])));
    return CakeData(
        orderCakeData: ordercakeData,
        // cakeCategory: _cakeData["cakeCategory"] ?? '',
        // cakeCount: _cakeData["cakeCount"] ?? 1,
        // cakePrice: _cakeData["cakePrice"] ?? '',
        // cakeSize: _cakeData["cakeSize"] ?? '',
        customerName: _cakeData["customerName"],
        customerPhone: _cakeData["customerPhone"],
        documentId: snapshot.id,
        orderDate: _cakeData["orderDate"].toDate(),
        partTimer: _cakeData["partTimer"] ?? '',
        payStatus: _cakeData["payStatus"],
        payInCash: _cakeData["payInCash"] ?? false,
        payInStore: _cakeData["payInStore"] ?? false,
        pickUpDate: _cakeData["pickUpDate"].toDate(),
        pickUpStatus: _cakeData["pickUpStatus"] ?? false,
        remark: _cakeData["remark"] ?? '',
        decoStatus: _cakeData["decoStatus"] ?? false);
  }
}

// class CakeDataOrder extends CakeData {
//   CakeDataOrder(
//       {var orderDate,
//       var pickUpDate,
//       String cakeCategory,
//       String cakeSize,
//       String customerName,
//       int cakePrice,
//       String customerPhone,
//       String partTimer,
//       String remark,
//       bool payStatus,
//       bool pickUpStatus,
//       String documentId,
//       int cakeCount,
//       bool decoStatus,
//       bool payInStore,
//       bool payInCash})
//       : super(
//             cakeCategory: cakeCategory,
//             cakeCount: cakeCount,
//             cakePrice: cakePrice,
//             cakeSize: cakeSize,
//             customerName: customerName,
//             customerPhone: customerPhone,
//             decoStatus: decoStatus,
//             documentId: documentId,
//             orderDate: orderDate,
//             partTimer: partTimer,
//             payStatus: payStatus,
//             pickUpDate: pickUpDate,
//             pickUpStatus: pickUpStatus,
//             remark: remark,
//             payInCash: payInCash,
//             payInStore: payInStore);

//   factory CakeDataOrder.fromFireStore(DocumentSnapshot snapshot) {
//     Map<dynamic, dynamic> _cakeData = snapshot.data();
//     return CakeDataOrder(
//         cakeCategory: _cakeData["cakeCategory"] ?? '',
//         cakeCount: _cakeData["cakeCount"] ?? 1,
//         cakePrice: _cakeData["cakePrice"] ?? '',
//         cakeSize: _cakeData["cakeSize"] ?? '',
//         customerName: _cakeData["customerName"],
//         customerPhone: _cakeData["customerPhone"],
//         documentId: snapshot.id,
//         orderDate: _cakeData["orderDate"].toDate(),
//         partTimer: _cakeData["partTimer"] ?? '',
//         payStatus: _cakeData["payStatus"],
//         payInCash: _cakeData["payInCash"] ?? false,
//         payInStore: _cakeData["payInStore"] ?? false,
//         pickUpDate: _cakeData["pickUpDate"].toDate(),
//         pickUpStatus: _cakeData["pickUpStatus"] ?? false,
//         remark: _cakeData["remark"] ?? '',
//         decoStatus: _cakeData["decoStatus"] ?? false);
//   }
// }

// class CakeDataPickUp extends CakeData {
//   CakeDataPickUp(
//       {var orderDate,
//       var pickUpDate,
//       String cakeCategory,
//       String cakeSize,
//       String customerName,
//       int cakePrice,
//       String customerPhone,
//       String partTimer,
//       String remark,
//       bool payStatus,
//       bool pickUpStatus,
//       String documentId,
//       int cakeCount,
//       bool decoStatus,
//       bool payInStore,
//       bool payInCash})
//       : super(
//           cakeCategory: cakeCategory,
//           cakeCount: cakeCount,
//           cakePrice: cakePrice,
//           cakeSize: cakeSize,
//           customerName: customerName,
//           customerPhone: customerPhone,
//           decoStatus: decoStatus,
//           documentId: documentId,
//           orderDate: orderDate,
//           partTimer: partTimer,
//           payStatus: payStatus,
//           pickUpDate: pickUpDate,
//           pickUpStatus: pickUpStatus,
//           remark: remark,
//           payInStore: payInStore,
//           payInCash: payInCash,
//         );

//   factory CakeDataPickUp.fromFireStore(DocumentSnapshot snapshot) {
//     Map<dynamic, dynamic> _cakeData = snapshot.data();
//     return CakeDataPickUp(
//         cakeCategory: _cakeData["cakeCategory"] ?? '',
//         cakeCount: _cakeData["cakeCount"] ?? 1,
//         cakePrice: _cakeData["cakePrice"] ?? '',
//         cakeSize: _cakeData["cakeSize"] ?? '',
//         customerName: _cakeData["customerName"],
//         customerPhone: _cakeData["customerPhone"],
//         documentId: snapshot.id,
//         orderDate: _cakeData["orderDate"].toDate(),
//         partTimer: _cakeData["partTimer"] ?? '',
//         payStatus: _cakeData["payStatus"],
//         payInCash: _cakeData["payInCash"] ?? false,
//         payInStore: _cakeData["payInStore"] ?? false,
//         pickUpDate: _cakeData["pickUpDate"].toDate(),
//         pickUpStatus: _cakeData["pickUpStatus"] ?? false,
//         remark: _cakeData["remark"] ?? '',
//         decoStatus: _cakeData["decoStatus"] ?? false);
//   }
// }

// class CakeDataCalendarPickUp extends CakeData {
//   CakeDataCalendarPickUp(
//       {var orderDate,
//       var pickUpDate,
//       String cakeCategory,
//       String cakeSize,
//       String customerName,
//       int cakePrice,
//       String customerPhone,
//       String partTimer,
//       String remark,
//       bool payStatus,
//       bool pickUpStatus,
//       String documentId,
//       int cakeCount,
//       bool decoStatus,
//       bool payInStore,
//       bool payInCash})
//       : super(
//             cakeCategory: cakeCategory,
//             cakeCount: cakeCount,
//             cakePrice: cakePrice,
//             cakeSize: cakeSize,
//             customerName: customerName,
//             customerPhone: customerPhone,
//             decoStatus: decoStatus,
//             documentId: documentId,
//             orderDate: orderDate,
//             partTimer: partTimer,
//             payStatus: payStatus,
//             pickUpDate: pickUpDate,
//             pickUpStatus: pickUpStatus,
//             payInStore: payInStore,
//             payInCash: payInCash,
//             remark: remark);
//   factory CakeDataCalendarPickUp.fromFireStore(DocumentSnapshot snapshot) {
//     Map<dynamic, dynamic> _cakeData = snapshot.data();
//     return CakeDataCalendarPickUp(
//         cakeCategory: _cakeData["cakeCategory"] ?? '',
//         cakeCount: _cakeData["cakeCount"] ?? 1,
//         cakePrice: _cakeData["cakePrice"] ?? '',
//         cakeSize: _cakeData["cakeSize"] ?? '',
//         customerName: _cakeData["customerName"],
//         customerPhone: _cakeData["customerPhone"],
//         documentId: snapshot.id,
//         orderDate: _cakeData["orderDate"].toDate(),
//         partTimer: _cakeData["partTimer"] ?? '',
//         payStatus: _cakeData["payStatus"],
//         payInCash: _cakeData["payInCash"] ?? false,
//         payInStore: _cakeData["payInStore"] ?? false,
//         pickUpDate: _cakeData["pickUpDate"].toDate(),
//         pickUpStatus: _cakeData["pickUpStatus"] ?? false,
//         remark: _cakeData["remark"] ?? '',
//         decoStatus: _cakeData["decoStatus"] ?? false);
//   }
// }

// class CakeDataCalendarOrder extends CakeData {
//   CakeDataCalendarOrder(
//       {var orderDate,
//       var pickUpDate,
//       String cakeCategory,
//       String cakeSize,
//       String customerName,
//       int cakePrice,
//       String customerPhone,
//       String partTimer,
//       String remark,
//       bool payStatus,
//       bool pickUpStatus,
//       String documentId,
//       int cakeCount,
//       bool decoStatus,
//       bool payInStore,
//       bool payInCash})
//       : super(
//             cakeCategory: cakeCategory,
//             cakeCount: cakeCount,
//             cakePrice: cakePrice,
//             cakeSize: cakeSize,
//             customerName: customerName,
//             customerPhone: customerPhone,
//             decoStatus: decoStatus,
//             documentId: documentId,
//             orderDate: orderDate,
//             partTimer: partTimer,
//             payStatus: payStatus,
//             pickUpDate: pickUpDate,
//             pickUpStatus: pickUpStatus,
//             payInStore: payInStore,
//             payInCash: payInCash,
//             remark: remark);
//   factory CakeDataCalendarOrder.fromFireStore(DocumentSnapshot snapshot) {
//     Map<dynamic, dynamic> _cakeData = snapshot.data();
//     return CakeDataCalendarOrder(
//         cakeCategory: _cakeData["cakeCategory"] ?? '',
//         cakeCount: _cakeData["cakeCount"] ?? 1,
//         cakePrice: _cakeData["cakePrice"] ?? '',
//         cakeSize: _cakeData["cakeSize"] ?? '',
//         customerName: _cakeData["customerName"],
//         customerPhone: _cakeData["customerPhone"],
//         documentId: snapshot.id,
//         orderDate: _cakeData["orderDate"].toDate(),
//         partTimer: _cakeData["partTimer"] ?? '',
//         payStatus: _cakeData["payStatus"],
//         payInCash: _cakeData["payInCash"] ?? false,
//         payInStore: _cakeData["payInStore"] ?? false,
//         pickUpDate: _cakeData["pickUpDate"].toDate(),
//         pickUpStatus: _cakeData["pickUpStatus"] ?? false,
//         remark: _cakeData["remark"] ?? '',
//         decoStatus: _cakeData["decoStatus"] ?? false);
//   }
// }

// class CakeCategory {
//   final String name;
//   final List<dynamic> cakeSize;
//   final List<dynamic> cakePrice;
//   CakeCategory({required this.name,required this.cakePrice,required this.cakeSize});
//   factory CakeCategory.fromFireStore(DocumentSnapshot snapshot) {
//     Map<dynamic, dynamic> _cakeCategory = snapshot.data();
//     var _data = _cakeCategory["CakePrice"];

//     return CakeCategory(
//         name: snapshot.id ?? '',
//         cakeSize: _data.keys.toList() ?? [],
//         cakePrice: _data.values.toList() ?? []);
//   }
//   getCake(String cakeName) {
//     return FirebaseFirestore.instance
//         .collection("CakeList")
//         .doc(cakeName)
//         .get();
//   }

//   checkCakeCateogry(String cakeName) async {
//     return await FirebaseFirestore.instance
//         .collection("CakeList")
//         .get()
//         .then((value) {
//       bool checkResult = false;
//       if (value != null) {
//         value.docs.forEach((element) {
//           if (element.id == cakeName) checkResult = true;
//         });
//       }
//       return checkResult;
//     });
//   }
// }

// class CustomerData {
//   final String name;
//   final String phoneNumber;
//   CustomerData({this.name, this.phoneNumber});
//   factory CustomerData.fromFireStore(DocumentSnapshot snapshot) {
//     Map _cakeData = snapshot.data();
//     return CustomerData(
//         name: _cakeData["customerName"],
//         phoneNumber: _cakeData["customerPhone"]);
//   }
// }
