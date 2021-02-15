import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dalelak/loading.dart';
import 'package:dalelak/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login_form extends StatefulWidget {
  @override
  _Login_formState createState() => _Login_formState();
}
enum FormType{
    login,
    register
  }

class _Login_formState extends State<Login_form> {
  String _username,_password,_pass2,_name,gender='Male',_jop=' ',_phonenumber=' ';
  
  String _visable='yes';
  String _status='New';
  bool obscureText=true;
  DateTime _date=DateTime.now();
  String _level='disable';
  String pic='https://firebasestorage.googleapis.com/v0/b/m3aak-304801.appspot.com/o/app%20pic%2Fuser.png?alt=media&token=7b4f2261-86d1-49a6-ae1c-58da7b0bbb5b';
  String idspic='https://firebasestorage.googleapis.com/v0/b/m3aak-304801.appspot.com/o/app%20pic%2F126-1266771_add-clip-art-download.png?alt=media&token=d515cf3f-1d7b-48d8-9a9e-41cb6ea9d9b5';
  FormType _formtype=FormType.login;
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final TextEditingController _emailcon = TextEditingController();
  final TextEditingController _namecon = TextEditingController();
  bool load=false;
  String error='';
  Auth _auth=new Auth();
  final formkey =new GlobalKey<FormState>();
  Future<void> _showMyDialoginfo(String info) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
                          title: Text('error'),
                           content: SingleChildScrollView(
                          child: ListBody(
                          children: <Widget>[
                          Text(info),
                          ],
                          ),
                          ),
                          actions: <Widget>[
                          FlatButton(
                          child: Text('ok'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          ),
                          ],
       );
    },
  );
}
  bool validateandsave(){
    final form =formkey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }else{
      return false;  
  }}
  
  Future validateandsubmit() async{
    if(validateandsave()){
      try{
          if(_formtype==FormType.login){
            setState(() {
              load=true;
            });
          FirebaseUser user=await _auth.loginEmailandpass(_username, _password);
          Navigator.pushReplacementNamed(context, '/home',arguments: {
            'user':user,
          });
          }else{
            setState(() {
              load=true;
            });
            FirebaseUser user=await _auth.registerEmailandpass(_username,_password);
             Firestore.instance.collection('users').document(user.uid).setData({
              'name':_name,
              'Email':user.email.toString(),
              'level':_level,
              'pic':pic,
              'frontid':idspic,
              'backid':idspic,
              'frontlic':idspic,
              'uid':user.uid,
              'bithdate':_date.toString(),
              'gender':gender,
              'status':_status,
              'visable':_visable,
              'info':'com',
              'map':false,
              'tuid':'',
              'busuid':'',
              'jop':_jop,
              'mobilenumber':_phonenumber,
            });
             Navigator.pushReplacementNamed(context, '/signupinfo',arguments: {
            'user':user,
            'uid':user.uid,
            'email':user.email,
          });
          }
     }catch(e){
       setState(() {
              load=false;
          });
       _showMyDialoginfo(e.toString());
     }
    }
  }
  void converttoregister(){
    formkey.currentState.reset();
    setState(() {
      _formtype=FormType.register;
      error='';
      obscureText=true;
    });  
  }
  @override
  Widget build(BuildContext context) {
    return load?loading():SafeArea(
          child: Scaffold(
        backgroundColor:Colors.yellow[600],
        body: SafeArea(
          child:ListView(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 5, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Image(
                                image: AssetImage('assets/bus_icon_logo.png'),
                                width: 40,
                                height: 32,
                                ),
                                SizedBox(width: 7,),
                              Text(
                                'معاك',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 4,),
                              Text(
                                '',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                    child:
                    Container(
                      height: MediaQuery.of(context).size.height*0.85,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(75)),
                      ),
                      child:
                          Form(
                            key:formkey ,
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: ListView(
                                children: [
                                  LimitedBox(
                                    maxHeight: MediaQuery.of(context).size.height*0.6,
                                       child: ListView(
                                      children: inputs(),
                                    ),
                                  ),
                                   Column(
                                      children: buttons(),
                                    ),
                                  
                                ],
                              ),
                            ),
                          ),
                      ),
                    ),
                ],
              )
            ],
          )
          ),
      ),
    );
  }
  List <Widget> buttons(){
      if(_formtype==FormType.login){
        return[
          SizedBox(height: 20,),
           InkWell(
                      onTap: (){
                        validateandsubmit();
                      },
                          child: Container(
                        width: 200,
                        height: 40.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.yellowAccent,
                          color: Colors.yellow[800],
                          elevation: 7.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:[
                                Icon(Icons.touch_app,color: Colors.white,),
                                SizedBox(width: 10,),
                                Text(
                                'sign in',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat'),
                              ),
                              ] 
                            ),
                          
                        ),
                      ),
                    ),
            SizedBox(height: 10,),
            InkWell(
                      onTap: (){
                        converttoregister();
                      },
                          child: Container(
                        width: 200,
                        height: 40.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.yellowAccent,
                          color: Colors.yellow[800],
                          elevation: 7.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:[
                                Icon(Icons.add_circle,color: Colors.white,),
                                SizedBox(width: 10,),
                                Text(
                                'Sign up',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat'),
                              ),
                              ] 
                            ),
                          
                        ),
                      ),
                    ),      
          SizedBox(height: 5,),
          Text(error,style: TextStyle(color: Colors.red,fontSize: 14),)
        ];
      }else{
        return[
          SizedBox(height: 20,),
          InkWell(
                      onTap: (){
                        validateandsubmit();
                      },
                          child: Container(
                        width: 200,
                        height: 40.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.yellowAccent,
                          color: Colors.yellow[800],
                          elevation: 7.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:[
                                Text(
                                'Next',
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
            SizedBox(height: 10,),
            InkWell(
                      onTap: (){
                         formkey.currentState.reset();
                         obscureText=true;
                 _pass.clear();
                 _confirmPass.clear();
                 _namecon.clear();
                 _emailcon.clear();
               setState(() {
                 _formtype=FormType.login;
               });
                      },
                          child: Container(
                        width: 200,
                        height: 40.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.yellowAccent,
                          color: Colors.yellow[800],
                          elevation: 7.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:[
                                Icon(Icons.arrow_back,color: Colors.white,),
                                SizedBox(width: 10,),
                                Text(
                                'Back to login',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat'),
                              ),
                              ] 
                            ),
                        ),
                      ),
                    ),
          SizedBox(height: 5,),
          Text(error,style: TextStyle(color: Colors.red,fontSize: 14),)
        ];
      }
  }
  List <Widget> inputs(){
    if(_formtype==FormType.login){
      return[
           Image(
           width: 200,
           height: 200,
          image: AssetImage('assets/login_logo.png'),
          ),
         SizedBox(height: 15,),
         TextFormField(
           cursorColor:Colors.orange,
         decoration: const InputDecoration(
         icon: Icon(Icons.email,color: Colors.orange,),
         focusedBorder:OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.orange, width: 2.0),
          ),
         border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10),)
                ),
        hintText: 'Email',
        labelText: 'Email *',
        labelStyle: TextStyle(color:Colors.orange)
        ),
      validator: (val){
       return val.isEmpty? 'email canot be empty':null;
       },
       onSaved: (value)=>_username=value,
        ),
        SizedBox(height: 5,),
        TextFormField(
        decoration:InputDecoration(
        icon: Icon(Icons.lock_outline,color: Colors.orange,),
        focusedBorder:OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.orange, width: 2.0),
          ),
         border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10),)
                ),
        hintText: 'Password',
        labelText: 'Password *',
        labelStyle: TextStyle(color:Colors.orange)
         ),
         
         obscureText: obscureText,
         validator: (val){
         return val.isEmpty? 'password canot be empty':null;
         },
         onSaved: (value)=>_password=value,
         ),  
    ];
    }else{
      return[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                  child: Text(
                    'Sign up',
                    style:
                        TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(7, 30, 7, 0),
                  child: Text(
                    '.',
                    style: TextStyle(
                        fontSize: 55,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange),
                  ),
                ),
            ],
          ),
               
         SizedBox(height: 5,),
         TextFormField(
           cursorColor: Colors.orange,
         decoration: const InputDecoration(
           focusedBorder:OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.orange, width: 2.0),
          ),
         border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10),)
                ),
         icon: Icon(Icons.email,color: Colors.orange,),
        hintText: 'Email',
        labelText: 'Email *',
        labelStyle: TextStyle(color: Colors.orange),
        ),
        controller: _emailcon,
      validator: (val){
       return val.isEmpty? 'email canot be empty':null;
       },
       onSaved: (value)=>_username=value,
        ),
        SizedBox(height: 5,),
         TextFormField(
         cursorColor: Colors.orange,
         decoration: const InputDecoration(
           focusedBorder:OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.orange, width: 2.0),
          ),
         border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10),)
                ),
         icon: Icon(Icons.person,color: Colors.orange,),
        hintText: 'Name',
        labelText: 'Name *',
        labelStyle: TextStyle(color: Colors.orange),
        ),
        controller: _namecon,
      validator: (val){
       return val.isEmpty? 'name canot be empty':null;
       },
       onSaved: (value)=>_name=value,
        ),
        SizedBox(height: 5,),
        TextFormField(
        cursorColor: Colors.orange,
         decoration:  InputDecoration(
           focusedBorder:OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.orange, width: 2.0),
          ),
         border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10),)
                ),
         icon: Icon(Icons.lock_outline,color: Colors.orange,),
         
        hintText: 'Password',
        labelText: 'password *',
        labelStyle: TextStyle(color: Colors.orange),
        ),
         obscureText: obscureText,
         controller: _pass,
         validator: (val){
         if(val.isEmpty){
           return 'password canot be empty';
         }else if(val.length<6){
           return 'password should be more than 6 character';
         }else{
           return null;
         }
         },
         onSaved: (value)=>_password=value,
         ),
         SizedBox(height: 5,), 
    ];
    }
    
  }
}

