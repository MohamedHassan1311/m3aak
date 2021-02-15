import 'package:flutter/material.dart';
import 'loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class User_info extends StatefulWidget {
  @override
  _User_infoState createState() => _User_infoState();
}

class _User_infoState extends State<User_info> {
   Map data={'user':'user'};
   Widget details (String name,String email,String level,String uid,String birthdate,String gender,String mobile,String pic,String frontid,String backid,String frontlic){
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child:Column(
                  children: [
                     CircleAvatar(
                        backgroundColor: Colors.white,
                        child: ClipOval(
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: Image.network(pic),
                        ),
                      ),
                        radius: 100,
                      ),
                    Divider(color: Colors.blue,indent: 16,),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Name',style: TextStyle(fontFamily:'Montserrat',fontWeight: FontWeight.bold,fontSize: 14 ),),
                      subtitle: Text(name,style: TextStyle(fontFamily: 'Montserrat',fontSize: 19),),
                    ),
                    ListTile(
                      leading: Icon(Icons.email),
                      title: Text('Email address',style: TextStyle(fontFamily:'Montserrat',fontWeight: FontWeight.bold,fontSize: 14 ),),
                      subtitle: Text(email,style: TextStyle(fontFamily: 'Montserrat',fontSize: 19),),
                    ),
                    ListTile(
                      leading: Icon(Icons.date_range),
                      title: Text('Birthdate',style: TextStyle(fontFamily:'Montserrat',fontWeight: FontWeight.bold,fontSize: 14 ),),
                      subtitle: Text(birthdate.substring(0,10),style: TextStyle(fontFamily: 'Montserrat',fontSize: 19),),
                    ),
                    ListTile(
                      leading: Icon(Icons.face),
                      title: Text('Gender',style: TextStyle(fontFamily:'Montserrat',fontWeight: FontWeight.bold,fontSize: 14 ),),
                      subtitle: Text(gender,style: TextStyle(fontFamily: 'Montserrat',fontSize: 19),),
                    ),
                    ListTile(
                      leading: Icon(Icons.flag),
                      title: Text('Level',style: TextStyle(fontFamily:'Montserrat',fontWeight: FontWeight.bold,fontSize: 14 ),),
                      subtitle: Text(level,style: TextStyle(fontFamily: 'Montserrat',fontSize: 19),),
                      trailing: IconButton(icon: Icon(Icons.edit),color: Colors.black,onPressed:(){
                        Navigator.pushNamed(context, '/editelevel',arguments: {
                          'uid':uid,
                          'level':level,
                        });
                      } ,),
                    ),
                    ListTile(
                      leading: Icon(Icons.call),
                      title: Text('Mobile number',style: TextStyle(fontFamily:'Montserrat',fontWeight: FontWeight.bold,fontSize: 14 ),),
                      subtitle: Text(mobile,style: TextStyle(fontFamily: 'Montserrat',fontSize: 19),),
                    ),
                    Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.credit_card_sharp,color:Colors.grey,),
            SizedBox(width: 15,),
            Text('personal ID picture ',style: TextStyle(fontFamily:'Montserrat',fontWeight: FontWeight.bold,fontSize: 14 ),),
          ],
        ),
        SizedBox(height: 10,),
        Row(
          children: [
            InkWell(onTap: (){
              Navigator.pushNamed(context, '/imageviewer',arguments: {
                'url':frontid,
              });
            },
            child: SizedBox(
                              width: MediaQuery.of(context).size.width*0.385,
                              height: 130,
                              child: Image.network(
                                frontid,
                              ), 
                            ),
                          ),
                          SizedBox(width: 5,),
            InkWell(onTap: (){
              Navigator.pushNamed(context, '/imageviewer',arguments: {
                'url':backid,
              });
            },
            child:SizedBox(
                              width: MediaQuery.of(context).size.width*0.385,
                              height: 130,
                              child: Image.network(
                                backid,
                              ), 
                            ),
                          ),
            
          ],
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.drive_eta,color:Colors.grey,),
            SizedBox(width: 15,),
            Text('Driving license ',style: TextStyle(fontFamily:'Montserrat',fontWeight: FontWeight.bold,fontSize: 14 ),),
          ],
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(onTap: (){
              Navigator.pushNamed(context, '/imageviewer',arguments: {
                'url':frontlic,
              });
            },
            child: SizedBox(
                              width: MediaQuery.of(context).size.width*0.78,
                              height: 130,
                              child: Image.network(
                                frontlic,
                              ), 
                            ),
                          ),
          ],
        ),
        SizedBox(height: 40,),
                  ],
                ), 
    );
  }
  String level;
  @override
  Widget build(BuildContext context) {
    data=data.isEmpty?data:ModalRoute.of(context).settings.arguments;
         Firestore.instance .collection('users').where("uid", isEqualTo: data['uid'])
    .snapshots().listen((data) =>data.documents.forEach((doc){
      level=doc['level'];
    }));
    return StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('users').where('uid', isEqualTo:data['uid'].toString()).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return loading();
          default:
            return Scaffold(
            backgroundColor: Colors.orange,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: (){Navigator.pop(context);},
                  ),
                  SizedBox(width: 15,),
                  Text(
                  'user info',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                      ],
                    ),
                  ),
                  Container(
                    child:level=='driver'? InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, '/addbustouser',arguments: {
                        'uid':data['uid'],
                      });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                      Icons.add,
                      color: Colors.white,
                      ),
                  Text(
                  'Add Bus',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontSize: 12,
                  ),
                  ),
                        ],
                      ),
                    ):Text(''),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 5, 15, 0),
              child: Container(
                height: MediaQuery.of(context).size.height* 0.85,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(45)),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(25, 10, 25, 0),
                  child: ListView(
                    children: [
                      Center(
                        child: Container(
                          height:MediaQuery.of(context).size.height-120 ,
                          width:800 ,
                          child: ListView(
                            children: snapshot.data.documents.map((DocumentSnapshot document) {
                                return details(document['name'], document['Email'], document['level'],document['uid'],document['bithdate'],document['gender'],document['mobilenumber'],document['pic'],document['frontid'],document['backid'],document['frontlic']);   
                        }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
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