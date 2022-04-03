import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class StadiumModel extends Equatable {
  String _stadiumName;
  String _stadiumAddress;
  String stadiumPic;
  String _stadiumPrice;
  String _ownerId;
  String _createAt;

  String _stadiumReference;

  String get createAt => _createAt;

  String get ownerId => _ownerId;

  String get stadiumName => _stadiumName;


  String get stadiumPrice => _stadiumPrice;

  String get stadiumAddress => _stadiumAddress;

  String get stadiumReference => _stadiumReference;

  StadiumModel(
      {@required String stadiumName,
      @required String stadiumPic,
      @required String stadiumAddress,
      @required String createAt,
      @required String ownerId,
      @required String stadiumPrice,
      @required String stadiumReference}) {
    _stadiumName = stadiumName;
    this.stadiumPic = stadiumPic;
    _stadiumPrice = stadiumPrice;
    _ownerId = ownerId;
    _stadiumAddress = stadiumAddress;
    _createAt = createAt;
  }

  Map<String, dynamic> toJson() => {
        'name': stadiumName,
        'picture': stadiumPic,
        'price': stadiumPrice,
        'address': stadiumAddress,
        'owner_id': ownerId,
        'create_at': _createAt,
      };

  StadiumModel.fromJson({@required Map<String, dynamic> data , @required stadiumReference}) {
    stadiumPic = data["picture"];
    _stadiumName = data["name"];
    _stadiumPrice = data["price"];
    _stadiumAddress = data["address"];
    _ownerId = data["owner_id"];
    _createAt = data["create_at"];
    _stadiumReference = stadiumReference;
  }

  @override
  String toString() => "$stadiumName $stadiumPrice $stadiumAddress $stadiumPic $createAt $ownerId";

  @override
  List<Object> get props => [_stadiumReference];
}
