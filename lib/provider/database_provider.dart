import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:stadium_booking/model/stadium_model.dart';
import 'package:stadium_booking/model/transaction_model.dart';

class DataBaseProvider {
  final CollectionReference _userCollectionReference =
      FirebaseFirestore.instance.collection("user");

  final CollectionReference _stadiumCollectionReference =
      FirebaseFirestore.instance.collection("stadium");

  final CollectionReference _reserveTimeCollectionReference =
      FirebaseFirestore.instance.collection("reserve");

  final CollectionReference _transactionCollectionReferences =
      FirebaseFirestore.instance.collection("transaction");

  final FirebaseStorage storage =
      FirebaseStorage(storageBucket: 'gs://reserve-stadium.appspot.com');

  Future registerUser(String email, String password, String name,
      String phoneNumber, String role) async {
    DocumentReference documentReference = _userCollectionReference.doc(email);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    if (documentSnapshot.exists) {
      throw FirebaseException(
          plugin: null, message: "this email is exist please try other one");
    }
    await documentReference.set({
      'name': name,
      'role': role,
      'password': password,
      'phone_number': phoneNumber
    });
    return documentReference;
  }

  Future getUserInfo(String email) async {
    return await _userCollectionReference.doc(email).get();
  }

  Future getUsersList(String role) async {
    return await _userCollectionReference.where("role", isEqualTo: role).get();
  }

  Future addStadium(StadiumModel stadiumModel) async {
    return await _stadiumCollectionReference.add(stadiumModel.toJson());
  }

  Future getOwnerStadiums(String ownerId) async {
    return await _stadiumCollectionReference
        .where("owner_id", isEqualTo: ownerId)
        .get();
  }

  Future getTotalStadiums() async {
    var data = await _stadiumCollectionReference.orderBy("create_at").get();
    print(data.docs.length.toString());
    return data;
  }

  Future addImage(File imageFile) async {
    final StorageReference ref =
        storage.ref().child(imageFile.path.split('/').last);
    final StorageUploadTask uploadTask = ref.putFile(imageFile);
    await uploadTask.onComplete;
    return await ref.getDownloadURL();
  }

  Future deleteStadium(String stadiumReference) async {
    return await _stadiumCollectionReference.doc(stadiumReference).delete();
  }

  Future deleteUser(String userId) async {
    return await _userCollectionReference.doc(userId).delete();
  }

  Future reserveStadiumTime(String stadiumId, String playerId,
      String phoneNumber, DateTime from, DateTime to , String transactionType) async {
    return await _reserveTimeCollectionReference.add({
      'stadium_id': stadiumId,
      'player_id': playerId,
      'from': from,
      'to': to,
      'phone_number': phoneNumber,
      'transaction_type': transactionType,
      'create_at': DateTime.now()
    });
  }

  Future getReservesTime(String stadiumId, DateTime mondayDate) async {
    DateTime monday =
        DateTime(mondayDate.year, mondayDate.month, mondayDate.day, 0, 0, 0);
    DateTime finishDate = monday.add(Duration(days: 7));
    return await _reserveTimeCollectionReference
        .where('stadium_id', isEqualTo: stadiumId)
        .where('from', isLessThan: finishDate, isGreaterThanOrEqualTo: monday)
        .get();
  }

  Future removeReservation(String reservationId) async {
    return await _reserveTimeCollectionReference.doc(reservationId).delete();
  }

  Future addTransaction(TransactionModel transactionModel) async {
    return await _transactionCollectionReferences
        .add(transactionModel.toJson());
  }

  Future getTransactions(
      String ownerId, DateTime fromDate, DateTime toDate) async {
    return await _transactionCollectionReferences
        .where('owner_id', isEqualTo: ownerId)
        .where('create_at',
            isGreaterThanOrEqualTo: fromDate, isLessThanOrEqualTo: toDate)
        .get();
  }
}
