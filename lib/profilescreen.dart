import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'loginscreen.dart';
import 'mainscreen.dart';
import 'registerscreen.dart';
import 'user.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:recase/recase.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({Key key, this.user}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double screenHeight, screenWidth;
  final dateFormat = new DateFormat('yyyy-MM-dd HH:mm:ss');
  var parsedDate;
  File _image;
  String pathAsset = "assets/images/camera.jpg";

  @override
  void initState() {
    super.initState();
    print("Now: Profile Screen");
  }

  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    parsedDate = DateTime.parse(widget.user.datereg);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  Colors.deepOrange[200],
                  Colors.red[100],
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        title: Text('My Profile',
            style: TextStyle(
                fontFamily: 'Sofia',
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Colors.black)),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainScreen(
                            user: widget.user,
                          )));
            }),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 6),
            Card(
              color: Colors.yellow[200],
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.fromLTRB(5, 10, 5, 20),
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: _takePicture,
                          child: Container(
                            height: screenHeight / 4.8,
                            width: screenWidth / 3.5,
                            decoration: new BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(25),
                              image: DecorationImage(
                                image: _image == null
                                    ? CachedNetworkImageProvider(
                                            "http://yitengsze.com/a_gifhope/profileimages/${widget.user.email}.jpg",
                                      )
                                    : FileImage(_image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            child: Table(
                              defaultColumnWidth: FlexColumnWidth(2),
                              columnWidths: {
                                0: FlexColumnWidth(4),
                                1: FlexColumnWidth(7),
                              },
                              children: [
                                TableRow(
                                  children: [
                                    TableCell(
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            height: 20,
                                            child: Text("Name:",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)))),
                                    TableCell(
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            height: 20,
                                            child: Text(widget.user.name,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)))),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    TableCell(
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            height: 20,
                                            child: Text("Email:",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)))),
                                    TableCell(
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            height: 20,
                                            child: Text(widget.user.email,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)))),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    TableCell(
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            height: 20,
                                            child: Text("Phone: ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)))),
                                    TableCell(
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            height: 20,
                                            child: Text(widget.user.phone,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)))),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    TableCell(
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            height: 20,
                                            child: Text("Register date: ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)))),
                                    TableCell(
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            height: 20,
                                            child: Text(
                                                dateFormat.format(parsedDate),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Divider(
                      height: 2,
                      color: Colors.black,
                      thickness: 3,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.red[100],
              child: Center(
                  child: Text(
                "MANAGE YOUR PROFILE",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              )),
            ),
            Divider(
              height: 2,
              color: Colors.black,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(10),
                shrinkWrap: true,
                children: <Widget>[
                  MaterialButton(
                      elevation: 10,
                      height: 40,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      onPressed: changeName,
                      color: Colors.yellow[200],
                      child: Text("Change Your Name",
                          style: TextStyle(
                            fontSize: 18,
                          ))),
                  SizedBox(height: 15),
                  MaterialButton(
                      elevation: 10,
                      height: 40,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      onPressed: _changePasswordDialog,
                      color: Colors.yellow[200],
                      child: Text("Change Your Password",
                          style: TextStyle(
                            fontSize: 18,
                          ))),
                  SizedBox(height: 15),
                  MaterialButton(
                      elevation: 10,
                      height: 40,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      onPressed: changePhone,
                      color: Colors.yellow[200],
                      child: Text("Change Your Phone",
                          style: TextStyle(
                            fontSize: 18,
                          ))),
                  SizedBox(height: 15),
                  MaterialButton(
                      elevation: 10,
                      height: 40,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      onPressed: goLogin,
                      color: Colors.yellow[200],
                      child: Text("Go Login Screen",
                          style: TextStyle(
                            fontSize: 18,
                          ))),
                  SizedBox(height: 15),
                  MaterialButton(
                      elevation: 10,
                      height: 40,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      onPressed: goRegister,
                      color: Colors.yellow[200],
                      child: Text("Go Register New Account",
                          style: TextStyle(
                            fontSize: 18,
                          ))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _takePicture() async {
    if (widget.user.email.contains("unregistered")) {
      Toast.show("Please register to use this feature", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    _image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 400, maxWidth: 300);

    if (_image == null) {
      Toast.show("Image is required to take", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      String base64Image = base64Encode(_image.readAsBytesSync());
      print(base64Image);
      http.post("https://yitengsze.com/a_gifhope/php/upload_image.php", body: {
        "encoded_string": base64Image,
        "email": widget.user.email,
      }).then((res) {
        print(res.body);
        if (res.body.contains("success")) {
          setState(() {
            DefaultCacheManager manager = new DefaultCacheManager();
            manager.emptyCache();
          });
        } else {
          Toast.show("Failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
      });

      await DefaultCacheManager().removeFile(
          'http://yitengsze.com/a_gifhope/profileimages/${widget.user.email}.jpg');
    }
  }

  void changeName() {
    if (widget.user.email.contains("unregistered")) {
      Toast.show("Please register to use this feature", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    TextEditingController nameController = TextEditingController();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text("Change Name?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Bellota',
                )),
            content: new TextField(
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  icon: Icon(Icons.person, color: Colors.blue[200]),
                )),
            actions: <Widget>[
              new FlatButton(
                  child: new Text("Yes", style: TextStyle(color: Colors.black)),
                  onPressed: () => updateName(nameController.text.toString())),
              new FlatButton(
                  child: new Text("No", style: TextStyle(color: Colors.black)),
                  onPressed: () => {Navigator.of(context).pop()}),
            ],
          );
        });
  }

  updateName(String name) {
    if (widget.user.email.contains("unregistered")) {
      Toast.show("Please register to use this feature", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (name == "" || name == null) {
      Toast.show("Please enter your new name", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    ReCase rc = new ReCase(name);
    String rcName = rc.titleCase.toString();
    print(rcName); //capitalize title name
    http.post("https://yitengsze.com/a_gifhope/php/update_profile.php", body: {
      "email": widget.user.email,
      "name": rcName,
    }).then((res) {
      if (res.body.contains("success")) {
        print("Changed");
        setState(() {
          widget.user.name = rc.titleCase;
        });
        Toast.show("Name changed successfully", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      } else {
        Toast.show("Name changed failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _changePasswordDialog() {
    if (widget.user.email.contains("unregistered")) {
      Toast.show("Please register to use this feature", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    TextEditingController oldPassController = TextEditingController();
    TextEditingController newPassController = TextEditingController();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text("Change Password?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Bellota',
                )),
            content: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black),
                    controller: oldPassController,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Old Password',
                      icon: Icon(Icons.lock, color: Colors.blue[200]),
                    )),
                TextField(
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    controller: newPassController,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      icon: Icon(Icons.lock, color: Colors.blue[200]),
                    )),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: new Text("Yes", style: TextStyle(color: Colors.black)),
                  onPressed: () => updatePassword(
                      oldPassController.text, newPassController.text)),
              new FlatButton(
                  child: new Text("No", style: TextStyle(color: Colors.black)),
                  onPressed: () => {Navigator.of(context).pop()}),
            ],
          );
        });
  }

  updatePassword(String oldPass, String newPass) {
    if (oldPass == "" || newPass == "") {
      Toast.show("Both password are required", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (oldPass.length < 4 || newPass.length < 4) {
      Toast.show("Password length must be 5 digits above", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    http.post("https://yitengsze.com/a_gifhope/php/update_profile.php", body: {
      "email": widget.user.email,
      "oldpassword": oldPass,
      "newpassword": newPass,
    }).then((res) {
      print(res.body);
      if (res.body.contains("success")) {
        print("Changed");
        setState(() {
          widget.user.password = newPass;
        });
        Toast.show("Password changed successfully", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      } else {
        Toast.show("Password changed failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
    }).catchError((err) {
      print(err);
    });
  }

  void changePhone() {
    if (widget.user.email.contains("unregistered")) {
      Toast.show("Please register to use this feature", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    TextEditingController phoneController = TextEditingController();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text("Change Phone Number?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Bellota',
                )),
            content: new TextField(
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'New Phone Number',
                icon: Icon(Icons.phone_iphone, color: Colors.blue[200]),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: new Text("Yes", style: TextStyle(color: Colors.black)),
                  onPressed: () => updatePhone(phoneController.text)),
              new FlatButton(
                  child: new Text("No", style: TextStyle(color: Colors.black)),
                  onPressed: () => {Navigator.of(context).pop()}),
            ],
          );
        });
  }

updatePhone(String phone) {
    if (phone == "" || phone == null) {
      Toast.show("Please enter your new phone number", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if ( phone.length < 9) {
      Toast.show("Please enter more than 9 digits", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    http.post("https://yitengsze.com/a_gifhope/php/update_profile.php", body: {
      "email": widget.user.email,
      "phone": phone,
    }).then((res) {
      if (res.body.contains("success")) {
        print("Changed");
        setState(() {
          widget.user.phone = phone;
        });
        Toast.show("Phone number changed successfully", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      } else {
        Toast.show("Phone number changed failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
    }).catchError((err) {
      print(err);
    });
  }

  void goLogin() {
    print(widget.user.name);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text("Go To Login Page?",
                  style: TextStyle(
                    fontFamily: 'Bellota',
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )),
              content: new Text("Are you sure?",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                  )),
              actions: <Widget>[
                new FlatButton(
                    child: new Text("Yes",
                        style: TextStyle(fontSize: 16.0, color: Colors.black)),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  LoginScreen()));
                    }),
                new FlatButton(
                    child: new Text("No",
                        style: TextStyle(fontSize: 16.0, color: Colors.black)),
                    onPressed: () => {Navigator.of(context).pop()})
              ]);
        });
  }

  void goRegister() {
    print(widget.user.name);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text("Go Register New Account?",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Bellota',
                  )),
              content: new Text("Are you sure?",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  )),
              actions: <Widget>[
                new FlatButton(
                    child:
                        new Text("Yes", style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  RegisterScreen()));
                    }),
                new FlatButton(
                    child:
                        new Text("No", style: TextStyle(color: Colors.black)),
                    onPressed: () => {Navigator.of(context).pop()})
              ]);
        });
  }
}
