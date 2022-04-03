import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:intl/intl.dart';
import 'package:stadium_booking/model/reserved_time_model.dart';
import 'package:stadium_booking/model/response_model.dart';
import 'package:stadium_booking/model/stadium_model.dart';
import 'package:stadium_booking/model/time_model.dart';
import 'package:stadium_booking/model/user_model.dart';
import 'package:stadium_booking/provider/shared_pref_provider.dart';
import 'package:stadium_booking/repository/reservation_repository.dart';
import 'package:stadium_booking/view/dialog/cancel_reserve_dialog.dart';
import 'package:stadium_booking/view/dialog/reserve_dialog.dart';
import 'package:stadium_booking/view/screen/sign_up_screen.dart';
import 'package:toast/toast.dart';

class StadiumScreen extends StatefulWidget {
  final StadiumModel stadiumModel;
  final UserModel userModel;

  StadiumScreen({@required this.stadiumModel, @required this.userModel});

  @override
  _StadiumScreenState createState() => _StadiumScreenState();
}

class _StadiumScreenState extends State<StadiumScreen> {
  DateTime _startWeekDate;
  DateTime _selectedDate;
  List<TimeModel> _stadiumTimeModel = List();
  List<ReservedTimeModel> _reservedTimeList = List();

  int reserveTime = 90;

  @override
  void initState() {
    _selectedDate = _startWeekDate = _getFirstMonday(DateTime.now());
    _initList();
    getReserveList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: _body()),
    );
  }

  void _initList() {
    DateTime dateTime =
        DateTime(2020, _selectedDate.month, _selectedDate.day, 8, 0, 0, 0, 0);
    _stadiumTimeModel.clear();
    for (int i = 0; i < 11; i++) {
      _stadiumTimeModel.add(TimeModel(
          time: dateTime,
          isReserved: false,
          price: "${widget.stadiumModel.stadiumPrice} AED"));
      dateTime = dateTime.add(Duration(minutes: reserveTime));
    }

    for (ReservedTimeModel reservedTimeModel in _reservedTimeList) {
      _stadiumTimeModel.forEach((element) {
        if (element.time.day == reservedTimeModel.from.day) {
          if (element.time.hour == reservedTimeModel.from.hour) {
            if (element.time.minute == reservedTimeModel.from.minute) {
              element.isReserved = true;
              element.id = reservedTimeModel.id;
              element.reservedUser = reservedTimeModel.playerId;
              element.phoneNumber = reservedTimeModel.phoneNumber;
              print("_initList ${element.time}");
            }
          }
        }
      });
    }

    try {
      setState(() {});
    } catch (e) {}
  }

  DateTime _getFirstMonday(DateTime startDate) {
    var monday = startDate;
    while (monday.weekday != DateTime.monday) {
      monday = monday.subtract(new Duration(days: 1));
    }

    var toDay = DateTime.now();
    for (int i = 0; i < 7; i++) {
      var newDate = monday.add(Duration(days: i));
      if (newDate.year == toDay.year &&
          newDate.month == toDay.month &&
          newDate.day == toDay.day) {
        return newDate;
      }
    }
    return monday;
  }

  Future getReserveList() async {
    ResponseModel responseModel = await ReservationRepository()
        .getReservesTime(widget.stadiumModel.stadiumReference, _startWeekDate);
    if (responseModel is SuccessfulModel) {
      QuerySnapshot querySnapshot = responseModel.data;
      _reservedTimeList.clear();
      for (QueryDocumentSnapshot item in querySnapshot.docs) {
        ReservedTimeModel reservedTimeModel =
            ReservedTimeModel.fromJson(item.data(), item.reference.id);
        _reservedTimeList.add(reservedTimeModel);
        _stadiumTimeModel.forEach((element) {
          if (element.time.day == reservedTimeModel.from.day) {
            if (element.time.hour == reservedTimeModel.from.hour) {
              if (element.time.minute == reservedTimeModel.from.minute) {
                element.isReserved = true;
                element.id = reservedTimeModel.id;
                element.reservedUser = reservedTimeModel.playerId;
                element.phoneNumber = reservedTimeModel.phoneNumber;
              }
            }
          }
        });
      }
    }

    try {
      setState(() {});
    } catch (e) {}
  }

  Widget _body() => Column(
        children: <Widget>[_title(), Expanded(child: _dailyTimeList())],
      );

  Widget _title() => Container(
        color: Color(0xFFD3CCE3),
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _titleContent(),
            SizedBox(
              height: 12.0,
            ),
            _calendarTitle(),
          ],
        ),
      );

  Widget _titleContent() => Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                InkWell(
                  customBorder: CircleBorder(),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "${widget.stadiumModel.stadiumName}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "OpenSans",
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 8.0,
          ),
          Column(
            children: <Widget>[
              Text(
                  _startWeekDate.month ==
                          _startWeekDate.add(Duration(days: 7)).month
                      ? DateFormat('MMM').format(_startWeekDate)
                      : "${DateFormat('MMM').format(_startWeekDate)}-${DateFormat('MMM').format(_startWeekDate.add(Duration(days: 7)))}",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "OpenSans",
                  )),
              Text(DateFormat('yyyy').format(_startWeekDate),
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontFamily: "OpenSans",
                  )),
            ],
          )
        ],
      );

  Widget _calendarTitle() => CalendarTitle(
        changeDay: (date) {
          setState(() {
            _selectedDate = date;
            _initList();
          });
        },
        changeWeek: (date) {
          setState(() {
            _startWeekDate = date;
            _selectedDate = date;
            getReserveList();
            _initList();
          });
        },
      );

  Widget _dailyTimeList() => Container(
        color: Colors.white,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: _stadiumTimeModel.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) => DailyTimeItem(
            userModel: widget.userModel,
            stadiumModel: widget.stadiumModel,
            onChange: (timeModel) {
              setState(() {
                _stadiumTimeModel[index] = timeModel;
              });
            },
            timeModel: _stadiumTimeModel[index],
          ),
        ),
      );
}

