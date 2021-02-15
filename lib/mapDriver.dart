import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Map2 extends StatefulWidget {
  @override
  _Map2State createState() => _Map2State();
}

class _Map2State extends State<Map2> {
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
    ByteData byteData = await DefaultAssetBundle.of(context).load("assets/gpsicon.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
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
  void getCurrentLocation() async {
    Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();
      updateMarkerAndCircle(location, imageData);
        user=await FirebaseAuth.instance.currentUser();
      _locationSubscription = _locationTracker.onLocationChanged().listen((newLocalData) {
        Firestore.instance.collection('location').document(user.uid).updateData({
            'live':'true',
            'latitude': newLocalData.latitude.toString(),
            'longitude':newLocalData.longitude.toString(),
            'heading':newLocalData.heading.toString(),
            'accuracy':newLocalData.accuracy.toString(),
          }); 
          _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(newLocalData.latitude, newLocalData.longitude),
              tilt: 0,
              zoom: 18.00)));
          updateMarkerAndCircle(newLocalData, imageData);
      });
  }
  Map data={'user':'user'} ;
  FirebaseUser user;
  @override
  Widget build(BuildContext context) {
    data=data.isEmpty?data:ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
          child: Icon(Icons.location_searching),
          onPressed: () {
            getCurrentLocation();
          }),
    );
  }
}