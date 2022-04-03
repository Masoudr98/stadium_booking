import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:stadium_booking/constant/constant.dart';
import 'package:stadium_booking/model/response_model.dart';
import 'package:stadium_booking/provider/shared_pref_provider.dart';
import 'package:stadium_booking/repository/authenticate_repository.dart';
import 'package:stadium_booking/view/screen/main_screen.dart';
import 'package:stadium_booking/view/screen/sign_up_screen.dart';
import 'package:toast/toast.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final RoundedLoadingButtonController _loginButtonController =
      new RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _backgroundWidget(),
          _bodyWidget(),
        ],
      ),
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

  Widget _bodyWidget() => Container(
        height: double.infinity,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 120),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _titleWidget(),
              SizedBox(
                height: 30.0,
              ),
              _emailInputWidget(),
              SizedBox(
                height: 30.0,
              ),
              _passwordInputWidget(),
              /*  _forgotPasswordWidget(),*/
              _loginButton(),
              _registerButton()
            ],
          ),
        ),
      );

  Widget _titleWidget() => Text(
        "Sign In",
        style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontFamily: "OpenSans",
            fontWeight: FontWeight.bold),
      );

  Widget _emailInputWidget() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Email",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                fontStyle: FontStyle.normal,
                fontFamily: "OpenSans"),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            height: 60,
            alignment: Alignment.centerLeft,
            decoration: inputDecoration(),
            child: TextField(
              controller: _emailController,
              style: TextStyle(color: Colors.black, fontFamily: "OpenSans"),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14.0),
                  hintText: "Enter your email",
                  hintStyle: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                  ),
                  prefixIcon: Icon(Icons.email)),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
        ],
      );

  Widget _passwordInputWidget() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Password",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                fontStyle: FontStyle.normal,
                fontFamily: "OpenSans"),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            height: 60,
            alignment: Alignment.centerLeft,
            decoration: inputDecoration(),
            child: TextField(
              controller: _passwordController,
              style: TextStyle(color: Colors.black, fontFamily: "OpenSans"),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14.0),
                  hintText: "Enter your password",
                  hintStyle: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                  ),
                  prefixIcon: Icon(Icons.lock)),
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
            ),
          ),
        ],
      );

  Widget _forgotPasswordWidget() => Container(
        alignment: Alignment.centerRight,
        child: FlatButton(
          padding: EdgeInsets.all(0.0),
          child: Text(
            "Forgot password?",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "OpenSans",
                color: Colors.black54),
          ),
          onPressed: () {},
        ),
      );

  Widget _loginButton() => Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        child: RoundedLoadingButton(
          color: Colors.white,
          valueColor: Colors.purple,
          errorColor: Colors.white,
          controller: _loginButtonController,
          onPressed: () async {
            _loginButtonController.start();
            var response = await AuthenticateRepository().loginWithEmail(
                _emailController.text, _passwordController.text);

            if (response is ErrorModel) {
              _loginButtonController.error();
              Toast.show((response).message, context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
              await Future.delayed(Duration(seconds: 2));
              _loginButtonController.reset();
            } else if (response is SuccessfulModel) {
              _loginButtonController.success();

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

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => MainScreen(userRole: userRole,)) , (route)=>false);
            }
          },
          elevation: 5,
          child: Text(
            "LOGIN",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                fontFamily: "OpenSans"),
          ),
        ),
      );

  Widget _registerButton() => Container(
        alignment: Alignment.center,
        width: double.infinity,
        child: FlatButton(
          padding: EdgeInsets.all(0.0),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => SignUpScreen()));
          },
          child: Text(
            "Register?",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "OpenSans",
                fontSize: 16.0,
                color: Colors.black54),
          ),
        ),
      );
}
