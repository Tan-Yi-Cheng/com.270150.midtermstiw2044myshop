import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/view/newproduct.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'model/themes.dart';
import 'view/splashscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: CustomTheme.lighttheme,
        routes: <String, WidgetBuilder>{
          '/newproduct': (BuildContext context) => new NewProduct(),
          '/product': (BuildContext context) => new Product(),
        },
        title: 'MyApp',
        home: SplashScreen());
  }
}

class Product extends StatefulWidget {
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  List _productList;
  String _mesejTitle = "There are not datas found in the app";
  double screenHeight, screenWidth;
  ProgressDialog pr;
  final df = new DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();
    _loadproducts();
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context);
    pr.style(
      message: 'Loading...',
      borderRadius: 5.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text("Products"),
        ),
        body: WillPopScope(
            onWillPop: _onBackPressed,
            child: Center(
              child: Column(
                //---------------------
                children: [
                  if (_productList == null)
                    Flexible(child: Center(child: Text(_mesejTitle)))
                  else
                    Flexible(
                        child: Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: GridView.builder(
                          itemCount: _productList.length,
                          gridDelegate:
                              new SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5,
                                  childAspectRatio:
                                      (screenWidth / screenHeight) / 0.9),
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey[600],
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: Offset(1, 1),
                                        ),
                                      ]),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                "https://crimsonwebs.com/s270150/myshop/images/product/${_productList[index]['prid']}.png",
                                            height: 185,
                                            width: 185,
                                          )),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 15, 0, 0),
                                              child: Text(
                                                  _productList[index]['prname'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 15, 5, 0),
                                              child: Text(
                                                "RM " +
                                                    _productList[index]
                                                        ['prprice'],
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.red),
                                              ),
                                            ),
                                          ]),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                5, 5, 5, 0),
                                            child: Text(
                                              _productList[index]['prtype'],
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                5, 5, 5, 0),
                                            child: Text(
                                              "Qty Available: " +
                                                  _productList[index]['prqty'],
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )),
                ],
              ),
            )),
        floatingActionButton: Container(
          child: FloatingActionButton.extended(
              backgroundColor: Colors.indigo[500],
              icon: Icon(Icons.add),
              label: Text("Add"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewProduct()));
              }),
        ));
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text(
              'Do You Want To Exit?',
              style: TextStyle(),
            ),
            content: new Text(
              'Are You Sure?',
              style: TextStyle(),
            ),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text(
                    "Yes",
                    style: TextStyle(),
                  )),
              MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "No",
                    style: TextStyle(),
                  )),
            ],
          ),
        ) ??
        false;
  }

  void _loadproducts() {
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s270150/myshop/php/loadproducts.php"),
        body: {}).then((response) {
      if (response.body == "nodata") {
        _mesejTitle = "No data";
        return;
      } else {
        var jsondata = json.decode(response.body);
        _productList = jsondata["products"];
        _mesejTitle = "Contain Data";
        setState(() {});
        print(_productList);
      }
    });
  }
}
