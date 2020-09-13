import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/screens/Dialog.dart';
import 'package:chat_app/screens/imageConvo.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
//import 'package:http/http.dart' as http;
//import 'package:path_provider/path_provider.dart';
//import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'imageConvo.dart';


class ConversationScreen extends StatefulWidget {

  String chatRoomId;
  ConversationScreen(this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageEditingController = new TextEditingController();

  Stream chatMessageStream;

  File cameraImage;
  File galleryImage;
  String galleryImageURL;

  String textValue = "Hello bad Guys";



  Widget ChatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return MessageTile(
                snapshot.data.documents[index].data()["message"],
//                snapshot.data.documents[index].data()["image"],
                snapshot.data.documents[index].data()["sendBy"] ==
                    Constants.myName,
                widget.chatRoomId,
                snapshot.data.documents[index].data()["time"],
              );
            }
        ) : Container();
      },
    );
  }

  sendMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageEditingController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageEditingController.text = "";
    }
  }

  Future getImage() async {
    galleryImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (galleryImage != null) {
      setState(() {
        galleryImageURL = basename(galleryImage.path);
      });
      print(galleryImageURL);
    }
  }


  @override
  void initState() {
    super.initState();

    databaseMethods.getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(),
          body: Container(
            child: Stack(
              children: <Widget>[
                ChatMessageList(),
                Container(
                  padding: EdgeInsets.only(top: 10.0),
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .width / 6,
                    color: Colors.grey[200],
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: messageEditingController,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: "Message",
                              hintStyle: TextStyle(
                                color: Colors.deepOrangeAccent,
                              ),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {

                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
//                            getImage();
////                            sendImage();
//                            setState(() {
//                              galleryImage = null;
      Navigator.push(context, MaterialPageRoute(
      builder: (context) => ImageConversations(widget.chatRoomId)
      ));
                            },

                          child: Container(
                              child: Icon(Icons.photo,
                                color: Colors.deepOrangeAccent, size: 30.0,)
                          ),
                        ),
                        SizedBox(width: 20.0,),
                        GestureDetector(
                          onTap: () {
                            sendMessage();
                            messageEditingController.text = null;
                          },
                          child: Container(
                              child: Icon(Icons.send,
                                color: Colors.deepOrangeAccent, size: 30.0,)
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
      );
    }
  }


class MessageTile extends StatefulWidget {
  final String message;
  final bool isSendByMe;
//  final String imageURL;
  final String chatRoomId;
  final int time;



  MessageTile(this.message, this.isSendByMe,  this.chatRoomId, this.time);

  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {

  Dialogs dialogs = new Dialogs();

  DatabaseMethods databaseMethods = new DatabaseMethods();

  File imageFile;

  @override
  void initState() {
    super.initState();

//    urlToFile(widget.imageURL);
  }

//  Future<File> urlToFile(String imageUrl) async {
//    var rng = new Random();
//
//    Directory tempDir = await getTemporaryDirectory();
//
//    String tempPath = tempDir.path;
//
//    File returnFile = new File('$tempPath'+(rng.nextInt(100)).toString() +'.png');
//
//    http.Response response = await http.get(imageUrl);
//
//    await returnFile.writeAsBytes(response.bodyBytes);
//    setState(() {
//      imageFile = returnFile;
//    });
//  }



  @override
  Widget build(BuildContext context) {
     return
//       (widget.imageURL != null) ?
//          Container(
//            height: 100,
//           width: 100,
//           child: Image.file(imageFile),
//
//         ):
      GestureDetector(
      onLongPress: () {
//        dialogs.information(context, "Do you want to delete", "");
        databaseMethods.getDocumentID(widget.chatRoomId, widget.message, widget.time);

      },
      child: Container(
        padding: EdgeInsets.only(left: widget.isSendByMe ? 0 : 24, right: widget.isSendByMe ? 24 : 0,),
        margin: EdgeInsets.symmetric(vertical: 8),
        width: MediaQuery.of(context).size.width,
        alignment: widget.isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: widget.isSendByMe ? [
                          const Color(0xFFFF9800),
                          const Color(0xFFFF6D00)
                        ] : [
                          const Color(0xFFEFEBE9),
                          const Color(0xFFBCAAA4)
                        ]
                    ),
                    borderRadius: widget.isSendByMe ?
                    BorderRadius.only(topLeft: Radius.circular(23), bottomLeft: Radius.circular(23), bottomRight: Radius.circular(23))
                        : BorderRadius.only(topRight: Radius.circular(23), bottomRight: Radius.circular(23), bottomLeft: Radius.circular(23))
                ),
                child: Column(
                  children: <Widget>[
                    Text(widget.message, style: TextStyle(
                      fontSize: 17.0,
                      color: widget.isSendByMe ? Colors.white54 : Colors.black,
                    )),
                  ],
                ),
            ),
            SizedBox(height: 10.0,),
            Text(DateTime.fromMillisecondsSinceEpoch(widget.time).toString(), style: TextStyle(
              fontSize: 12.0,
              color: widget.isSendByMe ? Colors.white54 : Colors.black,
            )),
          ],
        ),

      ),
    );

  }
}

