import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import 'donate.dart';
import 'donationdetailsscreen.dart';
import 'user.dart';

class DonationHistoryScreen extends StatefulWidget {
  final User user;

  const DonationHistoryScreen({Key key, this.user}) : super(key: key);

  @override
  _DonationHistoryScreenState createState() => _DonationHistoryScreenState();
}

class _DonationHistoryScreenState extends State<DonationHistoryScreen> {
  List paymentdata;
  List bookdetails;

  String titlecenter = "Loading donation history...";
  final dateFormat = new DateFormat('dd-MM-yyyy hh:mm a');
  var parsedDate;
  double screenHeight, screenWidth;

  void initState() {
    super.initState();
    _loadPaymentDonateHistory();
  }

  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  const Color(0xFFFDD835),
                  const Color(0xFFFBC02D),
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        title: Text('Donation History',
            style: TextStyle(
                fontFamily: 'Sofia',
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Colors.black)),
      ),
      body: Center(
        child: Container(
          color: Colors.amber[100],
          child: Column(
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40, width: 20,),

                  Expanded(
                    flex: 5,
                    child: RichText(
                      text: TextSpan(
                        text: "No.",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          fontSize: 18,
                          color: Colors.black
                        )
                      ),
                      ),
                  ),
                  Expanded(
                    flex: 22,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Donate ID",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          fontSize: 18,
                          color: Colors.black
                        )
                      ),
                      ),
                  ),

                 Expanded(
                    flex: 13,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Total (RM)",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          fontSize: 18,
                          color: Colors.black
                        )
                      ),
                      ),
                  ),

                  Expanded(
                    flex: 21,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Bill ID",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          fontSize: 18,
                          color: Colors.black
                        )
                      ),
                      ),
                  ),
                ],
              ),
            Padding(
              padding: EdgeInsets.all(10)
            ),
            paymentdata == null
                ? Flexible(
                    child: Container(
                        child: Center(
                    child: Shimmer.fromColors(
                                  baseColor: Colors.black,
                                  highlightColor: Colors.grey,
                                  child: Text(
                                    titlecenter,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Mogra',
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.bold),
                                  )),
                  )))
                : Expanded(
                    child: ListView.builder(
                        itemCount: paymentdata == null ? 0 : paymentdata.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: EdgeInsets.fromLTRB(15, 1, 15, 1),
                              child: InkResponse( 
                                focusColor: Colors.amber[100],
                                hoverColor: Colors.amber[100],
                                highlightColor: Colors.blue[300],
                                borderRadius: BorderRadius.circular(20.0),
                                onTap: () => setState(() {

                                  loadDonateDetails(index);
                                }),
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Container(
                                    color: Colors.amber[600],
                                    child: Card(
                                      elevation: 10,
                                      child: Row( 
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child:
                                                Text((index + 1).toString() + ".",
                                                   textAlign: TextAlign.center,
                                                   style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 17

                                                    )),
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[

                                                Text(paymentdata[index]['donateid'],
                                                style: TextStyle(
                                                          fontSize: 17
                                                        )),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  "RM " +
                                                      paymentdata[index]['total'],
                                                      style: TextStyle(
                                                          fontSize: 17
                                                        )
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Text(paymentdata[index]['billid'],
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 18
                                                        )),
                                                  ],
                                                ),
                                                Text(dateFormat
                                                    .format(DateTime.parse(
                                                  paymentdata[index]['date'],
                                                ))),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ));
                        }),
                  ),
          ],
        ),

        ),
        
      ),
    );
  }

  // check got previous pymt record or not
  Future<void> _loadPaymentDonateHistory() async {
    String urlLoadJobs =
        "https://yitengsze.com/a_gifhope/php/load_paymentDonateHistory.php";

    await http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      if (res.body.contains("nodata")) {
        setState(() {
          paymentdata = null;
          titlecenter = "No Donation Record";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          paymentdata = extractdata["paymentdonate"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  loadDonateDetails(int index) {
    Donate donate = new Donate(
      billid: paymentdata[index]['billid'],
      donateid: paymentdata[index]['donateid'],
      total: paymentdata[index]['total'],
      dateDonate: paymentdata[index]['date'],
    );

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => DonationDetailScreen(
                  user: widget.user,
                  donate: donate,
                )));
  }
}
