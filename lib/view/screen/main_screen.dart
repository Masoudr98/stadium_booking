import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:stadium_booking/constant/constant.dart';
import 'package:stadium_booking/model/response_model.dart';
import 'package:stadium_booking/model/stadium_model.dart';
import 'package:stadium_booking/model/user_model.dart';
import 'package:stadium_booking/provider/shared_pref_provider.dart';
import 'package:stadium_booking/repository/authenticate_repository.dart';
import 'package:stadium_booking/repository/stadium_repository.dart';
import 'package:stadium_booking/view/dialog/delete_dialog.dart';
import 'package:stadium_booking/view/screen/add_stadium_screen.dart';
import 'package:stadium_booking/view/screen/admins_screen.dart';
import 'package:stadium_booking/view/screen/sign_up_screen.dart';
import 'package:stadium_booking/view/screen/stadium_screen.dart';
import 'package:stadium_booking/view/screen/transaction_screen.dart';
import 'package:toast/toast.dart';

import 'customers_screen.dart';
import 'login_screen.dart';
import 'owners_screen.dart';

class MainScreen extends StatefulWidget {
  final UserRole userRole;

  MainScreen({@required this.userRole});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _searchAnimation;
  ScrollController _scrollController;
  bool _addStadiumFABVisibility = true;

  List _stadiumList = List<StadiumModel>();
  List _tempStadiumList = List<StadiumModel>();

  FocusNode _searchTextFieldFocusNode;

  TextEditingController _searchEditController = TextEditingController();

  Future _stadiumFuture;

  String userId = "";

