import 'package:flutter/material.dart';

abstract class ResponseModel {
  final int statusCode;

  ResponseModel({@required this.statusCode});
}

class SuccessfulModel extends ResponseModel {
  final dynamic data;

  SuccessfulModel({@required this.data, @required statusCode})
      : super(statusCode: statusCode);
}

class ErrorModel extends ResponseModel {
  final String message;

  ErrorModel({@required this.message, @required statusCode})
      : super(statusCode: statusCode);
}
