import 'package:flutter/material.dart';
import 'loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Addbustodriver extends StatefulWidget {
  @override
  _AddbustodriverState createState() => _AddbustodriverState();
}

class _AddbustodriverState extends State<Addbustodriver> {
  Widget list_row_bus(String name,String email,String pic,String id){
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Card(
        margin: EdgeInsets.fromLTRB(1, 1, 1, 0),
              child:Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: InkWell(
        onTap: (){
          Firestore.instance.collection('users').document(data['uid']).updateData({
                          'busuid':id,
                        });
         Navigator.pop(context);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: ListTile(
            leading: Image.network(
             pic,
             width: 50,
             height: 50,
            ),
            title: Text(name,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14),),
            subtitle: Text(email,style: TextStyle(color: Colors.orange,fontSize: 12),),
          ),
        ),
      ),
    ),
        ),
             
    );
  }
  Map data={'user':'user'};
  @override
  Widget build(BuildContext context) {
       data=data.isEmpty?data:ModalRoute.of(context).settings.arguments;
     return StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('users').where('level',isEqualTo: 'bus').snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return loading();
          default:
            return  Scaffold(
      body:SafeArea(
                child: ListView(
          children: [
              Container(
                alignment: Alignment.centerLeft,
                height: 65,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 20, 15),
                  child: Text('   Buses',style: TextStyle(color: Colors.orange[800],fontWeight: FontWeight.bold,fontFamily: 'Montserrat',fontSize: 17),),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height-80,
                decoration: BoxDecoration(
                color: Colors.white,
                ),
                child: ListView(
                  children: snapshot.data.documents.map((DocumentSnapshot document) {
                       return  list_row_bus(document['name'], document['Email'],document['pic'],document.documentID.toString());                  
                   }).toList(),
                ),
              ),
          ],
        ),
      ),
      );   
        }
      },
    );
  }
}