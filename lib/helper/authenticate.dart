import 'package:chat_app/screens/signin.dart';
import 'package:chat_app/screens/signup.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {



  bool showSignedIn = true;

  void toggleView() {
    setState(() {
      showSignedIn = !showSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
     if(showSignedIn) {
      return SignIn(toggleView);
    }
     else{
       return SignUp(toggleView);
     }
  }
}
