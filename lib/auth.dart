import 'package:firebase_auth/firebase_auth.dart';
class Auth{
  Future loginEmailandpass(String email,String password)async{
    try{
  AuthResult result=await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  FirebaseUser user=result.user;
  return user;
  }catch(e){
    print('error: $e');
  }
  }
  Future registerEmailandpass(String email,String password)async{
    try{AuthResult result=await FirebaseAuth.instance.createUserWithEmailAndPassword(email:email, password: password);
    FirebaseUser user=result.user;
    return user;
    }catch(e){
      print('error: $e');
    }
  }
  
}