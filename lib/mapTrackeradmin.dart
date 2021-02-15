import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class Maptrackeradmin extends StatefulWidget {
  @override
  _MaptrackeradminState createState() => _MaptrackeradminState();
}

class _MaptrackeradminState extends State<Maptrackeradmin> {
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _controller;

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(30.0443677, 31.2359946),
    zoom: 14.4746,
  );

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/gpsicon.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(
      Uint8List imageData, LocationData newLocalData) async {
    Uint8List imageData = await getMarker();
    LatLng latlng = LatLng(double.parse(latitude), double.parse(longitude));
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
    });
  }

  getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();
// print("${location.longitude }" "test" +  "${location.latitude}");
      updateMarkerAndCircle(imageData, location);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged().listen((newLocalData) {
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 192.8334901395799,
                  // target: LatLng(newLocalData.latitude, newLocalData.longitude),
                  target:
                      LatLng(double.parse(latitude), double.parse(longitude)),
                  tilt: 0,
                  zoom: 19.00)));
          updateMarkerAndCircle(imageData, location);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  // void getCurrentuserlocation() async {
  //   Uint8List imageData = await getMarker();
  //   var location = await _locationTracker.getLocation();
  //   updateMarkerAndCircle(imageData, location);
  //   _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
  //       bearing: 192.8334901395799,
  //       target: LatLng(double.parse(latitude), double.parse(longitude)),
  //       tilt: 0,
  //       zoom: 18.00)));
  //   // updateMarkerAndCircle(imageData);
  // }

  Timer timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  Map data = {'user': 'user'};
  String latitude, longitude, heading, accuracy;
  @override
  Widget build(BuildContext context) {
    data = data.isEmpty ? data : ModalRoute.of(context).settings.arguments;
    Firestore.instance
        .collection('location')
        .where("uid", isEqualTo: data['uid'])
        .snapshots()
        .listen((data) => data.documents.forEach((doc) {
              latitude = doc['latitude'];
              longitude = doc['longitude'];
              heading = doc['heading'];
              accuracy = doc['accuracy'];
            }));
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('location')
          .where("uid", isEqualTo: data['uid'])
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          default:
            return Scaffold(
              appBar: AppBar(
                title: Text('Map'),
              ),
              body: GoogleMap(
                mapType: MapType.hybrid,
                initialCameraPosition: initialLocation,
                markers: Set.of((marker != null) ? [marker] : []),
                circles: Set.of((circle != null) ? [circle] : []),
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                },
              ),
            );
        }
      },
    );
  }
}
