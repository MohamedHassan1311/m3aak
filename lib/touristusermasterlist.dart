import 'package:flutter/material.dart';
import 'loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Touristmasterlist extends StatefulWidget {
  @override
  _TouristmasterlistState createState() => _TouristmasterlistState();
}

class _TouristmasterlistState extends State<Touristmasterlist> {
   Widget list_row_user(String name,String email,String phonenum,String gender,String userid,String pic){
    return  Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: InkWell(
        onTap: (){
          Navigator.pushNamed(context, '/userinfo',arguments: {
            'uid':userid,
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: ListTile(
            leading:Image.network(pic),
            title: Text(name,style: TextStyle(color: Colors.blue[800],fontWeight: FontWeight.bold,fontSize: 14),),
            trailing: Icon(Icons.arrow_back_ios,size: 12,),
          ),
        ),
      ),
    );
  }
  bool activesearch=false;
  final TextEditingController _searchcon = TextEditingController();
  String searchval='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title:activesearch?
                       TextField(
                         
             decoration: const InputDecoration(
             icon: Icon(Icons.search,color: Colors.white,),
          hintText: 'search',
          ),
          controller: _searchcon,
         onChanged: (query){
             setState(() {
               searchval=query;
             });
         },
          ):Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Image(
                         image: AssetImage('assets/tour_icon.png'),
                         width: 40,
                         height: 40,
                       ),
                       SizedBox(width: 7,),
                       Text('tourist list',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,fontFamily: 'Montserrat',color: Colors.blue[900]),),
                     ],
                   ),
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
       body: ListView(
         children: [
           Container(
             height: MediaQuery.of(context).size.height-120,
             child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('users').where('level', isEqualTo:'tourist' ).where('visable',isEqualTo: 'yes').snapshots(),
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
                      list_row_user(document['name'],document['Email'],document['mobilenumber'],document['gender'],document.documentID.toString(),document['pic']);
                 }).toList(),
                  ),
                  );
        }
      },
    ),
           )
         ],
       ),
      );
  }
}