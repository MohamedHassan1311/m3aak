import 'package:flutter/material.dart';
import 'loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Selecttourist extends StatefulWidget {
  @override
  _SelecttouristState createState() => _SelecttouristState();
}

class _SelecttouristState extends State<Selecttourist> {
   Widget list_row_tour(String name,String email,String pic,String id,String tuid){
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Card(
        margin: EdgeInsets.fromLTRB(1, 1, 1, 0),
              child:Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: InkWell(
        onTap: (){
          if(data['uid']!=id){
            Firestore.instance.collection('users').document(data['uid']).updateData({
                          'tuid':id,
                        });
          Firestore.instance.collection('users').document(id).updateData({
            'tuid':data['uid'],
          });
          Navigator.pop(context);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color:Colors.white,
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
                    stream: Firestore.instance.collection('users').where('level',isEqualTo: 'tourist').snapshots(),
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
                  child: Text('   Tourist',style: TextStyle(color: Colors.orange[800],fontWeight: FontWeight.bold,fontFamily: 'Montserrat',fontSize: 17),),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height-80,
                decoration: BoxDecoration(
                color: Colors.white,
                ),
                child: ListView(
                  children: snapshot.data.documents.map((DocumentSnapshot document) {
                       return  list_row_tour(document['name'], document['Email'],document['pic'],document.documentID.toString(),document['tuid']);                  
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