class CalendarTitle extends StatefulWidget {
  final Function(DateTime) changeWeek;
  final Function(DateTime) changeDay;

  CalendarTitle({@required this.changeWeek, @required this.changeDay});

  @override
  _CalendarTitleState createState() => _CalendarTitleState();
}

class _CalendarTitleState extends State<CalendarTitle> {
  DateTime _startDate;
  int selectedItemPosition = 0;
  List _daysNameList = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"];
  List<DateTime> _weekDate = [];

  @override
  void initState() {
    _startDate = _getFirstMonday(DateTime.now());
    _initWeekDate(_startDate);
    _checkWeekDay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          onPressed: () {
            setState(() {
              _prevWeek();
              _initWeekDate(_startDate);
              var date = _checkWeekDay();
              widget.changeDay(_weekDate[selectedItemPosition]);
              widget.changeWeek(date);
            });
          },
          icon: Icon(Icons.chevron_left),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
                _daysNameList.length,
                (index) => InkWell(
                      onTap: () {
                        setState(() {
                          selectedItemPosition = index;
                          widget.changeDay(_weekDate[index]);
                        });
                      },
                      child: CalendarTitleItem(
                        isSelected: selectedItemPosition == index,
                        dayName: _daysNameList[index],
                        dayOfMonth: DateFormat('dd').format(_weekDate[index]),
                      ),
                    )),
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _nextWeek();
              _initWeekDate(_startDate);
              var date = _checkWeekDay();
              widget.changeDay(_weekDate[selectedItemPosition]);
              widget.changeWeek(date);
            });
          },
          icon: Icon(Icons.chevron_right),
        ),
      ],
    );
  }

  DateTime _getFirstMonday(DateTime startDate) {
    var monday = startDate;
    while (monday.weekday != DateTime.monday) {
      monday = monday.subtract(new Duration(days: 1));
    }
    return monday;
  }

  void _initWeekDate(DateTime startDate) {
    _weekDate.clear();
    var monday = startDate;
    //arrive to dat one
    while (monday.weekday != DateTime.monday) {
      monday = monday.subtract(new Duration(days: 1));
    }
    for (int i = 0; i < 7; i++) {
      _weekDate.add(monday.add(Duration(days: i)));
    }
  }

  void _nextWeek() {
    _startDate = _startDate.add(Duration(days: 7));
  }

  void _prevWeek() {
    if (_startDate
            .subtract(Duration(days: 7))
            .difference(DateTime.now())
            .inDays >
        -7) {}
    _startDate = _startDate.subtract(Duration(days: 7));
  }

  DateTime _checkWeekDay() {
    var toDay = DateTime.now();
    for (int i = 0; i < 7; i++) {
      var newDate = _startDate.add(Duration(days: i));
      if (newDate.year == toDay.year &&
          newDate.month == toDay.month &&
          newDate.day == toDay.day) {
        selectedItemPosition = i;
        return newDate;
      }
    }

    selectedItemPosition = 0;
    return _startDate;
  }
}

