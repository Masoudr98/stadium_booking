import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:stadium_booking/model/response_model.dart';
import 'package:stadium_booking/model/transaction_model.dart';
import 'package:stadium_booking/repository/transaction_repository.dart';
import 'package:stadium_booking/view/dialog/date_range_picker_dialog.dart';
import 'package:toast/toast.dart';

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  DateTime _startDate, _toDate;

  List<TransactionModel> _transactionList = List();

  Completer completer = new Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transactions"),
        actions: [
          InkWell(
            onTap: () {
              _showDateRangePicker();
            },
            customBorder: CircleBorder(),
            child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(Icons.calendar_today_outlined)),
          )
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() => Container(
        child: Column(
          children: [
            (_startDate == null && _toDate == null)
                ? Container()
                : _fromToWidget(),
            Expanded(child: _listViewWidget()),
          ],
        ),
      );

  Widget _fromToWidget() => Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        margin: EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 0,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _startDate = null;
                      _toDate = null;
                    });
                  },
                  child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.close,
                        size: 20,
                      )),
                  customBorder: CircleBorder(),
                ),
              ),
              Column(
                children: [
                  _rowItem("from", DateFormat("yyyy-MM-dd").format(_startDate)),
                  _rowItem("to", DateFormat("yyyy-MM-dd").format(_toDate)),
                ],
              )
            ],
          ),
        ),
      );

  Widget _listViewWidget() => Container(
        child: FutureBuilder<ResponseModel>(
          future:
              TransactionRepository().getTransactionList(_startDate, _toDate),
          builder:
              (BuildContext context, AsyncSnapshot<ResponseModel> snapshot) {
            _transactionList.clear();

            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.data is ErrorModel) {
              Toast.show((snapshot.data as ErrorModel).message, context,
                  gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
            }

            if (snapshot.data is SuccessfulModel) {
              SuccessfulModel model = snapshot.data;
              QuerySnapshot querySnapshot = model.data as QuerySnapshot;
              querySnapshot.docs.forEach((element) {
                TransactionModel stadiumModel =
                    TransactionModel.fromJson(element.data());
                _transactionList.add(stadiumModel);
              });
            }
            return Stack(
              children: [
                ListView.builder(
                  padding: EdgeInsets.only(bottom: 90),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) =>
                      _listItemWidget(_transactionList[index]),
                  itemCount: _transactionList.length,
                ),
                Positioned(
                  child: _totalPriceWidget(calculateTotal()),
                  bottom: 0,
                  left: 0,
                  right: 0,
                )
              ],
            );
          },
        ),
      );

  Widget _listItemWidget(TransactionModel transactionModel) => Card(
        margin: EdgeInsets.all(8.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        elevation: 2.0,
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              _rowItem("Stadium Name", transactionModel.stadiumName ?? "--"),
              Divider(
                endIndent: 10,
                indent: 10,
              ),
              _rowItem("Price", transactionModel.value ?? "--"),
              Divider(
                endIndent: 10,
                indent: 10,
              ),
              _rowItem("Reserve time", transactionModel.reserveTime ?? "--"),
              Divider(
                endIndent: 10,
                indent: 10,
              ),
              _rowItem(
                  "Reserve at", transactionModel.createAt.toString() ?? "--"),
              Divider(
                endIndent: 10,
                indent: 10,
              ),
              _rowItem("Player phone", transactionModel.playerPhone ?? "--"),
              Divider(
                endIndent: 10,
                indent: 10,
              ),
              _rowItem("Player email", transactionModel.playerEmail ?? "--"),
              Divider(
                endIndent: 10,
                indent: 10,
              ),
              _rowItem(
                  "Transaction type", transactionModel.transactionType ?? "--"),
            ],
          ),
        ),
      );

  Widget _rowItem(String title, String value) => Container(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
                child: Text(
              title,
              style: TextStyle(color: Colors.grey),
            )),
            SizedBox(
              width: 8.0,
            ),
            Expanded(
                child: Text(
              value,
              style:
                  TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
            )),
          ],
        ),
      );

  Future<void> _showDateRangePicker() async {
    Dialog dialog = Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: DateRangePickerDialog(
          startDate: _startDate,
          toDate: _toDate,
          onDateChange: (value) {
            setState(() {
              if (value != null) {
                _startDate = value.startDate;
                _toDate = value.endDate;
              }
            });
          },
        ));

    var result = await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) => dialog);
  }

  double calculateTotal() {
    double total = 0.0;
    _transactionList.forEach((element) {
      total += double.parse(element.value ?? 0.0);
    });
    return total;
  }

  Widget _totalPriceWidget(double totalPrice) => Container(
        height: 80,
        width: double.infinity,
        child: Card(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  "Total :",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                )),
                SizedBox(
                  width: 16.0,
                ),
                Text(
                  "$totalPrice AED",
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      );
}
