import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  String _playerEmail;
  String _playerPhone;
  String _stadiumName;
  String _stadiumId;
  String _ownerId;
  String _reserveTime;
  String _value;
  String _transactionType;
  Timestamp _createAt;

  get playerEmail => _playerEmail;

  get playerPhone => _playerPhone;

  get stadiumName => _stadiumName;

  get stadiumId => _stadiumId;

  get ownerId => _ownerId;

  get reserveTime => _reserveTime;

  get value => _value;

  get transactionType => _transactionType;

  get createAt =>
      DateTime.fromMillisecondsSinceEpoch(_createAt.millisecondsSinceEpoch);

  TransactionModel(
      String playerEmail,
      String playerPhone,
      String stadiumName,
      String stadiumId,
      String ownerId,
      String reserveTime,
      String value,
      String transactionType) {
    _playerEmail = playerEmail;
    _playerPhone = playerPhone;
    _stadiumName = stadiumName;
    _stadiumId = stadiumId;
    _ownerId = ownerId;
    _reserveTime = reserveTime;
    _value = value;
    _transactionType = transactionType;}

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["player_email"] = _playerEmail;
    map["player_phone"] = _playerPhone;
    map["stadium_name"] = _stadiumName;
    map["stadium_id"] = _stadiumId;
    map["owner_id"] = _ownerId;
    map["reserve_time"] = _reserveTime;
    map["value"] = _value;
    map["create_at"] = DateTime.now();
    map["transaction_type"] = _transactionType;
    return map;
  }

  TransactionModel.fromJson(dynamic json) {
    _playerEmail = json["player_email"];
    _playerPhone = json["player_phone"];
    _stadiumName = json["stadium_name"];
    _stadiumId = json["stadium_id"];
    _ownerId = json["owner_id"];
    _reserveTime = json["reserve_time"];
    _value = json["value"];
    _createAt = json["create_at"];
    _transactionType = json["transaction_type"];
  }
}