class CalendarTitleItem extends StatefulWidget {
  final String dayName;
  final String dayOfMonth;
  final bool isSelected;

  CalendarTitleItem(
      {@required this.dayName,
      @required this.dayOfMonth,
      @required this.isSelected});

  @override
  _CalendarTitleItemState createState() => _CalendarTitleItemState();
}

class _CalendarTitleItemState extends State<CalendarTitleItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      padding: EdgeInsets.all(6.0),
      decoration: widget.isSelected
          ? BoxDecoration(
              color: Colors.purpleAccent,
              borderRadius: BorderRadius.circular(4.0))
          : null,
      child: Column(
        children: <Widget>[
          Text(widget.dayName,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight:
                    widget.isSelected ? FontWeight.bold : FontWeight.normal,
                color: widget.isSelected ? Colors.white : Colors.black54,
                fontFamily: "OpenSans",
              )),
          SizedBox(
            height: 4.0,
          ),
          Text(widget.dayOfMonth,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight:
                    widget.isSelected ? FontWeight.bold : FontWeight.normal,
                color: widget.isSelected ? Colors.white : Colors.black54,
                fontFamily: "OpenSans",
              ))
        ],
      ),
    );
  }
}

class DailyTimeItem extends StatefulWidget {
  final TimeModel timeModel;
  final StadiumModel stadiumModel;
  final Function(TimeModel) onChange;
  final UserModel userModel;

  DailyTimeItem(
      {@required this.timeModel,
      @required this.stadiumModel,
      @required this.onChange,
      @required this.userModel});

  @override
  _DailyTimeItemState createState() => _DailyTimeItemState();
}

