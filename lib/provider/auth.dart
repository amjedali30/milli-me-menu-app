import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class AuthProvider with ChangeNotifier {
  late FirebaseFirestore firestore;
  firebase_initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("user");
  createUser(String name, String username, String password, String phone,
      bool userType) async {
    QuerySnapshot querySnapshot =
        await collectionReference.where("useName", isEqualTo: username).get();
    if (querySnapshot.docs.length <= 0) {
      await collectionReference.add({
        "name": name,
        "phoneNo": phone,
        "useName": username,
        "password": password,
        "userType": userType != true ? "Admin" : "Staff",
      });
      return 200;
    } else {
      return 400;
    }
  }

  getLoginData(String username, String password) async {
    List data = [];
    print(username);
    print(password);
    QuerySnapshot querySnapshot = await collectionReference
        .where("useName", isEqualTo: username)
        .where("password", isEqualTo: password)
        .get();
    print(querySnapshot.docs.length);
    if (querySnapshot.docs.length > 0) {
      for (var doc in querySnapshot.docs.toList()) {
        var a = {
          "id": doc.id,
          "name": doc["name"],
          "phoneNo": doc["phoneNo"],
          "useName": doc["useName"],
          "userType": doc["userType"],
        };
        data.add(a);
      }
      return data;
    } else {
      return [];
    }
  }
}
