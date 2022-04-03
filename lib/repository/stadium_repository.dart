import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:stadium_booking/model/response_model.dart';
import 'package:stadium_booking/model/stadium_model.dart';
import 'package:stadium_booking/provider/database_provider.dart';
import 'package:stadium_booking/provider/shared_pref_provider.dart';

class StadiumRepository {
  Future<ResponseModel> addStadium(StadiumModel stadiumModel) async {
    try {
      DataBaseProvider dataBaseProvider = DataBaseProvider();
      String imageUrl =
          await dataBaseProvider.addImage(File(stadiumModel.stadiumPic));
      stadiumModel.stadiumPic = imageUrl;

      await dataBaseProvider.addStadium(stadiumModel);

      return SuccessfulModel(data: stadiumModel, statusCode: 200);
    } on FirebaseException catch (e) {
      print("404 $e");
      return ErrorModel(message: e.message, statusCode: 404);
    } catch (e) {
      print("500 $e");
      return ErrorModel(
          message: "Network connection error , try again!", statusCode: 500);
    }
  }

  Future<ResponseModel> getOwnerStadiums() async {
    try {
      String userToken = await getUserToken();
      DataBaseProvider dataBaseProvider = DataBaseProvider();
      return SuccessfulModel(
          data: await dataBaseProvider.getOwnerStadiums(userToken),
          statusCode: 200);
    } on FirebaseException catch (e) {
      print("404 $e");
      return ErrorModel(message: e.message, statusCode: 404);
    } catch (e) {
      print("500 $e");
      return ErrorModel(
          message: "Network connection error , try again!", statusCode: 500);
    }
  }

  Future<ResponseModel> getTotalStadiums() async {
    try {
      DataBaseProvider dataBaseProvider = DataBaseProvider();
      return SuccessfulModel(
          data: await dataBaseProvider.getTotalStadiums(), statusCode: 200);
    } on FirebaseException catch (e) {
      print("404 $e");
      return ErrorModel(message: e.message, statusCode: 404);
    } catch (e) {
      print("500 $e");
      return ErrorModel(
          message: "Network connection error , try again!", statusCode: 500);
    }
  }

  Future<ResponseModel> deleteStadium(String stadiumReference) async {
    try {
      DataBaseProvider dataBaseProvider = DataBaseProvider();
      return SuccessfulModel(
          data: await dataBaseProvider.deleteStadium(stadiumReference),
          statusCode: 200);
    } on FirebaseException catch (e) {
      print("404 $e");
      return ErrorModel(message: e.message, statusCode: 404);
    } catch (e) {
      print("500 $e");
      return ErrorModel(
          message: "Network connection error , try again!", statusCode: 500);
    }
  }
}
