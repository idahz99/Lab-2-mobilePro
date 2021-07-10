import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'deliveryaddress.dart';

void main() => runApp(Map());

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  Deliveryaddress _delivery;

  Set<Marker> markers = Set();
  String _address = "No location selected";

  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _customerPosition = CameraPosition(
    target: LatLng(6.447772, 100.478325),
    zoom: 15,
  );

  @override
  void initState() {
    super.initState();
    _cusMarker();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.orange[100],
          title: Text('Map'),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_rounded,
            ),
          ),
        ),
        body: Stack(children: [
          SizedBox.expand(
              child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _customerPosition,
            markers: markers.toSet(),
            onMapCreated: (controller) {
              _controller.complete(controller);
            },
            onTap: (newLatLng) {
              _loadaddress(newLatLng);
            },
          )),
          Column(
            children: [
              Flexible(
                flex: 7,
                child: SizedBox(height: 350),
              ),
              Flexible(
                  flex: 3,
                  child: Card(
                      child: Row(
                    children: [
                      Container(
                        height: 50,
                        child: Text(_address),
                      ),
                      MaterialButton(
                          color: Colors.orange[100],
                          child: Text('Save',
                              style: TextStyle(color: Colors.black)),
                          onPressed: () {
                            Navigator.pop(context, _delivery);
                          }),
                    ],
                  )))
            ],
          )
        ]),
      ),
    );
  }

  void _cusMarker() {
    MarkerId markerId1 = MarkerId("15");
    markers.add(Marker(
      markerId: markerId1,
      position: LatLng(6.443364, 100.428612),
      infoWindow: InfoWindow(
        title: 'Shop Location',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ));
  }

  void _loadaddress(LatLng newLatLng) async {
    MarkerId markerId1 = MarkerId("12");

    List<Placemark> newPlace =
        await placemarkFromCoordinates(newLatLng.latitude, newLatLng.longitude);

    Placemark placeMark = newPlace[0];
    String name = placeMark.name.toString();
    String subLocality = placeMark.subLocality.toString();
    String locality = placeMark.locality.toString();
    String administrativeArea = placeMark.administrativeArea.toString();
    String postalCode = placeMark.postalCode.toString();
    String country = placeMark.country.toString();
    _address = name +
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
    markers.clear();
    markers.add(Marker(
      markerId: markerId1,
      position: LatLng(newLatLng.latitude, newLatLng.longitude),
      infoWindow: InfoWindow(
        title: 'Address',
        snippet: _address,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ));
    _delivery = Deliveryaddress(_address, newLatLng);
    setState(() {});
  }
}
