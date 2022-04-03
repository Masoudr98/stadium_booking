import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stadium_booking/model/response_model.dart';
import 'package:stadium_booking/provider/database_provider.dart';
import 'package:stadium_booking/provider/shared_pref_provider.dart';

class TransactionRepository {
  Future<ResponseModel> getTransactionList(
      DateTime fromDate, DateTime toDate) async {
    try {
      DataBaseProvider dataBaseProvider = DataBaseProvider();
      return SuccessfulModel(
          data: await dataBaseProvider.getTransactions(
              await getUserToken(), fromDate, toDate),
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
