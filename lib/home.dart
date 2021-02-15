import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'loading.dart';
import 'dart:async';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  bool load = false;
  String urlpic, type, area;
  final ScrollController _controlleritem = ScrollController();
  //start info----methods----------------
  String doctorsp = '', _phonenumber = '', gender, nid = '';
  final formkey = new GlobalKey<FormState>();
  final TextEditingController _mobilecon = TextEditingController();
  final TextEditingController _nidcon = TextEditingController();
  final TextEditingController _spcon = TextEditingController();
  bool gendernot = false;
  String latitude = "waiting...";
  String longitude = "waiting...";
  String altitude = "waiting...";
  String accuracy = "waiting...";
  String bearing = "waiting...";
  String speed = "waiting...";
  String time = "waiting...";
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('info '),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('you must complete all the information '),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'ok',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget list_row(String name, String title, String pic, String path,
      FirebaseUser user, Color color, String gridname) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Card(
        shadowColor: Colors.blue,
        margin: EdgeInsets.fromLTRB(1, 1, 1, 0),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: InkWell(
            onTap: () async {
              if (name == 'Users') {
                await Navigator.pushNamed(context, path, arguments: {
                  'user': user,
                });
                QuerySnapshot _myDocnot2 = await Firestore.instance
                    .collection('users')
                    .where('level', isEqualTo: 'disable')
                    .getDocuments();
                List<DocumentSnapshot> _myDocCountnot2 = _myDocnot2.documents;
                int notlen2 = _myDocCountnot2.length;
                setState(() {
                  docnotcount = notlen2.toString();
                  load = false;
                });
              } else {
                Navigator.pushNamed(context, path, arguments: {
                  'user': user,
                  'uid': user.uid,
                });
              }
            },
            child: Column(
              children: [
                Image(
                  image: AssetImage('assets/$pic'),
                  height: 35,
                  width: 35,
                ),
                SizedBox(
                  height: 7,
                ),
                Text(
                  name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 11, fontFamily: 'Montserrat'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String docnotcount = '0';
  bool newuser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  FirebaseUser user;
  Map data = {'user': 'user'};
  String level, info, picurl, name, mobilenumber, busuid, tuid;

  getCurrentLocation() {
    BackgroundLocation().getCurrentLocation().then((location) {
      print("This is current Location" + location.longitude.toString());
    });
  }

  @override
  void dispose() {
    BackgroundLocation.stopLocationService();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BackgroundLocation.getLocationUpdates((location) {
      print(location);
    });
    BackgroundLocation.setAndroidNotification(
      title: "Notification title",
      message: "Notification message",
      icon: "@mipmap/ic_launcher",
    );

    data = data.isEmpty ? data : ModalRoute.of(context).settings.arguments;
    FirebaseUser user = data['user'];
    Firestore.instance
        .collection('users')
        .where("uid", isEqualTo: user.uid)
        .snapshots()
        .listen(
            (data) => data.documents.forEach((doc) => level = doc['level']));
    Firestore.instance
        .collection('users')
        .where("uid", isEqualTo: user.uid)
        .snapshots()
        .listen((data) => data.documents.forEach((doc) => info = doc['info']));
    Firestore.instance
        .collection('users')
        .where("uid", isEqualTo: user.uid)
        .snapshots()
        .listen((data) => data.documents.forEach((doc) => picurl = doc['pic']));
    Firestore.instance
        .collection('users')
        .where("uid", isEqualTo: user.uid)
        .snapshots()
        .listen((data) => data.documents.forEach((doc) => type = doc['type']));
    Firestore.instance
        .collection('users')
        .where("uid", isEqualTo: user.uid)
        .snapshots()
        .listen((data) => data.documents.forEach((doc) => name = doc['name']));
    Firestore.instance
        .collection('users')
        .where("uid", isEqualTo: user.uid)
        .snapshots()
        .listen((data) => data.documents
            .forEach((doc) => mobilenumber = doc['mobilenumber']));
    Firestore.instance
        .collection('users')
        .where("uid", isEqualTo: user.uid)
        .snapshots()
        .listen(
            (data) => data.documents.forEach((doc) => busuid = doc['busuid']));
    Firestore.instance
        .collection('users')
        .where("uid", isEqualTo: user.uid)
        .snapshots()
        .listen((data) => data.documents.forEach((doc) => tuid = doc['tuid']));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        shadowColor: Colors.orangeAccent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Home'),
          ],
        ),
      ),
      drawer: Drawer(
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('users')
              .where('uid', isEqualTo: user.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return loading();
              default:
                return ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      accountName: Text(
                        name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      accountEmail: Text(user.email),
                      currentAccountPicture: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).platform == TargetPlatform.iOS
                                ? Colors.blue
                                : Colors.white,
                        child: Image.network(
                          picurl,
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, '/userinfouser',
                            arguments: {
                              'uid': user.uid,
                              'user': user,
                            });
                      },
                      leading: Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                      title: Text("Account info"),
                      trailing: Icon(Icons.arrow_forward),
                    ),
                    ListTile(
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/', (Route<dynamic> route) => false);
                      },
                      leading: Icon(Icons.logout, color: Colors.red),
                      title: Text("Logout"),
                    ),
                  ],
                );
            }
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('users')
            .where('uid', isEqualTo: user.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return loading();
            default:
              return load
                  ? loading()
                  : info == 'com' && level == 'driver'
                      ? Scaffold(
                          backgroundColor: Colors.lightBlueAccent[50],
                          body: SafeArea(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 150,
                                child: Image(
                                  image: AssetImage("assets/followup.jpg"),
                                  height: 165,
                                  width: MediaQuery.of(context).size.width,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Card(
                                color: Colors.white,
                                shadowColor: Colors.blue,
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushNamed('/map', arguments: {
                                        'user': user,
                                      });
                                    },
                                    title: Text(
                                      ' start',
                                      style: TextStyle(color: Colors.teal[400]),
                                    ),
                                    leading: Icon(
                                      Icons.location_on,
                                      color: Colors.teal[400],
                                    ),
                                    trailing: Icon(Icons.arrow_forward_ios,
                                        color: Colors.teal[400]),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              busuid != ''
                                  ? Card(
                                      color: Colors.white,
                                      shadowColor: Colors.blue,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: ListTile(
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                                '/maptrackeradmin',
                                                arguments: {
                                                  'uid': busuid,
                                                });
                                          },
                                          title: Text(
                                            ' find my bus',
                                            style: TextStyle(
                                                color: Colors.teal[400]),
                                          ),
                                          leading: Icon(
                                            Icons.location_on,
                                            color: Colors.teal[400],
                                          ),
                                          trailing: Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.teal[400]),
                                        ),
                                      ),
                                    )
                                  : Text(''),
                            ],
                          )),
                        )
                      : info == 'com' && level == 'tourist'
                          ? Scaffold(
                              backgroundColor: Colors.lightBlueAccent[50],
                              body: SafeArea(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 150,
                                    child: Image(
                                      image: AssetImage("assets/followup.jpg"),
                                      height: 165,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Card(
                                    color: Colors.white,
                                    shadowColor: Colors.blue,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.of(context)
                                              .pushNamed('/map', arguments: {
                                            'user': user,
                                          });
                                        },
                                        title: Text(
                                          ' start',
                                          style: TextStyle(
                                              color: Colors.teal[400]),
                                        ),
                                        leading: Icon(
                                          Icons.location_on,
                                          color: Colors.teal[400],
                                        ),
                                        trailing: Icon(Icons.arrow_forward_ios,
                                            color: Colors.teal[400]),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  tuid != ''
                                      ? Card(
                                          color: Colors.white,
                                          shadowColor: Colors.blue,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: ListTile(
                                              onTap: () {
                                                Navigator.of(context).pushNamed(
                                                    '/maptrackeradmin',
                                                    arguments: {
                                                      'uid': tuid,
                                                    });
                                              },
                                              title: Text(
                                                ' find tourist',
                                                style: TextStyle(
                                                    color: Colors.teal[400]),
                                              ),
                                              leading: Icon(
                                                Icons.location_on,
                                                color: Colors.teal[400],
                                              ),
                                              trailing: Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colors.teal[400]),
                                            ),
                                          ),
                                        )
                                      : Text(''),
                                ],
                              )),
                            )
                          //admin screen
                          : info == 'com' && level == 'admin'
                              ? Scaffold(
                                  body: SafeArea(
                                    child: Scaffold(
                                      backgroundColor:
                                          Colors.lightBlueAccent[50],
                                      body: SafeArea(
                                          child: Column(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 150,
                                            child: Image(
                                              image: AssetImage(
                                                  "assets/followup.jpg"),
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              width: 100,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height -
                                                300,
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 0, 10, 0),
                                              child: GridView.count(
                                                mainAxisSpacing: 10,
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 10,
                                                primary: false,
                                                children: [
                                                  list_row(
                                                      'Users',
                                                      'All users',
                                                      'Users.png',
                                                      '/users',
                                                      user,
                                                      Colors.red,
                                                      'users'),
                                                  list_row(
                                                      'Locations',
                                                      'Locations List',
                                                      'map.png',
                                                      '/locationList',
                                                      user,
                                                      Colors.white,
                                                      'locationslist'),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                    ),
                                  ),
                                )
                              : info == 'com' && level == 'bus'
                                  ? Scaffold(
                                      backgroundColor:
                                          Colors.lightBlueAccent[50],
                                      body: SafeArea(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 150,
                                            child: Image(
                                              image: AssetImage(
                                                  "assets/followup.jpg"),
                                              height: 165,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Card(
                                            color: Colors.white,
                                            shadowColor: Colors.blue,
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: ListTile(
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .pushNamed('/map',
                                                          arguments: {
                                                        'user': user,
                                                      });
                                                },
                                                title: Text(
                                                  ' start',
                                                  style: TextStyle(
                                                      color: Colors.teal[400]),
                                                ),
                                                leading: Icon(
                                                  Icons.location_on,
                                                  color: Colors.teal[400],
                                                ),
                                                trailing: Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: Colors.teal[400]),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                    )
                                  : info == 'com' && level == 'sub admin'
                                      ? Scaffold(
                                          body: SafeArea(
                                            child: Scaffold(
                                              backgroundColor:
                                                  Colors.lightBlueAccent[50],
                                              body: SafeArea(
                                                  child: Column(
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 150,
                                                    child: Image(
                                                      image: AssetImage(
                                                          "assets/followup.jpg"),
                                                      height:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      width: 100,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height -
                                                            300,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              10, 0, 10, 0),
                                                      child: GridView.count(
                                                        mainAxisSpacing: 10,
                                                        crossAxisCount: 2,
                                                        crossAxisSpacing: 10,
                                                        primary: false,
                                                        children: [
                                                          list_row(
                                                              'Users',
                                                              'All users',
                                                              'Users.png',
                                                              '/users',
                                                              user,
                                                              Colors.red,
                                                              'users'),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                            ),
                                          ),
                                        )
                                      : Scaffold(
                                          body: SafeArea(
                                            child: Center(
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'في انتظار قبول طلب التسجيل',
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    RaisedButton(
                                                      child: Text(
                                                        'تسجيل الخروج',
                                                      ),
                                                      onPressed: () {
                                                        FirebaseAuth.instance
                                                            .signOut();
                                                        Navigator.of(context)
                                                            .pushNamedAndRemoveUntil(
                                                                '/',
                                                                (Route<dynamic>
                                                                        route) =>
                                                                    false);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
          }
        },
      ),
    );
  }
}