class _DailyTimeItemState extends State<DailyTimeItem> {
  final int reserveTime = 90; //min

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.timeModel.isReserved) {
          if (widget.timeModel.time
                  .difference(DateTime.now().subtract(Duration(minutes: 10)))
                  .inMinutes >
              0) {
            if (widget.userModel.role ==
                    UserRole.admin.toString().split('.')[1] ||
                widget.userModel.role ==
                    UserRole.superAdmin.toString().split('.')[1]) {
              _showCancelReserveDialog();
            } else if (widget.userModel.role ==
                    UserRole.stadiumOwner.toString().split('.')[1] &&
                widget.userModel.id == widget.stadiumModel.ownerId) {
              _showCancelReserveDialog();
            } else if (widget.userModel.role ==
                    UserRole.player.toString().split('.')[1] &&
                widget.userModel.id == widget.timeModel.reservedUser) {
              _showCancelReserveDialog();
            }
          }
        } else {
          if (widget.timeModel.time.difference(DateTime.now()).inMinutes > 0) {
            if (widget.userModel.role ==
                UserRole.player.toString().split('.')[1]) _showReserveDialog();
          }
        }
      },
      child: Container(
          margin: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
          height: 120,
          child: _bodyContent()),
    );
  }

  Widget _bodyContent() => Row(
        children: <Widget>[
          _timeTitleWidget(),
          Expanded(
              child: Stack(
            children: <Widget>[
              _timeDescription(),
              widget.timeModel.isReserved ? _reservedCover() : Container()
            ],
          ))
        ],
      );

  Widget _reservedCover() => Container(
        height: double.infinity,
        width: double.infinity,
        margin: EdgeInsets.only(left: 24.0),
        color: Colors.white30.withOpacity(0.9),
        child: Stack(
          children: [
            _showReserveName()
                ? Positioned(
                    top: 8,
                    left: 8,
                    child: Text(
                      "${widget.timeModel.reservedUser}\n${widget.timeModel.phoneNumber}",
                      style: TextStyle(
                          fontFamily: "OpenSans",
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                : Container(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Container(
                        color: Colors.red,
                        height: 2.0,
                        margin: EdgeInsets.only(left: 16.0, right: 4.0)),
                  ),
                  Container(
                    width: 4,
                    color: Colors.red,
                    height: 2.0,
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                  ),
                  Text(
                    "RESERVED",
                    style: TextStyle(
                        fontFamily: "OpenSans",
                        fontSize: 24.0,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: 4,
                    color: Colors.red,
                    height: 2.0,
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.red,
                      height: 2.0,
                      margin: EdgeInsets.only(left: 4.0, right: 16.0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  bool _showReserveName() {
    if (widget.userModel.role == UserRole.admin.toString().split('.')[1] ||
        widget.userModel.role == UserRole.superAdmin.toString().split('.')[1]) {
      return true;
    }

    if (widget.userModel.role ==
            UserRole.stadiumOwner.toString().split('.')[1] &&
        widget.userModel.id == widget.stadiumModel.ownerId) {
      return true;
    }

    if (widget.userModel.role == UserRole.player.toString().split('.')[1] &&
        widget.userModel.id == widget.timeModel.reservedUser) {
      return true;
    }
    return false;
  }

  Widget _timeDescription() => Container(
        decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6.0),
                bottomLeft: Radius.circular(6.0))),
        margin: EdgeInsets.only(left: 24.0),
        child: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.only(left: 6.0),
          height: double.infinity,
          width: double.infinity,
          color: Color(0xfffcf9f5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                  "${DateFormat("HH:mm").format(widget.timeModel.time)} - ${DateFormat("HH:mm").format(widget.timeModel.time.add(Duration(minutes: reserveTime)))}",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "OpenSans",
                  )),
              SizedBox(
                width: 10,
              ),
              Text("${widget.timeModel.price}",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "OpenSans",
                  ))
            ],
          ),
        ),
      );

  Widget _timeTitleWidget() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text("${DateFormat("HH:mm").format(widget.timeModel.time)}",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                fontFamily: "OpenSans",
              )),
          Expanded(
            child: Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: _lineGenerator([10, 25, 10, 20])),
          )
        ],
      );

  Widget _lineGenerator(List<double> widths) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
            widths.length,
            (index) => Container(
                  width: widths[index],
                  height: 2.0,
                  color: Colors.grey,
                )),
      );

  Future<void> _showReserveDialog() async {
    Dialog dialog = Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: ReserveDialog(
          text:
              "${DateFormat("HH:mm").format(widget.timeModel.time)} - ${DateFormat("HH:mm dd MMM yyyy").format(widget.timeModel.time.add(Duration(minutes: reserveTime)))}",
        ));

    var result = await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) => dialog);

    if (result != null && result != "No") {
      ResponseModel responseModel = await ReservationRepository().reserveTime(
          widget.stadiumModel.stadiumReference,
          widget.timeModel.time,
          widget.timeModel.time.add(Duration(minutes: reserveTime)),
          result,
          widget.stadiumModel.stadiumName,
          widget.stadiumModel.ownerId,
          widget.stadiumModel.stadiumPrice);
      if (responseModel is SuccessfulModel) {
        DocumentReference documentReference = responseModel.data;
        widget.timeModel.id = documentReference.id;
        widget.timeModel.isReserved = true;
        widget.timeModel.reservedUser = widget.userModel.id;
        widget.onChange(widget.timeModel);
        Toast.show("Time Successfully reserved!", context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      }

      if (responseModel is ErrorModel) {
        Toast.show(responseModel.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      }
    }
  }

  Future<void> _showCancelReserveDialog() async {
    Dialog dialog = Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: CancelReserveDialog(
          text:
              "${DateFormat("HH:mm").format(widget.timeModel.time)} - ${DateFormat("HH:mm dd MMM yyyy").format(widget.timeModel.time.add(Duration(minutes: reserveTime)))}",
        ));

    var result = await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) => dialog);

    if (result == "Yes") {
      showProgressDialog(loadingText: "");
      ResponseModel responseModel = await ReservationRepository()
          .removeReservationTime(widget.timeModel.id);
      dismissProgressDialog();
      if (responseModel is SuccessfulModel) {
        widget.timeModel.id = "";
        widget.timeModel.isReserved = false;
        widget.timeModel.reservedUser = "";
        widget.timeModel.phoneNumber = "";
        widget.onChange(widget.timeModel);
        Toast.show("Time Successfully reserved!", context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      }

      if (responseModel is ErrorModel) {
        Toast.show(responseModel.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      }
    }
  }
}
