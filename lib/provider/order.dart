import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dashboard.dart';

class OrderService with ChangeNotifier {
  late FirebaseFirestore firestore;
  firebase_initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("order");
  CollectionReference kotCollectionReference =
      FirebaseFirestore.instance.collection("companyKotStatus");
  createOrder(
      var order, double addAmount, double discAmount, double finalPrice) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var a = await pref.getString("userId");

    var kotData = [];
    try {
      DateTime now = DateTime.now();

      // Format the date to display only year, month, and day
      String formattedDate = "${now.year}-${now.month}-${now.day}";

      QuerySnapshot kotquery = await kotCollectionReference.get();

      for (var doc in kotquery.docs.toList()) {
        var a = {"id": doc.id, "kot": doc["kot"], "date": doc["date"]};
        kotData.add(a);
      }
      // print(formattedDate);
      // print(kotData[0]["date"]);
      double sum = orderData.fold(
          0, (previousValue, item) => previousValue + (item['subtotal']));
      collectionReference.add({
        "orderDate": FieldValue.serverTimestamp(),
        "formatedDate": formattedDate,
        "kot": kotData[0]["kot"],
        "orderItems": orderData,
        "total": sum,
        "orderStatus": "submit",
        "deleteStatus": 0,
        "paymentStatus": "pending",
        "staff": a,
        "additionalAmount": addAmount,
        "discountAmount": discAmount,
        "finalPrice": finalPrice
      });
      if (formattedDate == kotData[0]["date"]) {
        kotCollectionReference
            .doc(kotData[0]["id"])
            .update({"kot": kotData[0]["kot"] + 1});
      } else {
        kotCollectionReference
            .doc(kotData[0]["id"])
            .update({"date": formattedDate, "kot": 1});
      }

      // print(kotData);

      return 200;
    } catch (e) {
      return 400;
    }
  }

  getOrder() async {
    List data = [];
    QuerySnapshot querySnapshot = await collectionReference
        .where("deleteStatus", isEqualTo: 0)
        .orderBy("orderDate", descending: true)
        .get();
    for (var doc in querySnapshot.docs.toList()) {
      var a = {
        "id": doc.id,
        "orderDate": doc["orderDate"],
        "formatedDate": doc["formatedDate"],
        "kot": doc["kot"],
        "orderItems": doc["orderItems"],
        "total": doc["total"],
        "paymentStatus": doc["paymentStatus"]
      };
      data.add(a);
    }
    return data;
  }

  getOrderById(String odId) async {
    List data = [];
    QuerySnapshot querySnapshot = await collectionReference.get();
    for (var doc in querySnapshot.docs.toList()) {
      if (doc.id == odId) {
        var a = {
          "id": doc.id,
          "orderDate": doc["orderDate"],
          "formatedDate": doc["formatedDate"],
          "kot": doc["kot"],
          "orderItems": doc["orderItems"],
          "total": doc["total"],
          "paymentStatus": doc["paymentStatus"]
        };
        data.add(a);
      }
    }
    return data;
  }

  getprevisKot() async {
    List kotData = [];
    QuerySnapshot kotquery = await kotCollectionReference.get();

    for (var doc in kotquery.docs.toList()) {
      var a = {"id": doc.id, "kot": doc["kot"], "date": doc["date"]};
      kotData.add(a);
    }
    return kotData;
  }

  delete(orderId) async {
    try {
      collectionReference.doc(orderId).update({"deleteStatus": 1});
      return 200;
    } catch (e) {
      return 400;
    }
  }

  getSaleDataByDate(
    DateTime stDate,
    DateTime endDate,
  ) async {
    print(stDate);
    print(endDate);
    List data = [];
    String convertedDate = DateFormat("yyyy-MM-dd").format(stDate);

    QuerySnapshot querySnapshot = await collectionReference
        .where("deleteStatus", isEqualTo: 0)
        .where("paymentStatus", isEqualTo: "done")
        .where('orderDate',
            isGreaterThanOrEqualTo: DateTime.parse(convertedDate))
        .where('orderDate', isLessThan: endDate.add(Duration(days: 1)))
        .orderBy("orderDate", descending: true)
        .get();
    print(querySnapshot.docs.length);
    for (var doc in querySnapshot.docs.toList()) {
      var a = {
        "id": doc.id,
        "orderDate": doc["orderDate"],
        "formatedDate": doc["formatedDate"],
        "kot": doc["kot"],
        "orderItems": doc["orderItems"],
        "total": doc["total"],
        "paymentStatus": doc["paymentStatus"],
        "finalPrice": doc["finalPrice"],
      };
      data.add(a);
    }
    return data;
  }

  updatePayment(orderId) async {
    try {
      collectionReference.doc(orderId).update({"paymentStatus": "done"});
      return 200;
    } catch (e) {
      return 400;
    }
  }

  getOrderByKot(double kot, String date) async {
    List data = [];
    QuerySnapshot querySnapshot = await collectionReference
        .where("deleteStatus", isEqualTo: 0)
        .where("kot", isEqualTo: kot)
        .where("formatedDate", isEqualTo: date)
        .get();
    for (var doc in querySnapshot.docs.toList()) {
      var a = {
        "id": doc.id,
        "orderDate": doc["orderDate"],
        "formatedDate": doc["formatedDate"],
        "kot": doc["kot"],
        "orderItems": doc["orderItems"],
        "total": doc["total"],
        "paymentStatus": doc["paymentStatus"],
        "additionalAmount": doc["additionalAmount"],
        "discountAmount": doc["discountAmount"],
        "finalPrice": doc["finalPrice"]
      };
      data.add(a);
    }
    return data;
  }
}
