import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'user.dart';

class PaymentDonateScreen extends StatefulWidget {
  final User user;
  final String donateid, val;

  PaymentDonateScreen({
    this.user,
    this.donateid,
    this.val,
  });

  @override
  _PaymentDonateScreen createState() => _PaymentDonateScreen();
}

class _PaymentDonateScreen extends State<PaymentDonateScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  User user;
  String donateid, val;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    donateid = widget.donateid;
    val = widget.val;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
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
        title: Text('Payment',
            style: TextStyle(
                fontFamily: 'Sofia',
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Colors.black)),
      ),
      body: Center(
        //be center
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: WebView(
                  initialUrl:
                      'http://yitengsze.com/a_gifhope/php/paymentDonate.php?email=' +
                          widget.user.email +
                          '&mobile=' +
                          widget.user.phone +
                          '&name=' +
                          widget.user.name +
                          '&amount=' +
                          widget.val +
                          '&orderid=' +
                          widget.donateid,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                ),
              ),
              SizedBox(height: 10.0),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                minWidth: 150,
                height: 50,
                child: Column(
                  children: <Widget>[
                    Icon(MdiIcons.share),
                    Text('Share Receipt',
                        style: TextStyle(
                          fontSize: 20.0,
                        )),
                  ],
                ),
                color: Colors.blue[500],
                textColor: Colors.white,
                elevation: 10,
                onPressed: () => {
                  share(context, user, donateid, val),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> share(BuildContext context, User user, String donateid, String val) async {
    final RenderBox box = context.findRenderObject();

    final String text1 = " Appreciation Notice";
   // final String text2 = " Your sales have been deducted for 20% as the donation to the charity events held in Gifhope mobile application. \n\n Here's your receipt \n Name: ${widget.user.name} \n Contact: ${widget.user.phone} \n Email: ${widget.user.email} \n Order id: ${widget.donateid} \n Amount: RM ${widget.val} \n THANK YOU! ";
     final String text2 =" Thanks for making the donation in the Givehope mobile application. \n\n Here's your receipt \n Name: ${widget.user.name} \n Contact: ${widget.user.phone} \n Email: ${widget.user.email} \n Order id: ${widget.donateid} \n Amount: RM ${widget.val} \n THANK YOU! ";

    await Share.share(
      text2,
      subject: text1,
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }
}
