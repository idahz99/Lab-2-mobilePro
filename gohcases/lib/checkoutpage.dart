import 'dart:convert';

import 'package:geocoding/geocoding.dart';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'Map.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'User.dart';

import 'deliveryaddress.dart';
import 'paymentpage.dart';

void main() => runApp(Checkoutpage());

class Checkoutpage extends StatefulWidget {
  final User user;

  const Checkoutpage({Key key, this.user}) : super(key: key);
  @override
  _CheckoutpageState createState() => _CheckoutpageState();
}

class _CheckoutpageState extends State<Checkoutpage> {
  double screenheight, screenwidth;
  List _cartlist = [];
  double _totalprice = 0;
  TextEditingController _username;
  TextEditingController _phonenumber;
  TextEditingController _address;
  String address = "";
  @override
  void initState() {
    super.initState();
    _loadpersonalcart();
    _username = new TextEditingController(text: widget.user.username);
    _phonenumber = new TextEditingController(text: widget.user.phonenum);
    _address = new TextEditingController(text: widget.user.address);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              Text("Total" + _totalprice.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 50),
              SizedBox(
                height: 350,
                width: 250,
                child: Card(
                    child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Wrap(
                              runSpacing: 8.0,
                              children: [
                                TextField(
                                    controller: _username,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Name",
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                5, 5, 5, 5))),
                                TextField(
                                    controller: _phonenumber,
                                    keyboardType: TextInputType.phone,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Phone",
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                5, 5, 5, 5))),
                                TextField(
                                    controller: _address,
                                    maxLines: 5,
                                    keyboardType: TextInputType.multiline,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Address",
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                5, 5, 5, 5))),
                                IconButton(
                                    icon: const Icon(Icons.location_on_rounded),
                                    tooltip: 'Location',
                                    onPressed: () => {_currentLocation()}),
                                IconButton(
                                  icon: const Icon(Icons.map_rounded),
                                  tooltip: 'Map',
                                  onPressed: () async {
                                    Deliveryaddress _myaddress =
                                        await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => Map(),
                                      ),
                                    );
                                    print(address);
                                    setState(() {
                                      _address.text = _myaddress.address;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ))),
              ),
              SizedBox(height: 5),
              Container(
                child: Wrap(direction: Axis.horizontal, children: [
                  MaterialButton(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child:
                          Text('Cancel', style: TextStyle(color: Colors.black)),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  MaterialButton(
                      color: Colors.red[100],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Text('Pay', style: TextStyle(color: Colors.black)),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Paypage(
                                user: widget.user,
                                deliveryaddress: _address.text.toString(),
                                nameentered: _username.text.toString(),
                                phonenumentered: _phonenumber.text.toString(),
                                total: _totalprice.toString()),
                          ),
                        );
                      }),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loadpersonalcart() {
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s269349/GohCases/php/loadusercart.php"),
        body: {"email": widget.user.email}).then((response) {
      print(response.body);
      if (response.body == "nodata") {
        
        _cartlist = [];
        return;
      } else {
        var jsondata = json.decode(response.body);
        print(jsondata);
        _cartlist = jsondata["cart"];

        _totalprice = 0;
        for (int index = 0; index < _cartlist.length; index++) {
          _totalprice = _totalprice +
              double.parse(_cartlist[index]['productprice']) *
                  int.parse(_cartlist[index]['cartquantity']);
        }
      }
      setState(() {});
    });
  }

  _currentLocation() async {
    ProgressDialog progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    progressDialog.style(
      message: 'Loading...',
    );

    progressDialog.show();
    await _position().then((value) => {_getPlace(value)});
    setState(
      () {},
    );
    progressDialog.hide();
  }

  void _getPlace(Position p) async {
    List<Placemark> place =
        await placemarkFromCoordinates(p.latitude, p.longitude);

    Placemark placeMark = place[0];
    String name = placeMark.name.toString();
    String subLocality = placeMark.subLocality.toString();
    String locality = placeMark.locality.toString();
    String administrativeArea = placeMark.administrativeArea.toString();
    String postalCode = placeMark.postalCode.toString();
    String country = placeMark.country.toString();
    address = name +
        "," +
        subLocality +
        ",\n" +
        locality +
        "," +
        postalCode +
        ",\n" +
        administrativeArea +
        "," +
        country;
    _address.text = address;
  }

  Future<Position> _position() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
