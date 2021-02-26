import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:share/share.dart';

import 'product.dart';
import 'user.dart';
import 'purchasescreen.dart';

class CollectDonationScreen extends StatefulWidget {
  final User user;
  final Product product;

  const CollectDonationScreen({Key key, this.user, this.product})
      : super(key: key);

  @override
  _CollectDonationScreenState createState() => _CollectDonationScreenState();
}

class _CollectDonationScreenState extends State<CollectDonationScreen> {
  List salesdetails;
  List sellerInfo;
  String titlecenter = "Loading collect donation...";
  double screenHeight, screenWidth;
  int quantity = 1;
  String purchasequantity = "0";
  String beforeText= "(before collect donation)";
  String beforeText2= "(before collect donation)";
  String afterText = "(after collect donation)";
  
  bool isTransparent = true;
  bool calcDonationText = true;
  bool collectDonationText =true;
  bool sendDonationReceiptText = true;

  void initState() {
    super.initState();
    _loadSalesDetails();
  }

  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  const Color(0xFF3366FF),
                  const Color(0xFF00CCFF),
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        title: Text('Collect Donation ',
            style: TextStyle(
                fontFamily: 'Sofia',
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Colors.white)),
      ),
      body: Container(
        color: Colors.blue[800],
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            salesdetails == null
                ? Flexible(
                    child: Container(
                        child: Center(
                    child: Shimmer.fromColors(
                        baseColor: Colors.yellow[200],
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
                : Expanded(
                    child: ListView.builder(
                        itemCount:
                            salesdetails == null ? 0 : salesdetails.length,
                        itemBuilder: (context, index) {
                          return Container(
                            //color: Colors.red,
                            height: screenHeight / 2.5, //height between card
                            width: screenWidth / 2.5,
                            child: Column(
                              children: <Widget>[
                                Card(
                                    elevation: 10,
                                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(28, 10, 10, 10),
                                        child: Row(children: <Widget>[
                                          Flexible(
                                            fit: FlexFit.tight,
                                            child: Container(
                                                // color: Colors.yellow,
                                                width: screenWidth / 3,
                                                height: screenHeight / 3,
                                                child: Row(
                                                  children: <Widget>[
                                                    Flexible(
                                                      child: Column(
                                                        children: <Widget>[
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "Seller ID: ",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                              Text(
                                                                salesdetails[
                                                                        index][
                                                                    'sellerid'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 3),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "Genre: ",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                              Text(
                                                                salesdetails[
                                                                        index]
                                                                    ['genre'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 15),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "Total sales: RM ",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                              Text(
                                                               salesdetails[index]['sales'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        25),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 2),
                                                          Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              beforeText,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize: 14),
                                                            ),
                                                          ),
                                                          SizedBox(height: 20),
                                                          Opacity(
                                                            opacity: isTransparent ? 0: 1 ,
                                                            child: Container(
                                                              //put it in setState
                                                              height:
                                                                  screenHeight /
                                                                      10,
                                                              width:
                                                                  screenWidth,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerRight,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Text(
                                                                            "Total Donation: ",
                                                                            style:
                                                                                TextStyle(fontSize: 16.0)),
                                                                        Text(
                                                                            "(20%)",
                                                                            style:
                                                                                TextStyle(fontSize: 16.0)),
                                                                        Text("RM " + salesdetails[index]['donate'],
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.red,
                                                                                fontSize: 25.0)),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: <Widget>[
                                                              MaterialButton(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20.0)),
                                                                minWidth: 100,
                                                                height: 40,
                                                                child: (calcDonationText) 
                                                                    ? Text('Calculate Donation',
                                                                        style: TextStyle(
                                                                          fontSize:
                                                                              18.0,
                                                                        ))
                                                                    : (collectDonationText)
                                                                       ?  Text('Collect Donation', 
                                                                        style: TextStyle(
                                                                          fontSize:
                                                                              18.0,
                                                                        ))
                                                                    : (sendDonationReceiptText)
                                                                       ?
                                                                       Text('Send Donation Receipt', 
                                                                        style: TextStyle(
                                                                          fontSize:
                                                                              18.0,
                                                                        ))
                                                                    : null,
                                                                        
                                                                color: Colors
                                                                    .blue[500],
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                elevation: 10,
                                                                onPressed: () =>
                                                                    {
                                                                  setState(() {
                                                                    isTransparent = !isTransparent;

                                                                    if (calcDonationText == true) {  //pressed calc
                                                                      calcDonationText = false;
                                                                      collectDonationText = true;
                                                                      sendDonationReceiptText = false;
                                                                    }

                                                                    else if (collectDonationText == true) {  //pressed collect
                                                                      calcDonationText = false;
                                                                      collectDonationText = false;
                                                                      sendDonationReceiptText = true;
                                                                      beforeText = afterText;

                                                                      showCollectDialog(index);
                                                                    }

                                                                    else {                             //pressed send 
                                                                      calcDonationText = true;
                                                                      collectDonationText = false;
                                                                      sendDonationReceiptText = false;

                                                                      beforeText = beforeText2;

                                                                      String sellerReceipt = salesdetails[index]['sellerid'];
                                                                      String genreReceipt = salesdetails[index]['genre'];
                                                                      String donateValue = salesdetails[index]['donate'];
                                                                      getSellerInfo (sellerReceipt, genreReceipt, donateValue);

                                                                      
                                                                      
                                                                      
                                                                     
                                                                      
                                                                    }
                                                                  }),
                                                                },
                                                              ),
                                                              MaterialButton(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20.0)),
                                                                minWidth: 100,
                                                                height: 40,
                                                                child: Text(
                                                                    'Back',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          18.0,
                                                                    )),
                                                                color: Colors
                                                                    .blue[500],
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                elevation: 10,
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          ),
                                        ])))
                              ],
                            ),
                          );
                        }),
                  ),
          ],
        ),
      ),
    );
  }

  _loadSalesDetails() async {
    String urlLoadJobs =
        "https://yitengsze.com/a_gifhope/php/load_salesDonation.php";

    await http.post(urlLoadJobs, body: {}).then((res) {
      print(res.body);
      if (res.body.contains("nodata")) {
        setState(() {
          salesdetails = null;
          titlecenter = "No Sales Record";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          salesdetails = extractdata["sales"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  Future<void> showCollectDialog (int index) async {
     
    await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, newSetState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Collect from " + salesdetails[index]['genre'],
                style: TextStyle(
                  fontFamily: 'Bellota',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  
                ],
              ),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Yes",
                      style: TextStyle(
                        color: Colors.black,
                      )),
                  onPressed: () {

                    Navigator.pop(context);
                    collectDonation(index);
                  },
                ),
                MaterialButton(
                  child: Text("Cancel",
                      style: TextStyle(
                        color: Colors.black,
                      )),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          });
        });
  }

  collectDonation(int index) {
    try {
      String genre = salesdetails[index]["genre"];
      double sales = double.parse(salesdetails[index]["sales"]); 
      double donate = double.parse(salesdetails[index]["donate"]); 
      print("Genre: "+ genre);
      print("Sales: " + sales.toString());
      print("Donate: " + donate.toString());

      if (donate > 0) {
        ProgressDialog pr = new ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: false);

        pr.style(message: "Collecting...");
        pr.show();

        String urlLoadJobs =
            "https://yitengsze.com/a_gifhope/php/update_salesDonation.php";
        http.post(urlLoadJobs, body: {
          "sellerid": salesdetails[index]['sellerid'],
          "genre": salesdetails[index]['genre'],
          "sales": salesdetails[index]['sales'],
          "donate": salesdetails[index]['donate'],
        }).then((res) {
          print(res.body);
          if (res.body.contains("failed")) {
            Toast.show("Collection Failed", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }

          else {
            List respond = res.body.split(",");
            setState(() {
              purchasequantity = respond[1];
              _loadSalesDetails();
            });

            Toast.show("Collection Success", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
          pr.hide();
        }).catchError((err) {
          print(err);
          pr.hide();
        });

        pr.hide();
      } else {
        Toast.show("Not enough amount to collect", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } catch (e) {
      Toast.show("Collection Failed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }


Future <void> getSellerInfo (String sellerReceipt, String genreReceipt, String donateValue) async
  {

    String urlLoadJobs = "https://yitengsze.com/a_gifhope/php/get_sellerInfo.php";
     http.post(urlLoadJobs, body: {

       "sellerid": sellerReceipt,

     }).then((res) {
        print(res.body);
      if (res.body.contains("nodata")) {
        setState(() {
          sellerInfo = null;
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          sellerInfo = extractdata["seller"];

          share(context, sellerInfo, genreReceipt, donateValue);
          
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  Future <void> share (BuildContext context, List sellerInfo, String genreReceipt, String donateValue) async
  {
    Map sellerInfoMap = sellerInfo.asMap();
    String sellerID = sellerInfoMap [0]["sellerid"];
    String sellerName = sellerInfoMap [0]["name"];
    String sellerEmail = sellerInfoMap [0]["email"];
    String sellerPhone = sellerInfoMap [0]["contact"];

    final RenderBox box = context.findRenderObject();
    final String text1 = "Your sales have been deducted for 20% as the donation to Gifhope sucessfully!";
    final String text2 = " Here's your receipt \n Seller ID: $sellerID \n Name: $sellerName \n Phone: $sellerPhone \n Email: $sellerEmail \n Genre: $genreReceipt \n Amount: RM $donateValue \n THANK YOU! ";
    
    await Share.share (
      text2, 
      subject: text1,
      sharePositionOrigin: box.localToGlobal (Offset.zero) & box.size,
    );
    
  }

 
}
