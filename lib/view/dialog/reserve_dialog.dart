import 'package:flutter/material.dart';
import 'package:stadium_booking/constant/constant.dart';

class ReserveDialog extends StatefulWidget {
  final String text;

  ReserveDialog({@required this.text});

  @override
  _ReserveDialogState createState() => _ReserveDialogState();
}

class _ReserveDialogState extends State<ReserveDialog> {
  TransactionType _transactionType = TransactionType.cash;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _title(),
        SizedBox(
          height: 10,
        ),
        _content(),
        SizedBox(
          height: 10,
        ),
        _transactionTypeWidget(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[buttonNo(context), buttonYes(context)],
        )
      ],
    );
  }

  Widget _transactionTypeWidget() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Pay with",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                fontStyle: FontStyle.normal,
                fontFamily: "OpenSans"),
          ),
          SizedBox(
            height: 10.0,
          ),
          ListTile(
            onTap: () {
              setState(() {
                _transactionType = TransactionType.card;
              });
            },
            title: const Text(
              'Cash',
              style: TextStyle(
                  fontFamily: "OpenSans",
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold),
            ),
            leading: Radio(
              value: TransactionType.cash,
              groupValue: _transactionType,
              onChanged: (TransactionType value) {
                setState(() {
                  _transactionType = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text(
              'Card',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "OpenSans",
                  fontSize: 14.0),
            ),
            onTap: () {
              setState(() {
                _transactionType = TransactionType.card;
              });
            },
            leading: Radio(
              value: TransactionType.card,
              groupValue: _transactionType,
              onChanged: (TransactionType value) {
                setState(() {
                  _transactionType = value;
                });
              },
            ),
          ),
        ],
      );

  Widget _title() {
    return Text("Reserve Time",
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          fontFamily: "OpenSans",
        ));
  }

  Widget _content() {
    return Text("Are you sure you want to reserve time ${widget.text} ?",
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
          fontFamily: "OpenSans",
        ));
  }

  Widget buttonYes(BuildContext context) => ButtonTheme(
        minWidth: 40,
        child: FlatButton(
          onPressed: () {
            Navigator.pop(context, _transactionType.toString().split('.')[1]);
          },
          child: Container(
            child: Center(
              child: Text("Yes",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "OpenSans",
                  )),
            ),
          ),
          padding: EdgeInsets.all(0.0),
        ),
      );

  Widget buttonNo(BuildContext context) => ButtonTheme(
        minWidth: 40,
        child: FlatButton(
          onPressed: () {
            Navigator.pop(context, "No");
          },
          child: Container(
            child: Center(
              child: Text("No",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "OpenSans",
                  )),
            ),
          ),
          padding: EdgeInsets.all(0.0),
        ),
      );
}
