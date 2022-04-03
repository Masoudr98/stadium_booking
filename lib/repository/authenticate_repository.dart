import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:stadium_booking/model/response_model.dart';
import 'package:stadium_booking/model/user_model.dart';
import 'package:stadium_booking/provider/database_provider.dart';
import 'package:stadium_booking/provider/shared_pref_provider.dart';

class AuthenticateRepository {
  Future<ResponseModel> registerWithEmail(String email, String password,
      String name, String phoneNumber, String role) async {
    try {
      DocumentReference documentReference = await DataBaseProvider()
          .registerUser(email.toLowerCase(), md5.convert(password.codeUnits).toString(), name,
              phoneNumber, role);
      saveUserToken(documentReference.id);
      setUserEmail(email.toLowerCase());
      setUserName(name);
      setUserRole(role);
      setPhoneNumber(phoneNumber);
      return SuccessfulModel(data: documentReference, statusCode: 200);
    } on FirebaseException catch (e) {
      print("404 : ${e.toString()}");
      return ErrorModel(message: e.message, statusCode: 401);
    } catch (e) {
      print("500 : ${e.toString()}");
      return ErrorModel(
          message: "Network connection error , try again!", statusCode: 500);
    }
  }

  Future<ResponseModel> createAdminWithEmail(
      String email, String password, String name,String phoneNumber , String role) async {
    try {
      DocumentReference documentReference = await DataBaseProvider()
          .registerUser(
              email.toLowerCase(), md5.convert(password.codeUnits).toString(), name, phoneNumber,  role);
      saveUserToken(documentReference.id);
      return SuccessfulModel(data: documentReference, statusCode: 200);
    } on FirebaseException catch (e) {
      print("404 : ${e.toString()}");
      return ErrorModel(message: e.message, statusCode: 401);
    } catch (e) {
      print("500 : ${e.toString()}");
      return ErrorModel(
          message: "Network connection error , try again!", statusCode: 500);
    }
  }

  Future<ResponseModel> loginWithEmail(String email, String password) async {
    try {
      DocumentSnapshot userInfo = await DataBaseProvider().getUserInfo(email.toLowerCase());

      if (userInfo.data() == null)
        throw FirebaseException(
            plugin: "Login", message: "Email or password is incorrect");

      if (userInfo.data()["password"] !=
          md5.convert(password.codeUnits).toString())
        throw FirebaseException(
            plugin: "Login", message: "Email or password is incorrect");

      saveUserToken(userInfo.reference.id);
      UserModel userModel =
          UserModel.fromJson(userInfo.data(), userInfo.reference.id);
      setUserEmail(email.toLowerCase());
      setUserName(userModel.name);
      setUserRole(userModel.role);
      setPhoneNumber(userModel.phoneNumber);
      return SuccessfulModel(data: userModel, statusCode: 200);
    } on FirebaseException catch (e) {
      print("404 $e");
      return ErrorModel(message: e.message, statusCode: 404);
    } catch (e) {
      print("500 $e");
      return ErrorModel(
          message: "Network connection error , try again!", statusCode: 500);
    }
  }

  Future signOut() async {
    return await deleteUserInfo();
  }
}
