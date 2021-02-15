import 'package:dalelak/Addbustodriver.dart';
import 'package:dalelak/Editeuserlevel.dart';
import 'package:dalelak/adminusermasterlist.dart';
import 'package:dalelak/bususermasterlist.dart';
import 'package:dalelak/disableusermasterlist.dart';
import 'package:dalelak/driverusermasterlist.dart';
import 'package:dalelak/home.dart';
import 'package:dalelak/locationsList.dart';
import 'package:dalelak/mapTrackeradmin.dart';
import 'package:dalelak/selecttourist.dart';
import 'package:dalelak/subadminusermasterlist.dart';
import 'package:dalelak/touristusermasterlist.dart';
import 'package:dalelak/userinfo.dart';
import 'package:dalelak/userinfoadmin.dart';
import 'package:dalelak/usersmasterlist.dart';
import 'package:flutter/material.dart';
import 'login_form.dart';
import 'signupinfo.dart';
import 'mapDriver.dart';
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/':(context)=>Login_form(),
      '/home':(context)=>home(),
      '/signupinfo':(context)=>Signupinfo(),
      '/map':(context)=>Map2(),
      '/maptrackeradmin':(context)=>Maptrackeradmin(),
      '/locationList':(context)=>Locationlist(),
      '/users':(context)=>Usersmasterlist(),
      '/driverusermasterlist':(context)=>Driverusermasterlist(),
      '/adminusermasterlist':(context)=>Adminusermasterlist(),
      '/bususermasterlist':(context)=>Bususermasterlist(),
      '/disableusermasterlist':(context)=>Disableusermasterlist(),
      '/userinfo':(context)=>User_info(),
      '/editelevel':(context)=>Edite_level(),
      '/userinfouser':(context)=>Userinfouser(),
      '/addbustouser':(context)=>Addbustodriver(),
      '/subadminusermasterlist':(context)=>Subadmin(),
      '/selecttourist':(context)=>Selecttourist(),
      '/touristmasterlist':(context)=>Touristmasterlist(),
    },
  ));
}