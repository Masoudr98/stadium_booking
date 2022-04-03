import 'package:flutter/cupertino.dart';

class TimeModel {
  String reservedUser = "";
  String id = "";
  String phoneNumber = "";
  final String price;
  bool isReserved;
  final DateTime time;

  TimeModel(
      {@required this.time,
      @required this.isReserved,
      @required this.price});
}
