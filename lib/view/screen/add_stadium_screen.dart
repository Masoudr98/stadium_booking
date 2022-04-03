import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:stadium_booking/constant/constant.dart';
import 'package:stadium_booking/model/response_model.dart';
import 'package:stadium_booking/model/stadium_model.dart';
import 'package:stadium_booking/provider/shared_pref_provider.dart';
import 'package:stadium_booking/repository/authenticate_repository.dart';
import 'package:stadium_booking/repository/stadium_repository.dart';
import 'package:toast/toast.dart';

class AddStadiumScreen extends StatefulWidget {
  @override
  _AddStadiumScreenState createState() => _AddStadiumScreenState();
}

class _AddStadiumScreenState extends State<AddStadiumScreen> {
  File _pickedImageAddress;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  final RoundedLoadingButtonController _addButtonController =
      new RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Stadium"),
      ),
      body: Stack(
        children: [_backgroundWidget(), _bodyWidget()],
      ),
    );
  }

  Widget _backgroundWidget() => Container(
        color: Color(0xFFE9E4F0).withOpacity(0.5),
      );

  Widget _bodyWidget() => SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              _stadiumImage(),
              _stadiumName(),
              _stadiumAddress(),
              _priceWidget(),
              _submitWidget()
            ],
          ),
        ),
      );

  Widget _stadiumName() => Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Stadium Name",
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
                controller: _nameController,
                style: TextStyle(color: Colors.black, fontFamily: "OpenSans"),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14.0),
                    hintText: "Enter your Stadium name",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.normal,
                    ),
                    prefixIcon: Icon(Icons.location_city)),
                keyboardType: TextInputType.text,
              ),
            ),
          ],
        ),
      );

  Widget _stadiumAddress() => Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Stadium Address",
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
                controller: _addressController,
                style: TextStyle(color: Colors.black, fontFamily: "OpenSans"),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14.0),
                    hintText: "Enter your Stadium address",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.normal,
                    ),
                    prefixIcon: Icon(Icons.location_pin)),
                keyboardType: TextInputType.text,
              ),
            ),
          ],
        ),
      );

  Widget _priceWidget() => Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Price",
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
                controller: _priceController,
                style: TextStyle(color: Colors.black, fontFamily: "OpenSans"),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14.0),
                    hintText: "Enter your reservation price",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.normal,
                    ),
                    prefixIcon: Icon(Icons.money),
                    suffixIcon: Container(
                      height: double.minPositive,
                      width: double.minPositive,
                      padding: EdgeInsets.only(top: 8.0),
                      margin: EdgeInsets.only(right: 16.0),
                      alignment: Alignment.center,
                      child: Text(
                        "AED",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    )),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      );

  Widget _stadiumImage() => InkWell(
        onTap: () {
          getImage();
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(15.0)),
              margin: EdgeInsets.all(16.0),
              height: 160,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: _pickedImageAddress != null
                    ? Image.file(_pickedImageAddress,
                        fit: BoxFit.cover, width: double.infinity)
                    : Container(),
              ),
            ),
            Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black87),
                  child: Icon(
                    Icons.add_photo_alternate,
                    color: Colors.white,
                  ),
                ))
          ],
        ),
      );

  Widget _chooseDateWidget() => Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Date",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
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
              child: InkWell(
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.date_range,
                          color: Colors.blueGrey,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text("----/--/--"),
                      ],
                    )),
              ),
            ),
          ],
        ),
      );

  Widget _timeWidget() => Container(
        margin: EdgeInsets.all(16.0),
        width: double.infinity,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(child: _startTimeWidget()),
            SizedBox(
              width: 8,
            ),
            Expanded(child: _endTimeWidget())
          ],
        ),
      );

  Widget _startTimeWidget() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Start Time",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
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
            child: InkWell(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.timelapse_sharp,
                        color: Colors.blueGrey,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text("--:--"),
                    ],
                  )),
            ),
          ),
        ],
      );

  Widget _endTimeWidget() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "End Time",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
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
            child: InkWell(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.timelapse_sharp,
                        color: Colors.blueGrey,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text("--:--"),
                    ],
                  )),
            ),
          ),
        ],
      );

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    int length = await image.length();
    double imageLen = (length / 1024) / 1024;

    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    final myDir = new Directory(appDocDirectory.path + '/stadium_booking');
    await myDir.create(recursive: true);
    if (imageLen > 2.0) {
      myDir.exists().then((isThere) async {
        if (isThere) {
          _pickedImageAddress =
              await compressImage(image, myDir.path, imageLen);

          setState(() {});
        } else {}
      });
    } else {
      setState(() {
        _pickedImageAddress = image;
      });
    }
  }

  Future<File> compressImage(
      File file, String targetPath, double imageLen) async {
    String imageName =
        "IMG-" + new DateFormat("yyyy-MM-dd-hh-mm-ss").format(DateTime.now());
    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath + "/$imageName.${file.path.split(".").last}",
        quality: ((2 / imageLen) * 100).toInt());
    return result;
  }

  Widget _submitWidget() => Container(
        padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
        width: double.infinity,
        child: RoundedLoadingButton(
          color: Colors.white,
          valueColor: Colors.purple,
          errorColor: Colors.white,
          controller: _addButtonController,
          onPressed: () async {
            if (_pickedImageAddress == null) {
              _addButtonController.reset();
              Toast.show("Choose stadium picture", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
              return;
            }

            if (_nameController.text.isEmpty) {
              _addButtonController.reset();
              Toast.show("Enter stadium name", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
              return;
            }

            if (_priceController.text.isEmpty) {
              _addButtonController.reset();
              Toast.show("Enter stadium price", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
              return;
            }

            if (_addressController.text.isEmpty) {
              _addButtonController.reset();
              Toast.show("Enter stadium address", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
              return;
            }
            _addButtonController.start();
            var response = await StadiumRepository().addStadium(StadiumModel(
                stadiumReference: "",
                ownerId: await getUserToken(),
                createAt: DateTime.now().toString(),
                stadiumName: _nameController.text,
                stadiumPic: _pickedImageAddress.path,
                stadiumPrice: _priceController.text,
                stadiumAddress: _addressController.text));
            if (response is ErrorModel) {
              _addButtonController.error();
              Future.delayed(Duration(seconds: 2), () {
                _addButtonController.reset();
              });
              Toast.show(response.message, context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
            } else if (response is SuccessfulModel) {
              _addButtonController.success();
              Toast.show("Stadium successfully added", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
              Future.delayed(Duration(seconds: 2), () {
                Navigator.pop(context, response.data);
              });
            }
          },
          elevation: 5,
          child: Text(
            "SUBMIT",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                fontFamily: "OpenSans"),
          ),
        ),
      );
}
