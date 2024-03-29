import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shimmer/shimmer.dart';

import 'sellerdetailsscreen.dart';
import 'user.dart';
import 'updateproduct.dart';
import 'newproduct.dart';
import 'product.dart';
import 'report_donate.dart';
import 'report_sales.dart';
class AdminProduct extends StatefulWidget {
  final User user;

  const AdminProduct({Key key, this.user}) : super(key: key);

  @override
  _AdminProductState createState() => _AdminProductState();
}

class _AdminProductState extends State<AdminProduct> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  List productdata;
  int curnumber = 1;
  double screenHeight, screenWidth;
  bool _visible = false;
  String curtype = "Recent";
  String cartquantity = "0";
  int quantity = 1;
  var _tapPosition;
  String titlecenter = "Loading product...";

  @override
  void initState() {
    super.initState();
    _loadData();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    TextEditingController _productController = new TextEditingController();

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
        title: Text('Manage Product Info',
            style: TextStyle(
                fontFamily: 'Sofia',
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                color: Colors.black)),
        actions: <Widget>[
          IconButton(
              icon: _visible
                  ? new Icon(Icons.expand_more)
                  : new Icon(Icons.expand_less),
              onPressed: () {
                setState(() {
                  if (_visible) {
                    _visible = false;
                  } else {
                    _visible = true;
                  }
                });
              }),
        ],
      ),
      body: RefreshIndicator(
          key: refreshKey,
          color: Colors.red,
          onRefresh: () async {
            await refreshList();
          },
          child: Container(
            color: Colors.red[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Visibility(
                  visible: _visible,
                  child: Card(
                    elevation: 10,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: genreDropDownList(),
                      ),
                    ),
                  ),
                ),

                Visibility(
                  visible: _visible,
                  child: Card(
                    elevation: 5,
                    child: Container(
                      height: screenHeight / 12,
                      margin: EdgeInsets.fromLTRB(20, 2, 20, 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Flexible(
                            child: Container(
                              height: 30,
                              child: TextField(
                                style: TextStyle(color: Colors.black),
                                autofocus: false,
                                controller: _productController,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.search),
                                    border: OutlineInputBorder()),
                              ),
                            ),
                          ),
                          Flexible(
                            child: MaterialButton(
                              color: Colors.yellow[200],
                              onPressed: () =>
                                  {_sortItembyName(_productController.text)},
                              elevation: 5,
                              child: Text(
                                "Search ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Text(
                  curtype,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
//grid
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
                    : Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: (screenWidth / screenHeight) / 0.9,
                          children: List.generate(productdata.length, (index) {
                            return Container(
                              child: InkWell(
                                onTap: () => _showPopUpMenu(index),
                                onTapDown: _storePosition, //menu position
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                    elevation: 10,
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: GestureDetector(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: screenWidth / 2.5,
                                              width: screenWidth / 2.5,
                                              child: ClipOval(
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.fill,
                                                  imageUrl:
                                                      "http://yitengsze.com/a_gifhope/productimages/${productdata[index]['id']}.jpg",
                                                  placeholder: (context, url) =>
                                                      new CircularProgressIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          new Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              productdata[index]['name'],
                                              maxLines: 3,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "-----------------------------",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.tag),
                                                Text(
                                                  " Genre: ",
                                                  maxLines: 3,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.tag),
                                                Text(
                                                  " " +
                                                      productdata[index]
                                                          ['genre'],
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(MdiIcons.checkDecagram,
                                                    color: Colors.blue),
                                                Text(" Qty available: " +
                                                    productdata[index]
                                                        ['quantity']),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.attach_money,
                                                  color: Colors.black,
                                                ),
                                                Text(" Price: RM " +
                                                    productdata[index]['price'])
                                              ],
                                            ),
                                          ],
                                        ),
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SellerDetailsScreen(
                                                product: productdata[index],
                                                user: widget.user,
                                              ),
                                            )),
                                      ),
                                    )),
                              ),
                            );
                          }),
                        ),
                      ),
              ],
            ),
          )),
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.yellow,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(color: Colors.black),
        children: [
          SpeedDialChild(
            child: Icon(Icons.add_to_drive, color: Colors.black),
            backgroundColor: Colors.yellow,
            label: "New Product Info",
            labelBackgroundColor: Colors.yellow,
            onTap: _createNewProduct,
          ),
          SpeedDialChild(
            child: Icon(Icons.request_page, color: Colors.black),
            backgroundColor: Colors.yellow,
            label: "View Sales Report",
            labelBackgroundColor: Colors.yellow,
            onTap: _viewSalesReport, 
          ),
          SpeedDialChild(
            child: Icon(MdiIcons.scriptText, color: Colors.black),
            backgroundColor: Colors.yellow,
            label: "View Donation Report",
            labelBackgroundColor: Colors.yellow,
            onTap: _viewDonateReport, 
          ),
        ],
      ),
    );
  }

  void _loadData() {
    String urlLoadJobs = "https://yitengsze.com/a_gifhope/php/load_product.php";
    http.post(urlLoadJobs, body: {}).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        productdata = extractdata["product"];
        cartquantity = widget.user.quantity;
      });
    }).catchError((err) {
      print(err);
    });
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    _loadData();
    return null;
  }

  void _sortItem(String genre) {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs =
          "https://yitengsze.com/a_gifhope/php/load_product.php";
      http.post(urlLoadJobs, body: {
        "genre": genre,
      }).then((res) {
        print(res.body);
        if (res.body.contains("nodata")) { 
          setState(() {
            productdata = null;
            curtype = genre;
          });
        } else {
          setState(() {
            curtype = genre;
            var extractdata = json.decode(res.body);
            productdata = extractdata["product"];
            FocusScope.of(context).requestFocus(new FocusNode());
            pr.hide();
          });
        }
      }).catchError((err) {
        print(err);
        pr.hide();
      });
      pr.hide();
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _sortItembyName(String productname) {
    try {
      print(productname);
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs =
          "https://yitengsze.com/a_gifhope/php/load_product.php";
      http
          .post(urlLoadJobs, body: {
            "name": productname.toString(),
          })
          .timeout(const Duration(seconds: 3))
          .then((res) {
            print(res.body);
            if (res.body.contains("nodata")) {
              Toast.show("Product not found", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              pr.hide();
              setState(() {
                titlecenter = "No product found";
                curtype = "Search for" + "'" + productname + "'";
                productname = null;
              });
              FocusScope.of(context).requestFocus(new FocusNode());
              return;
            } else {
              setState(() {
                var extractdata = json.decode(res.body);
                productdata = extractdata["product"];
                FocusScope.of(context).requestFocus(new FocusNode());
                pr.hide();
              });
            }
          })
          .catchError((err) {
            pr.hide();
          });

      pr.hide();
    } on TimeoutException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } on SocketException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  Widget genreDropDownList() {
    return Row(
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: TextButton(
                  onPressed: () => _sortItem("Recent"),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      new Icon(
                        MdiIcons.update,
                        size: 60.0,
                        color: Colors.black,
                      ),
                      SizedBox(height: 10),
                      new Text(
                        "Recent",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15.0),
                      )
                    ],
                  ),
                ))
          ],
        ),
        SizedBox(width: 3),
        Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(5),
                child: TextButton(
                  onPressed: () => _sortItem("Women Clothing"),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Image.asset(
                        'assets/images/womencloth.jpg',
                        height: 85,
                        width: 90,
                        fit: BoxFit.fitWidth,
                      ),
                      new Text(
                        "Women Clothing",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15.0),
                      )
                    ],
                  ),
                ))
          ],
        ),
        SizedBox(width: 3),
        Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(5),
                child: TextButton(
                  onPressed: () => _sortItem("Men Clothing"),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Image.asset(
                        'assets/images/mencloth.jpg',
                        height: 85,
                        width: 80,
                        fit: BoxFit.fitWidth,
                      ),
                      new Text(
                        "Men Clothing",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15.0),
                      )
                    ],
                  ),
                ))
          ],
        ),
        SizedBox(width: 3),
        Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(5),
                child: TextButton(
                  onPressed: () => _sortItem("Women Shoes"),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Image.asset(
                        'assets/images/womenshoes.jpg',
                        height: 85,
                        width: 80,
                        fit: BoxFit.fitWidth,
                      ),
                      new Text(
                        "Women Shoes",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15.0),
                      )
                    ],
                  ),
                ))
          ],
        ),
        SizedBox(width: 3),
        Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(5),
                child: TextButton(
                  onPressed: () => _sortItem("Men Shoes"),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Image.asset(
                        'assets/images/menshoes.jpg',
                        height: 85,
                        width: 90,
                        fit: BoxFit.fitWidth,
                      ),
                      new Text(
                        "Men Shoes",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15.0),
                      )
                    ],
                  ),
                ))
          ],
        ),
        SizedBox(width: 3),
        Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(5),
                child: TextButton(
                  onPressed: () => _sortItem("Bag & Wallet"),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Image.asset(
                        'assets/images/bag.jpg',
                        height: 85,
                        width: 80,
                        fit: BoxFit.fitWidth,
                      ),
                      new Text(
                        "Bag & Wallet",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15.0),
                      )
                    ],
                  ),
                ))
          ],
        ),
        SizedBox(width: 3),
        Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(5),
                child: TextButton(
                  onPressed: () => _sortItem("Book & Stationery"),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Image.asset(
                        'assets/images/book.jpg',
                        height: 85,
                        width: 80,
                        fit: BoxFit.fitWidth,
                      ),
                      new Text(
                        "Book & Stationery",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15.0),
                      )
                    ],
                  ),
                ))
          ],
        ),
        SizedBox(width: 3),
      ],
    );
  }

  _showPopUpMenu(int index) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    await showMenu(
      context: context,
      position: RelativeRect.fromRect(
          _tapPosition &
              Size(40, 40), // smaller rect, pop up after touch on touch's area
          Offset.zero & overlay.size), // Bigger rect, the entire screen
      items: [
        PopupMenuItem(
            child: GestureDetector(
          child: Text("Update Product Info"),
          onTap: () => {Navigator.of(context).pop(), _onProductDetail(index)},
        )),
        PopupMenuItem(
            child: GestureDetector(
          child: Text("Delete Product Info"),
          onTap: () =>
              {Navigator.of(context).pop(), _deleteProductDialog(index)},
        )),
      ],
      elevation: 8.0,
    );
  }

  Future<void> _onProductDetail(int index) async {
    print(productdata[index]['name']);
    Product productInfo = new Product(
        pid: productdata[index]['id'],
        name: productdata[index]['name'],
        price: productdata[index]['price'],
        genre: productdata[index]['genre'],
        quantity: productdata[index]['quantity'],
        description: productdata[index]['description'],
        date: productdata[index]['date']);

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => UpdateProduct(
                  user: widget.user,
                  product: productInfo,
                )));
    _loadData();
  }

  void _deleteProductDialog(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            title: new Text("Delete Product ID: " + productdata[index]['id']),
            content: new Text(
              "Are you sure? ",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _deleteProduct(index);
                  },
                  child: new Text(
                    "Yes",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  )),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text(
                  "No",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          );
        });
  }

  void _deleteProduct(int index) {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Deleting product...");
    pr.show();
    http.post("https://yitengsze.com/a_gifhope/php/delete_product.php", body: {
      "proid": productdata[index]['id'],
    }).then((res) {
      print(res.body);
      pr.hide();

      if (res.body.contains("success")) {
        Toast.show("Delete successfully", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _loadData(); //refresh data
      } else {
        Toast.show("Delete failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.hide();
    });
    _loadData();
  }

  Future<void> _createNewProduct() async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => NewProduct(user: widget.user)));
    _loadData();
  }

  Future<void> _viewSalesReport() async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => SalesReportScreen()));
  }

  Future<void> _viewDonateReport() async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => DonateReportScreen()));
  }
}
