import 'package:cakeorder/StateManagement/DeclareData/cakeData.dart';
import 'package:cakeorder/StateManagement/Riverpod/notifierProvider.dart/cakePrice.dart';
import 'package:cakeorder/StateManagement/Riverpod/notifierProvider.dart/partTimerNotifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final cakeOrderProvider = StreamProvider<List<CakeData>>((ref) {
//   final todayCakeData = ref.watch(StreamProvider(
//       (ref) => FirebaseFirestore.instance.collection("Cake").snapshots()));
//   // return todayCakeData.map((snapshot) => snapshot.docs.map((doc) => Idea.fromJson(doc.data())).toList());
//   return todayCakeData.map((snapshot) => snapshot.docs.map((doc) => CakeData.fromFireStore(doc)).toList());
//   //     await for (final value in ) {
//   // yield value.toString();
// });

//오늘의 케이크 예약현황을 StreamProvider로 가지고 온다.
final cakeOrderProvider = StreamProvider<List<CakeData>>((ref) {
  DateTime today = new DateTime.now();
  DateTime _todayStart = new DateTime(today.year, today.month, today.day, 0, 0);
  DateTime _todayEnd =
      new DateTime(today.year, today.month, today.day, 23, 59, 59);
  final stream = FirebaseFirestore.instance
      .collection('Cake')
      .where("orderDate",
          //예약은 현재 시간을 기준으로 가져온다
          isGreaterThanOrEqualTo: _todayStart,
          isLessThanOrEqualTo: _todayEnd)
      .snapshots();
  return stream.map((snapshot) =>
      snapshot.docs.map((doc) => CakeData.fromFireStore(doc)).toList());
});
//오늘의 케이크 픽업현황을 StreamProvider로 가지고 온다.
final cakePickupProvider = StreamProvider<List<CakeData>>((ref) {
  DateTime today = new DateTime.now();
  DateTime _todayStart = new DateTime(today.year, today.month, today.day, 0, 0);
  DateTime _todayEnd =
      new DateTime(today.year, today.month, today.day, 23, 59, 59);
  final stream = FirebaseFirestore.instance
      .collection('Cake')
      .where("pickUpDate",
          //픽업은 현재 시간을 기준으로 가져온다
          isGreaterThanOrEqualTo: _todayStart,
          isLessThanOrEqualTo: _todayEnd)
      .snapshots();
  return stream.map((snapshot) =>
      snapshot.docs.map((doc) => CakeData.fromFireStore(doc)).toList());
});

//RealtimeDatabase에 있는 CakePrice 데이터를 가져오는 Provider.
final cakePriceProvider =
    ChangeNotifierProvider<CakePriceProvider>((ref) => CakePriceProvider());

//RealtimeDatabase에 있는 partTimer 데이터를 가져오는 Provider.
final partTimerProvider =
    ChangeNotifierProvider<PartTimerProvider>((ref) => PartTimerProvider());
