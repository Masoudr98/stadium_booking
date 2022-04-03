import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:stadium_booking/model/response_model.dart';
import 'package:stadium_booking/model/transaction_model.dart';
import 'package:stadium_booking/provider/database_provider.dart';
import 'package:stadium_booking/provider/shared_pref_provider.dart';

class ReservationRepository {
  Future<ResponseModel> reserveTime(
      String stadiumId,
      DateTime from,
      DateTime to,
      String transactionType,
      String stadiumName,
      String ownerId,
      String value) async {
    try {
      String playerId = await getUserToken();
      String userPhoneNumber = await getUserPhoneNumber();
      await DataBaseProvider().addTransaction(TransactionModel(
          playerId,
          userPhoneNumber,
          stadiumName,
          stadiumId,
          ownerId,
          "${DateFormat("yyyy-MM-dd hh:mm").format(from)}-${DateFormat("yyyy-MM-dd hh:mm").format(to)}",
          value,
          transactionType));
      return SuccessfulModel(
          data: await DataBaseProvider().reserveStadiumTime(
              stadiumId, playerId, userPhoneNumber, from, to, transactionType),
          statusCode: 200);
    } on FirebaseException catch (e) {
      print("404 ${e.message}");
      return ErrorModel(message: e.message, statusCode: 404);
    } catch (e) {
      print("500 ${e.toString()}");
      return ErrorModel(
          message: "Network connection error , try again", statusCode: 500);
    }
  }

  Future<ResponseModel> removeReservationTime(String reservationId) async {
    try {
      return SuccessfulModel(
          data: await DataBaseProvider().removeReservation(reservationId),
          statusCode: 200);
    } on FirebaseException catch (e) {
      print("404 ${e.message}");
      return ErrorModel(message: e.message, statusCode: 404);
    } catch (e) {
      print("500 ${e.toString()}");
      return ErrorModel(
          message: "Network connection error , try again", statusCode: 500);
    }
  }

  Future<ResponseModel> getReservesTime(
      String stadiumId, DateTime mondayDate) async {
    try {
      return SuccessfulModel(
          data: await DataBaseProvider().getReservesTime(stadiumId, mondayDate),
          statusCode: 200);
    } on FirebaseException catch (e) {
      print("404 ${e.message}");
      return ErrorModel(message: e.message, statusCode: 404);
    } catch (e) {
      print("500 ${e.toString()}");
      return ErrorModel(
          message: "Network connection error , try again", statusCode: 500);
    }
  }
}
