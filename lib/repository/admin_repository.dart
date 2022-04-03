import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stadium_booking/model/response_model.dart';
import 'package:stadium_booking/provider/database_provider.dart';
import 'package:stadium_booking/view/screen/sign_up_screen.dart';

class AdminRepository{

  Future<ResponseModel> deleteUser(String userUID) async {
    try {
      return SuccessfulModel(
          data: await DataBaseProvider().deleteUser(userUID), statusCode: 200);
    } on FirebaseException catch (e) {
      print(e.message);
      return ErrorModel(message: e.message, statusCode: 404);
    } catch (e) {
      print(e.toString());
      return ErrorModel(
          message: "Network connection error , try again", statusCode: 500);
    }
  }

  Future<ResponseModel> registerAdmin(
      String email, String password, String phoneNumber , String name) async {
    try {
      return SuccessfulModel(
          data: await DataBaseProvider()
              .registerUser(email, password, name,phoneNumber ,"admin"),
          statusCode: 200);
    } on FirebaseException catch (e) {
      print(e.message);
      return ErrorModel(message: e.message, statusCode: 404);
    } catch (e) {
      print(e.toString());
      return ErrorModel(
          message: "Network connection error , try again", statusCode: 500);
    }
  }

  Future<ResponseModel> getUsers(UserRole userRole) async {
    try {
      return SuccessfulModel(
          data: await DataBaseProvider()
              .getUsersList(userRole.toString().split(".")[1]),
          statusCode: 200);
    } on FirebaseException catch (e) {
      print(e.message);
      return ErrorModel(message: e.message, statusCode: 404);
    } catch (e) {
      print(e.toString());
      return ErrorModel(
          message: "Network connection error , try again", statusCode: 500);
    }
  }

}