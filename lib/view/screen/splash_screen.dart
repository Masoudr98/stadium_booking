import 'package:flutter/material.dart';
import 'package:stadium_booking/provider/shared_pref_provider.dart';
import 'package:stadium_booking/repository/authenticate_repository.dart';
import 'package:stadium_booking/view/screen/login_screen.dart';
import 'package:stadium_booking/view/screen/main_screen.dart';
import 'package:stadium_booking/view/screen/sign_up_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _userToken;

  @override
  void initState() {
    getUserToken().then((value) => _userToken = value);
    Future.delayed(Duration(seconds: 3), () async {
      if (_userToken == null || _userToken == "") {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (buildContext) => LoginScreen()));
      } else {
        String role = await getUserRole();
        UserRole userRole = UserRole.superAdmin;
        if(role == UserRole.admin.toString().split('.')[1]){
          userRole = UserRole.admin;
        }
        if(role == UserRole.stadiumOwner.toString().split('.')[1]){
          userRole = UserRole.stadiumOwner;
        }
        if(role == UserRole.player.toString().split('.')[1]){
          userRole = UserRole.player;
        }

        print("${userRole.toString()} $role");
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (buildContext) => MainScreen(userRole: userRole,)));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _backgroundWidget(),
      width: double.infinity,
      height: double.infinity,
    );
  }

  Widget _backgroundWidget() => Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [
              0.1,
              0.4,
              0.7
            ],
                colors: <Color>[
              Color(0xFFFFFFFF),
              Color(0xFFE9E4F0),
              Color(0xFFD3CCE3),
            ])),
      );
}
