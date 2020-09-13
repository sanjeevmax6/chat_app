import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/screens/convos.dart';
import 'package:chat_app/screens/search.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'About.dart';
import 'signin.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:random_color/random_color.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream chatRoomsStream;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
            return ChatRoomsTile(
              snapshot.data.documents[index].data()["chatroomId"]
                  .toString().replaceAll("_", "")
                  .replaceAll(Constants.myName, ""),
                snapshot.data.documents[index].data()["chatroomId"]
            );
            }) : Container();
      },
    );
  }

  @override
  void initState() {
    super.initState();

    getUserInfo();

  }




  getUserInfo() async {

    Constants.myName = await HelperFunctions.getUserName();
    databaseMethods.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRoomsStream = value;
      });

    });
    setState(() { });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text("Chat Me"),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => Authenticate()
              ));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      body: chatRoomList(),
      floatingActionButton:
      Container(
        padding: EdgeInsets.only(top: 100.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => Search()
            ));
          },
          backgroundColor: Colors.orange,
          child: Icon(Icons.search, color: Colors.white,),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
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
              actions: <Widget>[
                GestureDetector(
                  onTap: () {

                  },
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Icon(Icons.exit_to_app),
                    ),
                ),


              ],


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


class ChatRoomsTile extends StatelessWidget {

  final String username;
  final String chatRoomId;

  RandomColor _randomColor = RandomColor();

  ChatRoomsTile(this.username, this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ConversationScreen(chatRoomId)
        ));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: <Widget>[
            Container(
              height: 40,
             width: 40,
             alignment: Alignment.center,
             decoration: BoxDecoration(
               color: _randomColor.randomColor(),
               borderRadius: BorderRadius.circular(40)
             ),
              child: Text("${username.substring(0, 2).toUpperCase()}", style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),),
            ),
              SizedBox(width: 8.0,),
              Text(username, style: TextStyle(
                fontSize: 25.0,
                color: Colors.white,
              ),),
          ],
        ),
      ),
    );
  }
}

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.contacts, size: 75.0,color: Color.fromRGBO(34, 100, 144, 100),),
                    SizedBox(width: 50.0,),
                    Text(Constants.myName, style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0,),
              ],
            ),


            decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/profile_background.jpg")
                )
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ChatRoom(),
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_basket),
            title: Text("About"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => About(),
              ));
            },
          ),

        ],
      ),
    );
  }
}
