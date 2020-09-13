import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/screens/chatRoom.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/helper/authenticate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignIn extends StatefulWidget {

  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final formKey = GlobalKey<FormState>();

  AuthMethods authMethods = new AuthMethods();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;

  signIn() {
    if(formKey.currentState.validate()) {
      HelperFunctions.saveUserEmail(emailTextEditingController.text);

      databaseMethods.getUserByUserEmail(emailTextEditingController.text)
          .then((value) {
            snapshotUserInfo = value;
            HelperFunctions.saveUserEmail(snapshotUserInfo.documents[0].data()['email']);
          });

      setState(() {
        isLoading = true;
      });
      
      authMethods.signInWithEmailAndPassword(snapshotUserInfo.documents[0].data()['email'],
          passwordTextEditingController.text).then((value) {
            if(value != null) {
              HelperFunctions.saveUserLoggedIn(true);
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => ChatRoom()
              ));
            }
            else{
              print("Didn't sign in");
            }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyCustomAppBar(
        height: 240,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: <Widget>[
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      validator: (value) {
//                        return RegExp(
//                            r"^WS{1,2}:\/\/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:56789").hasMatch(value)
//                            ? null : "Please provide a alid email ID";
                      return null;
                      },
                      controller: emailTextEditingController,
                      enabled: true,
                      decoration: InputDecoration(
                        labelText: "Email ID" ,
                        labelStyle: TextStyle(
                          color: Colors.deepOrangeAccent,
                          fontSize: 20.0,
                        ),
                        fillColor: Colors.grey[200],
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                      ),
                      autofocus: true,
                      onChanged: (name) {

                      },
                    ),
                    SizedBox(height: 20.0,),
                    TextFormField(
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      validator: (value) {
//                        return value.length > 6 ? null : "Enter a password containing more than 6 characters";
                      return null;
                      },
                      controller: passwordTextEditingController,
                      enabled: true,
                      decoration: InputDecoration(
                        labelText: "Password" ,
                        labelStyle: TextStyle(
                          color: Colors.deepOrangeAccent,
                          fontSize: 20.0,
                        ),
                        fillColor: Colors.grey[200],
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                      ),
                      autofocus: true,
                      onChanged: (name) {

                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.0,),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60.0,
                  child: RaisedButton(
                    splashColor: Colors.deepOrangeAccent,
                    color: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text("Sign In", style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),),
                    onPressed: () {
                      signIn();
                    },
                  ),
                ),

              SizedBox(height: 20.0,),
              Padding(
                padding: EdgeInsets.all(0.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text("Dont Have An Account ?", style: TextStyle(
                            color: Colors.red,
                            fontSize: 20.0,
                          ),),
                        ),
                      ),
                      SizedBox(width: 10.0,),
                      GestureDetector(
                        onTap: () {
                          widget.toggle();
                        },
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.all(0),
                            child:  Align(
                              alignment: Alignment.topRight,
                              child: Text("Register Now", style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20.0,
                                decoration: TextDecoration.underline,
                              ),),
                            ),
                          ),
                        ),
                      )



                    ],
                  ),
                ),
              )


            ],
          ),
        ),
      ),
    );
  }
}



class MyCustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  final double height;

  const MyCustomAppBar({
    Key key,
    @required this.height,
  }) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 30.0),
            child: AppBar(
              title: Text("Chat Me"),


            ),

          ),

        ),

      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}
