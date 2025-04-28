import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryService with ChangeNotifier {
  late FirebaseFirestore firestore;
  firebase_initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("category");
  createCate(String text) async {
    QuerySnapshot querySnapshot =
        await collectionReference.where("categoryName", isEqualTo: text).get();
    if (querySnapshot.docs.length <= 0) {
      await collectionReference.add({"categoryName": text});
      return 200;
    } else {
      return 400;
    }
  }

  getCategory() async {
    List data = [];
    QuerySnapshot querySnapshot = await collectionReference.get();
    for (var doc in querySnapshot.docs.toList()) {
      var a = {"id": doc.id, "category": doc["categoryName"]};
      data.add(a);
    }
    return data;
  }

  delete(String id) async {
    try {
      collectionReference.doc(id).delete();
      return 200;
    } catch (e) {
      return 400;
    }
  }
}
