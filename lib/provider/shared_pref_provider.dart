import 'package:shared_preferences/shared_preferences.dart';

Future saveUserToken(String userToken) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString("user_token", userToken);
}

Future<String> getUserToken() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getString("user_token");
}

Future<void> deleteUserInfo() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.clear();
}

Future setUserRole(String userRole) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString("userRole_sh_key", userRole);
}

Future<String> getUserRole() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getString("userRole_sh_key");
}

Future setPhoneNumber(String phoneNumber) async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString("phoneNumber_sh_key", phoneNumber);
}

Future<String> getUserPhoneNumber() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getString("phoneNumber_sh_key");
}

Future setUserName(String name) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString("name_sh_key", name);
}

Future<String> getUserName() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getString("name_sh_key");
}

Future setUserEmail(String email) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString("email_sh_key", email);
}

Future<String> getUserEmail() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getString("email_sh_key");
}
