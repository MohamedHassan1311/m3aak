import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Edite_level extends StatefulWidget {
  @override
  _Edite_levelState createState() => _Edite_levelState();
}

class _Edite_levelState extends State<Edite_level> {
  Map data={'user':'no email'};
  @override
  Widget build(BuildContext context) {
  data=data.isEmpty?data:ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit user level'),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.trending_up,color: Colors.blue,),
          SizedBox(width: 15,),
          DropdownButton<String>(
      value: data['level'],
      focusColor: Colors.blue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.black),
      underline: Container(
        height: 1.55,
        color: Colors.grey[500],
      ),
      onChanged: (String newValue) {
        setState(() {
          data['level'] = newValue;
        });
      },
      hint: Text('level'),
      items: <String>['disable', 'admin', 'sub admin','driver','bus','tourist']
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
      RaisedButton.icon(
            color: Colors.orange[800],
                    icon: Icon(Icons.create,color: Colors.white,),
                    label: Text('Save',style: TextStyle(color: Colors.white),),
                    onPressed: (){ 
                        if(data['level']=='driver'||data['level']=='bus'||data['level']=='tourist'){
            Firestore.instance.collection('location').document(data['uid']).setData({
            'uid':data['uid'],
            'live':false,
            'latitude': '30.0443677',
            'longitude':'31.2359946',
            'accuracy':'5.0',
            'heading':'0.0',
          });
          Firestore.instance.collection('users').document(data['uid']).updateData({
            'level':data['level'],
            'map':true,
            'choosen':'yes',
          });
                        }else if(data['level']=='disable'||data['level']=='admin'||data['level']=='sub admin'){
          Firestore.instance.collection('users').document(data['uid']).updateData({
            'level':data['level'],
            'map':false,
          }); 
                        }
                        Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: 15,),
                  RaisedButton.icon(
                    color: Colors.orange,
                    icon: Icon(Icons.cancel,color: Colors.white,),
                    label: Text('Cancle',style: TextStyle(color: Colors.white),),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
          ],
        ),
      ),
    );
  }
}