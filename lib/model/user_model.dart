/// name : "ali"
/// rule : "player"

class UserModel {
  String _name;
  String _role;
  String _id;
  String _phoneNumber;

  String get name => _name;

  String get role => _role;

  String get id => _id;

  String get phoneNumber=> _phoneNumber;

  UserModel({String name, String role, String id}) {
    _name = name;
    _role = role;
    _id = id;
  }

  UserModel.fromJson(Map<String, dynamic> json, String id) {
    _name = json["name"];
    _role = json["role"];
    _phoneNumber = json["phone_number"];
    _id = id;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = _name;
    map["role"] = _role;
    map["phone_number"] = _phoneNumber;
    return map;
  }
}
