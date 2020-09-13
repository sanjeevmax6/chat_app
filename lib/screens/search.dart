

import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/screens/convos.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController searchTextEditingController = new TextEditingController();

   QuerySnapshot searchSnapshot;

  initiateSearch() {
    databaseMethods.getUserByUsername(searchTextEditingController.text)
        .then((value) {
          if(value == null) {
            databaseMethods.getUserByUserEmail(searchTextEditingController.text)
                .then((val) {
                  setState(() {
                    searchSnapshot = value;
                  });
            });
          }
          setState(() {
            searchSnapshot = value;
          });
        });
  }
  createChatRoomAndStartConvo( {String userName} ) {

    if(userName != Constants.myName) {
      String chatRoomId = getChatRoomId(userName, Constants.myName);

      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users" : users,
        "chatroomId": chatRoomId
      };

      databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(chatRoomId),
      ));
    }
    else{
      Scaffold.of(context).showSnackBar(const SnackBar(
        content: Text("You can't text yourself"),
      ));
    }


  }

  Widget ListTiles(String userName,
   String userEmail) {
    return GestureDetector(
      onTap: () {
        createChatRoomAndStartConvo(userName: userName);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Card(
          color: Colors.black,
          child: Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(userName, style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.orange,
                  ),),
                  SizedBox(height: 10.0,),
                  Text(userEmail, style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.deepOrangeAccent,
                  ),),
                ],
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.deepOrangeAccent,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(Icons.verified_user, color: Colors.white,),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget searchList() {
    return searchSnapshot != null ? ListView.builder(
      itemCount: searchSnapshot.documents.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
        return ListTiles(
            searchSnapshot.documents[index].data()['name'],
           searchSnapshot.documents[index].data()["email"]
        );
        }) : Container();
  }

  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child:  Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: searchTextEditingController,
                      style: TextStyle(
                color: Colors.orange,
                      ),
                      decoration: InputDecoration(
                        hintText: "Search Username",
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        initiateSearch();
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                      child:  Icon(Icons.search, color: Colors.white,)
                    ),
                  ),

                ],
              ),
            ),
            searchList(),

          ],
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
            child: AppBar(),

          ),

        ),

      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}

getChatRoomId(String a, String b) {
  if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)) {
    return "$b\_$a";
  }
  else{
    return "$a\_$b";
  }
}



//class ListTiles extends StatelessWidget {
//
//  final String userName;
//  final String userEmail;
//
//  ListTiles(this.userName, this.userEmail);
//
//  @override
//  Widget build(BuildContext context) {
//    return
//  }
//
//
//
//}


