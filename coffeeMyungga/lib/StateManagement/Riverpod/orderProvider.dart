import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final provider = StreamProvider<QuerySnapshot>((ref) {
  Future<QuerySnapshot> cakeDataList =
      FirebaseFirestore.instance.collection("Cake").orderBy("orderDate").get();
  return FirebaseFirestore.instance.collection("Cake").snapshots();
});

class OrderProvider with ChangeNotifier {}
