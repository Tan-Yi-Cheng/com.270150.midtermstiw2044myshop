import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/main.dart';
import 'package:progress_dialog/progress_dialog.dart';

class NewProduct extends StatefulWidget {
  @override
  _NewProductState createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  ProgressDialog pr;
  TextEditingController _prnameController = new TextEditingController();
  TextEditingController _prtypeController = new TextEditingController();
  TextEditingController _prpriceController = new TextEditingController();
  TextEditingController _prqtyController = new TextEditingController();
  double screenHeight, screenWidth;
  File _image;
  String pathAsset = 'assets/images/no_image.png';

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context);
    pr.style(
      message: 'Add New Product...',
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
        title: Text("Add Product"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: screenHeight / 2.35,
              child: Stack(children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: _image == null
                          ? AssetImage(pathAsset)
                          : FileImage(_image),
                      fit: BoxFit.scaleDown,
                    )),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          size: 22,
                        ),
                        onPressed: () {
                          _onPictureSelectionDialog();
                        },
                      )),
                )
              ]),
            ),
            SizedBox(height: 10),
            Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    width: screenWidth / 1.1,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[600],
                            spreadRadius: 4,
                            blurRadius: 5,
                            offset: Offset(0, 5),
                          )
                        ],
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        ListTile(
                          title: TextField(
                            controller: _prnameController,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: "Name :",
                            ),
                          ),
                        ),
                        ListTile(
                          title: TextField(
                            controller: _prtypeController,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: "Types :",
                            ),
                          ),
                        ),
                        ListTile(
                          title: TextField(
                            controller: _prpriceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Price(RM) :",
                            ),
                          ),
                        ),
                        ListTile(
                          title: TextField(
                            controller: _prqtyController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Quantity :",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minWidth: screenWidth / 1.1,
                  height: screenHeight / 15,
                  child: Text(
                    'Add',
                    style: TextStyle(
                        fontSize: 20, color: Colors.white, fontFamily: 'Arial'),
                  ),
                  onPressed: () {
                    onAddProduct();
                  },
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onAddProduct() {
    String _name = _prnameController.text.toString();
    String _type = _prtypeController.text.toString();
    String _price = _prpriceController.text.toString();
    String _quantity = _prqtyController.text.toString();

    if (_name.isEmpty && _type.isEmpty && _price.isEmpty && _quantity.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please Fill All The Information. ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else if (_name.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please Enter Your Name. ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else if (_type.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please Enter The Type. ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else if (_price.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please Enter The Price",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else if (_quantity.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please Enter Your Quantity",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else if (_image == null) {
      Fluttertoast.showToast(
          msg: "Please Add Your Picture",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            title: Text('Do You Want To Add New Product ? ',
                style: Theme.of(context).textTheme.headline5),
            content: Text("Are You Sure ? ",
                style: Theme.of(context).textTheme.bodyText1),
            actions: [
              TextButton(
                child: (Text('Yes. ',
                    style: Theme.of(context).textTheme.bodyText2)),
                onPressed: () {
                  _addProduct(_name, _type, _price, _quantity);
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: (Text('No. ',
                    style: Theme.of(context).textTheme.bodyText2)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _onPictureSelectionDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: new Container(
              padding: EdgeInsets.all(0),
              width: screenWidth / 5,
              height: screenHeight / 5.5,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.blue,
                    ),
                    title: Text(
                      "Camera",
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.blue,
                    ),
                    onTap: () => {Navigator.pop(context), _chooseCamera()},
                  ),
                  SizedBox(height: 5),
                  ListTile(
                    leading: Icon(
                      Icons.photo_album_outlined,
                      color: Colors.blue,
                    ),
                    title: Text(
                      "Gallery",
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.blue,
                    ),
                    onTap: () => {Navigator.pop(context), _chooseGallery()},
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _chooseCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 1000,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print('No Picture Is Selected. ');
    }
    _cropImage();
  }

  Future<void> _chooseGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 1000,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print('No Picture Is Selected. ');
    }
    _cropImage();
  }

  void _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Please Crop Your Picture',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: Colors.blue,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }

  void _addProduct(String name, String type, String price, String quantity) {
    String base64Image = base64Encode(_image.readAsBytesSync());
    print(base64Image);
    print(name);
    print(type);
    print(price);
    print(quantity);

    http.post(
        Uri.parse("https://crimsonwebs.com/s270150/myshop/php/newproduct.php"),
        body: {
          "prname": name,
          "prtype": type,
          "prprice": price,
          "prqty": quantity,
          "encoded_string": base64Image,
        }).then((response) {
      print(response.body);

      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Successful Add The Pictures.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Product()));
      } else {
        Fluttertoast.showToast(
            msg: "Failed to Add The Picture",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }
}
