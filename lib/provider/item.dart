import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../model/item.dart';

class ItemService with ChangeNotifier {
  late FirebaseFirestore firestore;
  firebase_initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("item");

  create(ItemModel item) async {
    try {
      String downloadUrl = "";
      print("--------");
      print(item.fileName);
      if (item.path != null) {
        final firebase_storage.FirebaseStorage storage =
            firebase_storage.FirebaseStorage.instance;

        firebase_storage.SettableMetadata metadata =
            firebase_storage.SettableMetadata(
          contentType: 'image/jpeg', // or 'image/png' if your file is PNG
        );

        firebase_storage.TaskSnapshot taskSnapshot = await storage
            .ref('image/${item.fileName}')
            .putFile(item.path!, metadata); // <---- added metadata here

        downloadUrl = await taskSnapshot.ref.getDownloadURL();
      } else {
        downloadUrl = "";
      }

      String lowercaseName = item.name.toLowerCase();
      print(downloadUrl);
      await collectionReference.add({
        "name": item.name,
        "discription": item.disc,
        "Options": item.optionPrice,
        "image": downloadUrl,
        "category": item.category,
        "name_lowercase": lowercaseName,
      });

      return 200;
    } catch (e) {
      print(e);
      return 400;
    }
  }

  getItem() async {
    List data = [];
    QuerySnapshot querySnapshot = await collectionReference.get();
    for (var doc in querySnapshot.docs.toList()) {
      var a = {
        "id": doc.id,
        "name": doc["name"],
        "discription": doc["discription"],
        "price": doc["Options"],
        "image": doc["image"],
        "category": doc["category"],
      };
      data.add(a);
    }
    return data;
  }

  getItemBySearch(String str) async {
    print(str);
    List data = [];
    // print(str);
    String searchKey = str.toLowerCase();
    QuerySnapshot querySnapshot = await collectionReference
        .where('name_lowercase', isGreaterThanOrEqualTo: searchKey)
        .where('name_lowercase', isLessThanOrEqualTo: searchKey + '\uf8ff')
        .get();

    for (var doc in querySnapshot.docs) {
      print("-------");
      print(doc["name"]);
      var a = {
        "id": doc.id,
        "name": doc["name"],
        "discription": doc["discription"],
        "price": doc["Options"],
        "image": doc["image"],
        "category": doc["category"],
      };
      data.add(a);
    }
    // print(data.length);
    return data;
  }

  getItemByCategory(String catId) async {
    List data = [];
    QuerySnapshot querySnapshot =
        await collectionReference.where("category", isEqualTo: catId).get();
    for (var doc in querySnapshot.docs.toList()) {
      var a = {
        "id": doc.id,
        "name": doc["name"],
        "discription": doc["discription"],
        "price": doc["Options"],
        "image": doc["image"],
        "category": doc["category"],
      };
      data.add(a);
    }
    return data;
  }

  delete(String id) async {
    collectionReference.doc(id).delete();
  }
}
