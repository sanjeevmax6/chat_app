import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/screens/chatRoom.dart';
import 'package:flutter/material.dart';
import 'helper/authenticate.dart';
import 'screens/signin.dart';
import 'screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      MyApp()
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

//  bool userIsLoggedIn = false;

  @override
  void initState() {
    super.initState();
//    getLoggedInState();
  }

//  getLoggedInState() async {
//    await HelperFunctions.getUserLoggedIn().then((value) {
//      setState(() {
//        userIsLoggedIn = value;
//      });
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Me',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white10,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:  Authenticate(),
    );
  }
  
  
}

class Animation extends StatefulWidget {
  @override
  _AnimationState createState() => _AnimationState();
}

class _AnimationState extends State<Animation> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

//userIsLoggedIn ? ChatRoom() :


//return SplashScreen(
//seconds: 5,
//backgroundColor: Colors.black,
//image: Image.asset("assets/loading.gif"),
//loaderColor: Colors.white,
//photoSize: 150,
//navigateAfterSeconds: MainScreen(),
//);

//userIsLoggedIn ? ChatRoom() :
