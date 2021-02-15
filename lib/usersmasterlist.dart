import 'package:flutter/material.dart';
import 'loading.dart';
class Usersmasterlist extends StatefulWidget {
  @override
  _UsersmasterlistState createState() => _UsersmasterlistState();
}

class _UsersmasterlistState extends State<Usersmasterlist> {
  bool load=false;
  Widget list_row (String name,String title,String pic,String path,String gridname){
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Card(
        shadowColor: Colors.blue,
        margin: EdgeInsets.fromLTRB(1, 1, 1, 0),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: InkWell(
          onTap: (){
            Navigator.pushNamed(context, path);
          },
          child:Column(
            children: [
              Image(
                      image: AssetImage('assets/$pic'),
                      height: 35,
                      width: 35,
                    ),
                    SizedBox(height: 7,),
                  Text(
                      name,
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13,fontFamily: 'Montserrat'),
                    ), 
            ],
          ),
          ),
        ),
              ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return load?loading(): Scaffold(
              backgroundColor: Colors.lightBlueAccent[50], 
              body: SafeArea(child: Column(
                children: [
                  Container(
                   width: MediaQuery.of(context).size.width,
                   height: 70,
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         IconButton(
                           icon: Icon(Icons.arrow_back_rounded),
                           onPressed: (){
                             Navigator.pop(context);
                           },
                         ),
                         SizedBox(width: 7,),
          Text('All users',style: TextStyle(fontSize: 16,color: Colors.blue,fontWeight:FontWeight.bold),),
                       ],
                     ),
                   ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height-300,
                    child: Padding(
                  padding: EdgeInsets.fromLTRB(4, 0,4, 0),
                  child: GridView.count(
                    mainAxisSpacing: 5,
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    primary: false,
                 children: [
                   list_row('Drivers', '', 'user.png', '/driverusermasterlist','drivers'),
                   list_row('Bus', '', 'bus_icon.png', '/bususermasterlist','bus'),
                   list_row('Admins', '', 'admin_icon.png', '/adminusermasterlist','admins'),
                   list_row('Sub admin', '', 'subadmin_icon.png', '/subadminusermasterlist','sub admin'),
                   list_row('tourist', '', 'tour_icon.png', '/touristmasterlist','tourist'),
                   list_row('Disable users', '', 'Users.png', '/disableusermasterlist','disable'),     
                 ],
                ),
                  ),
                  ),
                ],
              )),
            );
  }
}