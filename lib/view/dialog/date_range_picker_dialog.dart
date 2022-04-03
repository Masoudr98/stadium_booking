import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateRangePickerDialog extends StatefulWidget {
  final Function(PickerDateRange) onDateChange;

  final DateTime startDate;
  final DateTime toDate;


  DateRangePickerDialog({@required this.onDateChange , this.startDate , this.toDate });

  @override
  _DateRangePickerDialogState createState() => _DateRangePickerDialogState();
}

class _DateRangePickerDialogState extends State<DateRangePickerDialog> {
  String _range = "";
  PickerDateRange _value;


  @override
  void initState() {
    if(widget.startDate != null && widget.toDate != null){
      _range =
          DateFormat('yyyy-MM-dd').format(widget.startDate).toString() +
              ' - ' +
              DateFormat('yyyy-MM-dd')
                  .format(widget.toDate ?? widget.startDate)
                  .toString();
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _datePicker(),
        _dateWidget(),
        RaisedButton(
          color: Colors.purple,
            child: Text("DONE" , style: TextStyle(color: Colors.white),),
            onPressed: () {
          widget.onDateChange(_value);
          Navigator.pop(context);
        })
      ],
    );
  }

  Widget _dateWidget() => Container(
    alignment: Alignment.centerLeft,
    padding: EdgeInsets.only(left : 16.0 , bottom: 16.0 , right: 16.0),
        child: Text(_range),
      );

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range =
            DateFormat('yyyy-MM-dd').format(args.value.startDate).toString() +
                ' - ' +
                DateFormat('yyyy-MM-dd')
                    .format(args.value.endDate ?? args.value.startDate)
                    .toString();

        _value = args.value;
      }
    });
  }

  Widget _datePicker() => Container(
        child: SfDateRangePicker(
            onSelectionChanged: _onSelectionChanged,
            selectionMode: DateRangePickerSelectionMode.range,
            initialSelectedRange: PickerDateRange(
              widget.startDate ?? DateTime.now(),
              widget.toDate ?? (widget.startDate ?? DateTime.now()),
            )),
      );
}
