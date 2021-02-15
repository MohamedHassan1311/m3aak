import 'package:dalelak/loadingimg.dart';
import 'package:flutter/material.dart';
import 'loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
class Signupinfo extends StatefulWidget {
  @override
  _SignupinfoState createState() => _SignupinfoState();
}

class _SignupinfoState extends State<Signupinfo> {
  String gender,_phonenumber,urlpic,frontid,backid,frontlic,backlic;
  bool load=false;
  bool load0=false,load1=false,load2=false,load3=false;
  bool gendernot=false;
  final TextEditingController _mobilecon = TextEditingController();
  File _profilepic;
  String _visable='yes';
  
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
    final formkey =new GlobalKey<FormState>();
  bool validateandsave(){
    final form =formkey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }else{
      return false;
    
  }}
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
                          child: Text('ok',style: TextStyle(color: Colors.green),),
                          onPressed: () {
                          Navigator.of(context).pop();
                          },
                          ),
                          ],
       );
    },
  );
}

  Future validateandsubmit(FirebaseUser user) async{
    if(validateandsave()){
      Firestore.instance.collection('users').document(user.uid).updateData({
           'gender':gender,
           'mobilenumber':_phonenumber,
         }); 
         Navigator.pushReplacementNamed(context, '/home',arguments: {
            'user':user,
          });
    }
    }
    Future<bool> _showMyDialog22() async {
  return showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
                          title: Text('info '),
                           content: SingleChildScrollView(
                          child: ListBody(
                          children: <Widget>[
                          Text('you must complete your information '),
                          ],
                          ),
                          ),
                          actions: <Widget>[
                          FlatButton(
                          child: Text('ok',style: TextStyle(color: Colors.green),),
                          onPressed: () {
                          Navigator.of(context).pop(false);
                          },
                          ),
                          ],
       );
    },
  );
}
 Map data={'user':'user'};
  @override
  Widget build(BuildContext context) {
   data=data.isEmpty?data:ModalRoute.of(context).settings.arguments;
    FirebaseUser user=data['user'];
    Firestore.instance .collection('users').where("uid", isEqualTo: user.uid)
    .snapshots().listen((data) =>data.documents.forEach((doc) {
      urlpic=doc['pic'];
      frontid=doc['frontid'];
      backid=doc['backid'];
      frontlic=doc['frontlic'];
    }));
    return StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('users').where('uid', isEqualTo:user.uid).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return loading();
          default:
            return WillPopScope(
              onWillPop: _showMyDialog22,
             child: load?loading():Scaffold(
      body: SafeArea(
        child: Form(
          key: formkey,
           child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        child: Text(
                          'Complete your information',
                          style:
                              TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        child: Text(
                          ' :',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                      ),
                  ],
              ),
                ),
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
                                urlpic,
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
               
       Padding(
         padding: const EdgeInsets.fromLTRB(30, 5, 30, 0),
         child: Column(
           children: [
                     Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.device_unknown,color:gendernot?Colors.red:Colors.grey[500],),
                SizedBox(width: 15,),
                DropdownButton<String>(
      value: gender,
      focusColor: Colors.blue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.black),
      underline: Container(
              height: 1.55,
              color:gendernot?Colors.red:Colors.grey[500],
      ),
      onChanged: (String newValue) {
              setState(() {
                gender = newValue;
              });
      },
      hint: Text('Gender'),
      items: <String>['Male', 'Female']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
      }).toList(),
    ),
              ],
      ),
      SizedBox(height: 15,),
      TextFormField(
           decoration: const InputDecoration(
           icon: Icon(Icons.call),
          hintText: 'Mobile Number',
          labelText: 'Mobile Number *',
          ),
          keyboardType: TextInputType.number,
          controller: _mobilecon,
      validator: (val){
         if(val.isEmpty){
          return 'Mobile Number canot be empty';
         }else{
           return null;
         }
         },
         onSaved: (value)=>_phonenumber=value,
          ),
           ],
         ),
       ),
        StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('users').where('uid', isEqualTo:user.uid).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return loading();
          default:
            return Column(
              children: [
                SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('upload your personal ID picture '),
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
                              width: MediaQuery.of(context).size.width*0.45,
                              height: 120,
                              child: Image.network(
                                frontid,
                              ), 
                            ),
                          ),
            InkWell(onTap: ()async{
              await getimage('backid');
              await uploadPicture(user,'backid');
            },
            child:load2? Loadingimg():SizedBox(
                              width: MediaQuery.of(context).size.width*0.45,
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
            Text('upload your Driving license picture '),
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
                              width: MediaQuery.of(context).size.width*0.80,
                              height: 120,
                              child: Image.network(
                                frontlic,
                              ), 
                            ),
                          ),
          ],
        ),
              ],
            );
        }
      },
    ),
        SizedBox(height: 20,),
          Padding(
              padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
              child: InkWell(
                          onTap: (){
                            validateandsubmit(user);
                          },
                              child: Container(
                            width: 200,
                            height: 40.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Colors.orangeAccent,
                              color: Colors.orange,
                              elevation: 7.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:[
                                    Text(
                                    'Finish',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat'),
                                  ),
                                  SizedBox(width: 10,),
                                  Icon(Icons.arrow_forward_ios,color: Colors.white,),
                                  ] 
                                ),
                              
                            ),
                          ),
                        ),
          ),
          SizedBox(height: 30,),
              ],
          ),
        ),
      ),
    ),
            );
        }
      },
    );
  }
}



