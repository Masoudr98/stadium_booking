import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:stadium_booking/model/response_model.dart';
import 'package:stadium_booking/model/user_model.dart';
import 'package:stadium_booking/repository/admin_repository.dart';
import 'package:stadium_booking/view/dialog/delete_dialog.dart';
import 'package:stadium_booking/view/screen/sign_up_screen.dart';
import 'package:toast/toast.dart';

class CustomersScreen extends StatefulWidget {
  @override
  _CustomersScreenState createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  List _customerList = List();

  Future _playerFuture;
  @override
  void initState() {
    _playerFuture  = AdminRepository().getUsers(UserRole.player);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Customers",
          style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[_backgroundWidget(), _bodyWidget()],
        ),
      ),
    );
  }

  Widget _backgroundWidget() => Container(
        color: Color(0xFFE9E4F0).withOpacity(0.5),
      );

  Widget _bodyWidget() => Container(
        child: FutureBuilder<ResponseModel>(
          future: _playerFuture,
          builder: (context, snapshot) {
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
              _customerList.clear();
              querySnapshot.docs.forEach((element) {
                UserModel userModel =
                    UserModel.fromJson(element.data(), element.reference.id);
                _customerList.add(userModel);
              });
            }
            return ListView.separated(
              itemCount: _customerList.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) =>
                  _ownerItemWidget(_customerList[index]),
              separatorBuilder: (BuildContext context, int index) => Divider(),
            );
          },
        ),
      );

  Widget _ownerItemWidget(UserModel userModel) => ListTile(
        leading: Icon(Icons.person),
        onTap: () {
          _showDialog(userModel);
        },
        title: Text(userModel.name,
            style: TextStyle(color: Colors.black, fontFamily: "OpenSans")),
        subtitle: Text(userModel.id,
            style: TextStyle(color: Colors.black, fontFamily: "OpenSans")),
      );

  Future<void> _showDialog(UserModel userModel) async {
    Dialog dialog = Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: DeleteDialog(
          title: "Delete Customer",
          content: "Are you sure you want to delete ${userModel.name}?",
          onDonePress: () {},
        ));

    var result = await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) => dialog);

    if(result == "Yes"){
      showProgressDialog(loadingText: "");
      ResponseModel responseModel =
      await AdminRepository().deleteUser(userModel.id);
      dismissProgressDialog();
      if (responseModel is SuccessfulModel) {
        setState(() {
          _playerFuture = AdminRepository().getUsers(UserRole.player);
        });
      }
      if (responseModel is ErrorModel) {
        Toast.show(responseModel.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      }
    }
  }
}
