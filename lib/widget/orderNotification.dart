import 'package:flutter/material.dart';

// Notification class to communicate between widgets
class OrderCountNotification extends Notification {
  final int count;

  OrderCountNotification({required this.count});
}
