import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dalelak/loadingimg.dart';
class Userinfouser extends StatefulWidget {
  @override
  _UserinfouserState createState() => _UserinfouserState();
}

class _UserinfouserState extends State<Userinfouser> {
    Map data={'user':'user'};
    bool load0=false,load1=false,load2=false,load3=false;
      File _profilepic;
     Future getimage(String picType)async{
      var image=await ImagePicker.pickImage(source: picType=='profilePicture'?ImageSource.gallery:ImageSource.camera);
      if(picType=='profilePicture'){
          setState(() {
          load0=true;
          _profilepic=image;
        });
        }else if(picType=='frontid'){
          setState(() {
          load1=true;
          _profilepic=image;
        });
        }else if(picType=='backid'){
          setState(() {
          load2=true;
          _profilepic=image;
        });
        }else if(picType=='frontlic'){
          setState(() {
          load3=true;
          _profilepic=image;
        });
        }
    }
    Future<Null> uploadPicture(FirebaseUser user,String picType) async{
      try{
        if(picType=='profilePicture'){
          setState(() {
          load0=true;
        });
        }else if(picType=='frontid'){
          setState(() {
          load1=true;
        });
        }else if(picType=='backid'){
          setState(() {
          load2=true;
        });
        }else if(picType=='frontlic'){
          setState(() {
          load3=true;
        });
        }
        
        final StorageReference ref = FirebaseStorage.instance.ref().child('${user.email}_{$picType}');
        final StorageUploadTask uploadTask = ref.putFile(_profilepic);
        String docUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
            if(picType=='profilePicture'){
          Firestore.instance .collection('users') .document(user.uid).updateData({
              "pic": docUrl
              });
        }else if(picType=='frontid'){
          Firestore.instance .collection('users') .document(user.uid).updateData({
              "frontid": docUrl
              });
        }else if(picType=='backid'){
          Firestore.instance .collection('users') .document(user.uid).updateData({
              "backid": docUrl
              });
        }else if(picType=='frontlic'){
          Firestore.instance .collection('users') .document(user.uid).updateData({
              "frontlic": docUrl
              });
        }
        setState(() {
          load0=false;
          load1=false;
          load2=false;
          load3=false;
        });
      }catch(e){
        setState(() {
          load0=false;
          load1=false;
          load2=false;
          load3=false;
        });
        print('error===> ${e.toString()}');
      }
  }
   Widget details (String name,String email,String level,String uid,String birthdate,String gender,String mobile,String pic,String frontid,String backid,String frontlic,String jop){
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child:Column(
                  children: [
                     Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Align(
                       alignment: Alignment.center,
                       child: CircleAvatar(
                                     backgroundColor: Colors.white,
                            child: load0? Loadingimg():ClipOval(
                            child: SizedBox(
                              width: 200,
                              height: 200,
                              child: Image.network(
                                pic,
                              ), 
                            ),
                          ),
                            radius: 100,
                          ),
                     ),
                    Padding(
                      padding: const EdgeInsets.only(top:120),
                      child: IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: ()async{ 
                          await getimage('profilePicture');
                          await uploadPicture(user,'profilePicture');
                        },
                      ),
                    )
                  ],
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
            InkWell(onTap: ()async{
              await getimage('frontid');
              await uploadPicture(user,'frontid');
            },
            child: load1? Loadingimg():SizedBox(
                              width: MediaQuery.of(context).size.width*0.385,
                              height: 120,
                              child: Image.network(
                                frontid,
                              ), 
                            ),
                          ),
                          SizedBox(width: 5,),
            InkWell(onTap: ()async{
              await getimage('backid');
              await uploadPicture(user,'backid');
            },
            child:load2? Loadingimg():SizedBox(
                              width: MediaQuery.of(context).size.width*0.385,
                              height: 125,
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
            InkWell(onTap: ()async{
              await getimage('frontlic');
              await uploadPicture(user,'frontlic');
            },
            child: load3?Loadingimg():SizedBox(
                              width: MediaQuery.of(context).size.width*0.79,
                              height: 120,
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
  FirebaseUser user;
  String name,email,mobile,jop,gender,birthdate,level;
  @override
  Widget build(BuildContext context) {
    data=data.isEmpty?data:ModalRoute.of(context).settings.arguments;
    user=data['user'];
     Firestore.instance .collection('users').where("uid", isEqualTo: data['uid'])
    .snapshots().listen((data) =>data.documents.forEach((doc){
      name=doc['name'];
      email=doc['Email'];
      mobile=doc['mobilenumber'];
      jop=doc['jop'];
      gender=doc['gender'];
      birthdate=doc['bithdate'];
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  SizedBox(height: 3,),
                  Container(
                    child:level=='tourist'? InkWell(
                      onTap: (){
                        Navigator.pushNamed(context,'/selecttourist',arguments: {
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
                  'Select tourist',
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
                                return details(document['name'], document['Email'], document['level'],document['uid'],document['bithdate'],document['gender'],document['mobilenumber'],document['pic'],document['frontid'],document['backid'],document['frontlic'],document['jop']);   
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