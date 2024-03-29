import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gifhope/product.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toast/toast.dart';
import 'package:gifhope/user.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'product.dart';

class SellerDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  final User user;

  SellerDetailsScreen({Key key, this.product, this.user}) : super(key: key);

  @override
  _SellerDetailsScreenState createState() => _SellerDetailsScreenState();
}

class _SellerDetailsScreenState extends State<SellerDetailsScreen> {
  List productdata;
  String titlecenter = "Loading product...";
  int numOfItem = 1;
  double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    Size size = MediaQuery.of(context).size;
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
          title: Text('Details',
              style: TextStyle(
                  fontFamily: 'Sofia',
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  color: Colors.black)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: size.height,
                child: Stack(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                            top: size.height * 0.3), //stack height
                        padding: EdgeInsets.only(
                            top: size.height * 0.05), //content height
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                              child: Column(children: <Widget>[
                                SizedBox(height: 14),
                                Text(
                                  "Description",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      decorationStyle:
                                          TextDecorationStyle.double,
                                      height: 1.8,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.product["description"],
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(height: 1.8, fontSize: 15),
                                ),
                              ]),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 30, 20, 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  buildOutlineButton(
                                    icon: Icons.remove,
                                    press: () {
                                      if (numOfItem > 1) {
                                        setState(() {
                                          numOfItem--;
                                        });
                                      }
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 10, 20, 10),
                                    child: Text(
                                      // if our item is less  then 10 then  it shows 01 02 like that
                                      numOfItem.toString().padLeft(2, "0"),
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                  ),
                                  buildOutlineButton(
                                      icon: Icons.add,
                                      press: () {
                                        setState(() {
                                          numOfItem++;
                                        });
                                      }),
                                  SizedBox(width: 25),
                                  Icon(MdiIcons.checkDecagram,
                                      color: Colors.blue),
                                  Text(
                                    " Qty Available: " +
                                        widget.product["quantity"],
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    productdata == null
                        ? Flexible(
                            child: Container(
                                color: Colors.red[100],
                                child: Center(
                                  child: Shimmer.fromColors(
                                      baseColor: Colors.black,
                                      highlightColor: Colors.white,
                                      child: Text(
                                        titlecenter,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Mogra',
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold),
                                      )),
                                )))
                        : Container(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 20, 0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    widget.product["genre"],
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  Text(
                                    widget.product["name"],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0.5, 0, 2,
                                        10), //padding of row price & pic
                                    child: Row(
                                      children: <Widget>[
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: "Price: ",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                              TextSpan(
                                                text:
                                                    "\RM${widget.product["price"]}",
                                                style: TextStyle(
                                                  fontSize: 23,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        Container(
                                          height: screenWidth / 1.9,
                                          width: screenWidth / 2.0,
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 5, 0, 5), //padding of pic

                                            child: ClipRect(
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl:
                                                    "http://yitengsze.com/a_gifhope/productimages/${widget.product["id"]}.jpg",
                                                placeholder: (context, url) =>
                                                    new CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        new Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void _loadProduct() async {
    String urlLoadJobs = "https://yitengsze.com/a_gifhope/php/load_product.php";
    await http.post(urlLoadJobs, body: {}).then((res) {
      if (res.body.contains("nodata")) {
        print(res.body);

        titlecenter = "No product found";
        setState(() {
          productdata = null;
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          productdata = extractdata["product"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  SizedBox buildOutlineButton({IconData icon, Function press}) {
    return SizedBox(
      width: 40,
      height: 32,
      child: OutlineButton(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        onPressed: press,
        child: Icon(icon),
      ),
    );
  }
}
