import 'package:cakeorder/StateManagement/DeclareData/cakeData.dart';
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
final cakeOrderProvider = StreamProvider<List<CakeData>>((ref) {
  DateTime today = new DateTime.now();
  DateTime _todayStart = new DateTime(today.year, today.month, today.day, 0, 0);
  DateTime _todayEnd =
      new DateTime(today.year, today.month, today.day, 23, 59, 59);
  final stream = FirebaseFirestore.instance
      .collection('Cake')
      .where("orderDate",
          isGreaterThanOrEqualTo: _todayStart, isLessThanOrEqualTo: _todayEnd)
      .snapshots();
  return stream.map((snapshot) =>
      snapshot.docs.map((doc) => CakeData.fromFireStore(doc)).toList());
});

final cakePickupProvider = StreamProvider<List<CakeData>>((ref) {
  DateTime today = new DateTime.now();
  DateTime _todayStart = new DateTime(today.year, today.month, today.day, 0, 0);
  DateTime _todayEnd =
      new DateTime(today.year, today.month, today.day, 23, 59, 59);
  final stream = FirebaseFirestore.instance
      .collection('Cake')
      .where("pickUpDate",
          isGreaterThanOrEqualTo: _todayStart, isLessThanOrEqualTo: _todayEnd)
      .snapshots();
  return stream.map((snapshot) =>
      snapshot.docs.map((doc) => CakeData.fromFireStore(doc)).toList());
});
