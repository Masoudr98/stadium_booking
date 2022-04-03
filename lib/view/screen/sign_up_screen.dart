import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stadium_booking/constant/constant.dart';
import 'package:stadium_booking/model/response_model.dart';
import 'package:stadium_booking/provider/shared_pref_provider.dart';
import 'package:stadium_booking/repository/authenticate_repository.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:toast/toast.dart';

import 'main_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

enum UserRole { stadiumOwner, player, admin, superAdmin }

class _SignUpScreenState extends State<SignUpScreen> {
  UserRole _character = UserRole.player;

  final RoundedLoadingButtonController _signInButtonController =
      new RoundedLoadingButtonController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _titleWidget(),
                SizedBox(
                  height: 30.0,
                ),
                _nameInputWidget(),
                SizedBox(
                  height: 30.0,
                ),
                _emailInputWidget(),
                SizedBox(
                  height: 30.0,
                ),
                _phoneNumberInputWidget(),
                SizedBox(
                  height: 30.0,
                ),
                _passwordInputWidget(),
                SizedBox(
                  height: 30.0,
                ),
                _confirmPasswordInputWidget(),
                SizedBox(
                  height: 30.0,
                ),
                _testRadioButton(),
                _signUpButtonWidget(),
              ],
            ),
          ),
        ),
      );

  Widget _titleWidget() => Text(
        "Sign Up",
        style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontFamily: "OpenSans",
            fontWeight: FontWeight.bold),
      );

  Widget _nameInputWidget() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Name",
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
            child: TextFormField(
              validator: (String value) {
                if (value.trim().isEmpty) {
                  return 'Please enter name';
                }
                return null;
              },
              controller: _nameController,
              style: TextStyle(color: Colors.black, fontFamily: "OpenSans"),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14.0),
                  hintText: "Enter your name",
                  hintStyle: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                  ),
                  prefixIcon: Icon(Icons.person)),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
        ],
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
            child: TextFormField(
              validator: (String value) {
                if (value.trim().isEmpty) {
                  return 'Please enter email';
                }
                return null;
              },
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

  Widget _phoneNumberInputWidget() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Phone Number",
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
            child: TextFormField(
              validator: (String value) {
                if (value.trim().isEmpty) {
                  return 'Please enter you\'r phone number';
                }
                return null;
              },
              controller: _phoneNumberController,
              style: TextStyle(color: Colors.black, fontFamily: "OpenSans"),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14.0),
                  hintText: "Enter your phone number",
                  hintStyle: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                  ),
                  prefixIcon: Icon(Icons.phone)),
              keyboardType: TextInputType.number,
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
            child: TextFormField(
              validator: (String value) {
                if (value.trim().isEmpty) {
                  return 'Please enter password';
                }
                return null;
              },
              controller: _passwordController,
              obscureText: true,
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
              keyboardType: TextInputType.emailAddress,
            ),
          ),
        ],
      );

  Widget _confirmPasswordInputWidget() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Confirm Password",
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
            child: TextFormField(
              validator: (String value) {
                if (value.trim().isEmpty) {
                  return 'Please enter confirm password';
                }
                return null;
              },
              controller: _confirmPasswordController,
              obscureText: true,
              style: TextStyle(color: Colors.black, fontFamily: "OpenSans"),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14.0),
                  hintText: "Enter your confirm password",
                  hintStyle: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                  ),
                  prefixIcon: Icon(Icons.lock)),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
        ],
      );

  Widget _signUpButtonWidget() => Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        child: RoundedLoadingButton(
          color: Colors.white,
          valueColor: Colors.purple,
          errorColor: Colors.white,
          controller: _signInButtonController,
          onPressed: () async {
            if (!_formKey.currentState.validate()) {
              _signInButtonController.reset();
              return;
            }
            _signInButtonController.start();
            if (_passwordController.text != _confirmPasswordController.text) {
              _signInButtonController.error();
              Toast.show("Password and confirmation are not the same", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
              await Future.delayed(Duration(seconds: 2));
              _signInButtonController.reset();
              return;
            }
            var response = await AuthenticateRepository().registerWithEmail(
                _emailController.text,
                _passwordController.text,
                _nameController.text,
                _phoneNumberController.text,
                _character.toString().split('.').last);

            if (response is ErrorModel) {
              _signInButtonController.error();
              Toast.show((response).message, context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
              await Future.delayed(Duration(seconds: 2));
              _signInButtonController.reset();
            } else {
              _signInButtonController.success();
              String role = await getUserRole();
              UserRole userRole = UserRole.superAdmin;
              if (role == UserRole.admin.toString().split('.')[1]) {
                userRole = UserRole.admin;
              }
              if (role == UserRole.stadiumOwner.toString().split('.')[1]) {
                userRole = UserRole.stadiumOwner;
              }
              if (role == UserRole.player.toString().split('.')[1]) {
                userRole = UserRole.player;
              }
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => MainScreen(
                            userRole: userRole,
                          )),
                  (pageRote) => false);
            }
          },
          elevation: 5,
          child: Text(
            "REGISTER",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                fontFamily: "OpenSans"),
          ),
        ),
      );

  Widget _testRadioButton() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Register As",
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
                _character = UserRole.player;
              });
            },
            title: const Text(
              'Player',
              style: TextStyle(
                  fontFamily: "OpenSans",
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold),
            ),
            leading: Radio(
              value: UserRole.player,
              groupValue: _character,
              onChanged: (UserRole value) {
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text(
              'Stadium Owner',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "OpenSans",
                  fontSize: 14.0),
            ),
            onTap: () {
              setState(() {
                _character = UserRole.stadiumOwner;
              });
            },
            leading: Radio(
              value: UserRole.stadiumOwner,
              groupValue: _character,
              onChanged: (UserRole value) {
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
        ],
      );
}
