import 'package:cloud_firestore/cloud_firestore.dart';

/// create_at : ""
/// from : ""
/// player_id : ""
/// stadium_id : ""
/// to : ""

class ReservedTimeModel {
  Timestamp _createAt;
  Timestamp _from;
  String _playerId;
  String _stadiumId;
  Timestamp _to;
  String _id;
  String _phoneNumber;

  DateTime get createAt => DateTime.fromMillisecondsSinceEpoch(_createAt.millisecondsSinceEpoch);

  DateTime get from => DateTime.fromMillisecondsSinceEpoch(_from.millisecondsSinceEpoch);

  String get playerId => _playerId;

  String get stadiumId => _stadiumId;

  String get phoneNumber=> _phoneNumber;

  DateTime get to => DateTime.fromMillisecondsSinceEpoch(_to.millisecondsSinceEpoch);

  String get id => _id;

  ReservedTimeModel(
      {
        String id ,
        Timestamp createAt,
      Timestamp from,
      String playerId,
      String stadiumId,
        String phoneNumber ,
      Timestamp to}) {
    _createAt = createAt;
    _from = from;
    _playerId = playerId;
    _stadiumId = stadiumId;
    _to = to;
    _phoneNumber = phoneNumber;
  }

  ReservedTimeModel.fromJson(dynamic json , String id) {
    _id = id;
    _createAt = json["create_at"];
    _from = json["from"];
    _playerId = json["player_id"];
    _stadiumId = json["stadium_id"];
    _to = json["to"];
    _phoneNumber = json["phone_number"];
  }
}
