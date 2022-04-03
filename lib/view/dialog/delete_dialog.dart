import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  final String title, content;
  final Function onDonePress;

  DeleteDialog(
      {@required this.title,
      @required this.content,
      @required this.onDonePress});

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
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[buttonNo(context), buttonYes(context)],
        )
      ],
    );
  }

  Widget _title() {
    return Text(title,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          fontFamily: "OpenSans",
        ));
  }

  Widget _content() {
    return Text(content,
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
            onDonePress();
            Navigator.pop(context, "Yes");
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
