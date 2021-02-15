import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'loading.dart';

class Locationlist extends StatefulWidget {
  @override
  _LocationlistState createState() => _LocationlistState();
}

class _LocationlistState extends State<Locationlist> {
    Widget list_row_loc(String uid){
     String pname,pic;
    Firestore.instance .collection('users').where("uid", isEqualTo: uid)
    .snapshots().listen((data) =>data.documents.forEach((doc) {
      pname=doc['name'];
      pic=doc['pic'];
       }));
    return  StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('users').snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return loading();
          default:
            return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: InkWell(
        onTap: (){
          Navigator.of(context).pushNamed('/maptrackeradmin',arguments: {
            'uid':uid,
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            
          ),
          child: ListTile(
            leading: CircleAvatar(
               backgroundColor:
              Theme.of(context).platform == TargetPlatform.iOS? Colors.blue: Colors.white,
            child: Image.network(
                            pic,
             ), 
            ),
            title: Text('$pname',style: TextStyle(color: Colors.blue[800],fontSize:14),),
            trailing: Icon(Icons.location_on),
          ),
        ),
      ),
    );
        }
      },
    );
  }
  FirebaseUser user;
Map data={'user':'user'};
    bool activesearch=false;
  final TextEditingController _searchcon = TextEditingController();
  String searchval='';
  bool load=false;
  @override
  Widget build(BuildContext context) {
    return load?loading():Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange,
            title:activesearch?
             TextField(
             decoration: const InputDecoration(
             icon: Icon(Icons.search,color: Colors.white,),
          hintText: 'search by driver name',
          ),
          controller: _searchcon,
         onChanged: (query){
             setState(() {
               searchval=query;
             });
         },
          ): Text('Drivers Location',style: TextStyle(color: Colors.white),),
            elevation: 0,
            actions: [
                     activesearch?IconButton(icon: Icon(Icons.search_off,),onPressed: (){
            setState(() {
              activesearch=false;
            });
          },):IconButton(icon: Icon(Icons.search,),onPressed: (){
            setState(() {
              activesearch=true;
            });
          },)
                   ],
          ),
          
          body: Container(
             height: MediaQuery.of(context).size.height-100,
             child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('users').where('map',isEqualTo:true).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return loading();
          default:
            return Padding(
                  padding: EdgeInsets.fromLTRB(5, 7, 5, 5),
                  child: ListView(
                    children: snapshot.data.documents.map((DocumentSnapshot document) {
                   return 
                      list_row_loc(document['uid']);
                 }).toList(),
                  ),
                  );
        }
      },
    ),
           ),
        );
  }
}