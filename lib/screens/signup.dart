import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/screens/signin.dart';
import 'package:chat_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chatRoom.dart';
import 'package:chat_app/services/database.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SignUp extends StatefulWidget {

  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();


  final formKey = GlobalKey<FormState>();

  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  File galleryImage;
  var downloadUrl;

  signMeUp() {
    if (formKey.currentState.validate()) {


        Map<String, String> userInfoMap = {
          "name": userNameTextEditingController.text,
          "email": emailTextEditingController.text,
          "profilePic": downloadUrl
        };

        HelperFunctions.saveUserEmail(emailTextEditingController.text);
        HelperFunctions.saveUserName(userNameTextEditingController.text);

        setState(() {
          isLoading = true;
        });

        authMethods.signUpwithEmailAndPassword
          (emailTextEditingController.text,
            passwordTextEditingController.text).then((value) {
          print("$value");


          databaseMethods.uploadUserInfo(userInfoMap);
          HelperFunctions.saveUserLoggedIn(true);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => ChatRoom()
          ));
        });
      }
    }


  Future _camera() async {
    galleryImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    int timestamp = new DateTime.now().millisecondsSinceEpoch;
    StorageReference storageReference = FirebaseStorage.instance.ref().child(
        "img_" + timestamp.toString() + ".jpg");

    StorageUploadTask uploadTask = storageReference.put(galleryImage);

    var storageTaskSnapshot = await uploadTask.onComplete;
    downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    if (downloadUrl != null) {
      print(downloadUrl);
    }
    setState(() {
      downloadUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyCustomAppBar(
        height: 240,
      ),
      body: isLoading? Container(
        child:
        Center(
          child: CircularProgressIndicator(),
        ),
      ): SingleChildScrollView(
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
                        return value.isEmpty || value.length < 2 ?  "Enter a valid Username" : null;
                      },
                      enabled: true,
                      decoration: InputDecoration(
                        labelText: "User Name" ,
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
                      controller: userNameTextEditingController,
                    ),
                    TextFormField(
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      validator: (value) {
//                       return RegExp(
//                           r"^WS{1,2}:\/\/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:56789").hasMatch(value)
//                           ? null : "Please provide a alid email ID";
                      return null;
                      },
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
                      controller: emailTextEditingController,
                    ),
                    SizedBox(height: 20.0,),
                    TextFormField(
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      obscureText: true,
                      validator: (value) {
                        return value.length > 6 ? null : "Enter a password containing more than 6 characters";
                      },
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
                      controller: passwordTextEditingController,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30.0,),
              GestureDetector(
                onTap: () {
                  signMeUp();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60.0,
                  child: RaisedButton(
                    splashColor: Colors.teal[500],
                    color: Colors.deepOrangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text("Sign Up", style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),),
                    onPressed: () {
                      signMeUp();
                    },
                  ),

                ),
              ),
              SizedBox(height: 30.0,),
              GestureDetector(
                onTap: () {
                 _camera();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width/2,
                  height: 45.0,
                  child: RaisedButton(
                    splashColor: Colors.teal[500],
                    color: Colors.deepOrangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text("Profile Picture", style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),),
                    onPressed: () {
                      _camera();
                    },
                  ),

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
                      Container(
                          child: Padding(
                            padding: EdgeInsets.all(0),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Text("Already have an account ?", style: TextStyle(
                                color: Colors.red,
                                fontSize: 20.0,
                              ),),
                            ),
                          ),
                        ),

                      SizedBox(width: 10.0,),
                      GestureDetector(
                        onTap: () {
                          widget.toggle();
                        },
                        child: Padding(
                            padding: EdgeInsets.all(0),
                            child:  Align(
                              alignment: Alignment.topRight,
                              child: Text("Sign in Now", style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20.0,
                                decoration: TextDecoration.underline,
                              ),),
                            ),
                          ),
                      ),




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