  @override
  void initState() {
    getUserToken().then((value) {
      try {
        userId = value;
        setState(() {});
      } catch (e) {}
    });
    if (widget.userRole == UserRole.stadiumOwner) {
      _stadiumFuture = StadiumRepository().getOwnerStadiums();
    } else {
      _stadiumFuture = StadiumRepository().getTotalStadiums();
    }
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200))
          ..addListener(() => setState(() {}));
    _searchAnimation =
        Tween<double>(begin: -2.0, end: -1.0).animate(_animationController);
    _searchTextFieldFocusNode = FocusNode();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_addStadiumFABVisibility == true) {
          setState(() {
            _addStadiumFABVisibility = false;
          });
        }
      } else {
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_addStadiumFABVisibility == false) {
            setState(() {
              _addStadiumFABVisibility = true;
            });
          }
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      drawer: _drawer(),
      floatingActionButton: _addStadiumFAB(),
      body: SafeArea(
        child: Stack(
          children: <Widget>[_backgroundWidget(), _bodyWidget()],
        ),
      ),
    );
  }

  Widget _appBar() => AppBar(
        title: Text(
          "Stadium Booking",
          style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          InkWell(
              customBorder: CircleBorder(),
              onTap: () {
                if ((_searchAnimation.value ?? -2.0) == -2.0) {
                  _animationController.forward();
                  _searchTextFieldFocusNode.requestFocus();
                } else {
                  FocusScope.of(context).unfocus();
                  _animationController.reverse();
                  _searchTextFieldFocusNode.unfocus();
                }
              },
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.search)))
        ],
      );

  Widget _addStadiumFAB() => Visibility(
        visible: widget.userRole == UserRole.stadiumOwner
            ? _addStadiumFABVisibility
            : false,
        child: FloatingActionButton(
          onPressed: () async {
            var stadiumModel = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddStadiumScreen()));

            if (stadiumModel != null && stadiumModel is StadiumModel) {
              setState(() {
                _stadiumFuture = StadiumRepository().getOwnerStadiums();
              });
            }
          },
          child: Icon(Icons.add),
        ),
      );

  Widget _backgroundWidget() => Container(
        color: Color(0xFFE9E4F0).withOpacity(0.5),
      );

  Widget _bodyWidget() => Stack(
        children: <Widget>[
          _stadiumListWidget(),
          Align(
            alignment: Alignment(0, _searchAnimation.value ?? -2.0),
            child: _searchBoxWidget(),
          ),
        ],
      );

  Widget _searchBoxWidget() => Container(
        margin: EdgeInsets.all(12.0),
        width: double.infinity,
        height: 60,
        alignment: Alignment.centerLeft,
        decoration: searchBoxDecoration(),
        child: TextField(
          controller: _searchEditController,
          onChanged: (value) {
            setState(() {
              List<StadiumModel> _model = List();
              _model.addAll(_stadiumList.where((element) =>
                  (element as StadiumModel).stadiumName.contains(value)));
              _tempStadiumList.clear();
              _tempStadiumList.addAll(_model);
            });
          },
          focusNode: _searchTextFieldFocusNode,
          style: TextStyle(color: Colors.black, fontFamily: "OpenSans"),
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              hintText: "Search Stadium",
              hintStyle: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.normal,
              ),
              prefixIcon: Icon(Icons.search)),
          keyboardType: TextInputType.visiblePassword,
        ),
      );

  Widget _stadiumListWidget() => FutureBuilder<ResponseModel>(
        future: _stadiumFuture,
        builder: (BuildContext context, AsyncSnapshot<ResponseModel> snapshot) {
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
            _stadiumList.clear();
            querySnapshot.docs.forEach((element) {
              StadiumModel stadiumModel = StadiumModel.fromJson(
                  data: element.data(), stadiumReference: element.reference.id);
              _stadiumList.add(stadiumModel);
            });

            //_tempStadiumList = _stadiumList;
          }

          List<StadiumModel> listModel = _searchEditController.text.isEmpty
              ? _stadiumList
              : _tempStadiumList;
          return ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 84 * _animationController.value),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) => _stadiumItem(listModel[index]),
            itemCount: listModel.length,
          );
        },
      );

  Widget _stadiumItem(StadiumModel stadiumModel) => InkWell(
        onTap: () async {
          UserModel userModel = UserModel(
              name: await getUserName(),
              role: widget.userRole.toString().split('.')[1],
              id: await getUserToken());
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => StadiumScreen(
                        userModel: userModel,
                        stadiumModel: stadiumModel,
                      )));
        },
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
          child: Stack(
            children: [
              Container(
                height: 240,
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Flexible(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15.0),
                                topLeft: Radius.circular(15.0)),
                          ),
                          height: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15.0),
                                topLeft: Radius.circular(15.0)),
                            child: Image.network(
                              stadiumModel.stadiumPic,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        )),
                    Flexible(flex: 1, child: _stadiumItemContent(stadiumModel))
                  ],
                ),
              ),
              widget.userRole == UserRole.superAdmin ||
                      widget.userRole == UserRole.admin ||
                      (widget.userRole == UserRole.stadiumOwner &&
                          stadiumModel.ownerId == userId)
                  ? _deleteItemWidget(stadiumModel)
                  : Container()
            ],
          ),
        ),
      );

  Widget _deleteItemWidget(StadiumModel stadiumModel) => Positioned(
        top: 0,
        right: 0,
        child: InkWell(
          onTap: () {
            _showDialog(stadiumModel);
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          ),
        ),
      );

  Future<void> _showDialog(StadiumModel stadiumModel) async {
    Dialog dialog = Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: DeleteDialog(
          title: "Delete Stadium",
          content:
              "Are you sure you want to delete ${stadiumModel.stadiumName} stadium?",
          onDonePress: () {},
        ));

    var result = await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) => dialog);
    if (result == "Yes") {
      showProgressDialog(loadingText: "");
      ResponseModel responseModel = await StadiumRepository()
          .deleteStadium(stadiumModel.stadiumReference);
      if (responseModel is SuccessfulModel) {
        setState(() {
          if (widget.userRole == UserRole.stadiumOwner) {
            _stadiumFuture = StadiumRepository().getOwnerStadiums();
          } else {
            _stadiumFuture = StadiumRepository().getTotalStadiums();
          }
          Toast.show("Stadium successfully removed!", context,
              gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        });
      } else if (responseModel is ErrorModel) {
        Toast.show(responseModel.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      }
      dismissProgressDialog();
    }
  }

  Widget _stadiumItemContent(StadiumModel stadiumModel) => Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _stadiumNameField(stadiumModel),
            SizedBox(
              height: 2.0,
            ),
            _stadiumAddressField(stadiumModel),
            SizedBox(
              height: 2.0,
            ),
            _priceAndScoreField(stadiumModel)
          ],
        ),
      );

  Widget _stadiumNameField(StadiumModel stadiumModel) => Text(
        stadiumModel.stadiumName,
        maxLines: 1,
        style: TextStyle(
            fontSize: 16.0,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: "OpenSans"),
      );

  Widget _stadiumAddressField(StadiumModel stadiumModel) => Text(
        stadiumModel.stadiumAddress,
        style: TextStyle(fontSize: 12.0, fontFamily: "OpenSans"),
      );

  Widget _priceAndScoreField(StadiumModel stadiumModel) => Row(
        children: <Widget>[
          Expanded(child: _stadiumPriceField(stadiumModel)),
          /*_stadiumScoreField()*/
        ],
      );

  Widget _stadiumPriceField(StadiumModel stadiumModel) => Text(
        "${stadiumModel.stadiumPrice} AED",
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      );

  Widget _stadiumScoreField() => Row(
        children: <Widget>[
          Icon(
            Icons.star,
            color: Colors.amber,
            size: 20,
          ),
          SizedBox(
            width: 2.0,
          ),
          Text("4.5")
        ],
      );

  Drawer _drawer() => Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Icon(
                    Icons.account_circle,
                    color: Color(0xff1a237e),
                    size: 60,
                  ),
                  FutureBuilder<String>(
                      future: getUserName(),
                      builder: (context, async) => Text(async.data ?? "",
                          style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: "OpenSans",
                              color: Color(0xff1a237e),
                              fontWeight: FontWeight.bold)))
                ],
              ),
              decoration: BoxDecoration(
                color: Color(0xFFD3CCE3),
              ),
            ),
            widget.userRole == UserRole.superAdmin
                ? ListTile(
                    title: Text('Admins',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: "OpenSans",
                            fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AdminsScreen()));
                    },
                  )
                : Container(),
            widget.userRole == UserRole.superAdmin ? Divider() : Container(),
            widget.userRole == UserRole.superAdmin ||
                    widget.userRole == UserRole.admin
                ? ListTile(
                    title: Text('Owners',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: "OpenSans",
                            fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => OwnersScreen()));
                    },
                  )
                : Container(),
            widget.userRole == UserRole.superAdmin ||
                    widget.userRole == UserRole.admin
                ? Divider()
                : Container(),
            widget.userRole == UserRole.superAdmin ||
                    widget.userRole == UserRole.admin
                ? ListTile(
                    title: Text('Customers',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: "OpenSans",
                            fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CustomersScreen()));
                    },
                  )
                : Container(),
            widget.userRole == UserRole.superAdmin ||
                widget.userRole == UserRole.admin
                ? Divider()
                : Container(),
            widget.userRole == UserRole.stadiumOwner
                ? ListTile(
                    title: Text('Transactions',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: "OpenSans",
                            fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TransactionScreen()));
                    },
                  )
                : Container(),
            widget.userRole == UserRole.stadiumOwner ? Divider() : Container(),
            ListTile(
              title: Text('Exit',
                  style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: "OpenSans",
                      color: Colors.red,
                      fontWeight: FontWeight.bold)),
              onTap: () async {
                await AuthenticateRepository().signOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false);
              },
            ),
          ],
        ),
      );
}
