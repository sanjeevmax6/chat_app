

import 'package:chat_app/helper/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:chat_app/services/database.dart';
import 'package:video_player/video_player.dart';
import 'Dialog.dart';


class ImageConversations extends StatefulWidget {

  final String chatRoomId;

  ImageConversations(this.chatRoomId);
  @override
  _ImageConversationsState createState() => _ImageConversationsState();
}

class _ImageConversationsState extends State<ImageConversations> {

  File galleryImage;
  String galleryimageUrl;

  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream chatMessageStream;

  Widget ChatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return MessageTile(
                snapshot.data.documents[index].data()["image"],
                snapshot.data.documents[index].data()["sendBy"] ==
                    Constants.myName,
                widget.chatRoomId,
                snapshot.data.documents[index].data()["time"],
                snapshot.data.documents[index].data()["type"],
              );
            }
        ) : Container();
      },
    );
  }

  Future getImage() async {
    galleryImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    int timestamp = new DateTime.now().millisecondsSinceEpoch;
    StorageReference storageReference = FirebaseStorage.instance.ref().child("img_" + timestamp.toString() + ".jpg");

    StorageUploadTask uploadTask = storageReference.put(galleryImage);

    var storageTaskSnapshot = await uploadTask.onComplete;
    var downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    if(downloadUrl != null) {
      print(downloadUrl);
    }
    Map<String, dynamic> messageMap = {
      "image": downloadUrl,
      "sendBy": Constants.myName,
      "time": DateTime.now().millisecondsSinceEpoch,
      "type": "image"
    };
    databaseMethods.addImageMessages(widget.chatRoomId, messageMap);
  }

  _camera() async {
    galleryImage = await ImagePicker.pickImage(
      source: ImageSource.camera,);
    int timestamp = new DateTime.now().millisecondsSinceEpoch;
    StorageReference storageReference = FirebaseStorage.instance.ref().child("img_" + timestamp.toString() + ".jpg");

    StorageUploadTask uploadTask = storageReference.put(galleryImage);

    var storageTaskSnapshot = await uploadTask.onComplete;
    var downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    if(downloadUrl != null) {
      print(downloadUrl);
    }
    Map<String, dynamic> messageMap = {
      "image": downloadUrl,
      "sendBy": Constants.myName,
      "time": DateTime.now().millisecondsSinceEpoch,
      "type": "image"
    };
    databaseMethods.addImageMessages(widget.chatRoomId, messageMap);
  }

  _video()async{
     galleryImage = await ImagePicker.pickVideo(source: ImageSource.gallery);

     int timestamp = new DateTime.now().millisecondsSinceEpoch;
     StorageReference storageReference = FirebaseStorage.instance.ref().child("img_" + timestamp.toString() + ".jpg");

     StorageUploadTask uploadTask = storageReference.put(galleryImage);

     var storageTaskSnapshot = await uploadTask.onComplete;
     var downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
     if(downloadUrl != null) {
       print(downloadUrl);
     }
     Map<String, dynamic> messageMap = {
       "image": downloadUrl,
       "sendBy": Constants.myName,
       "time": DateTime.now().millisecondsSinceEpoch,
       "type": "video"
     };
     databaseMethods.addImageMessages(widget.chatRoomId, messageMap);
  }

  _record()async{
    galleryImage = await ImagePicker.pickVideo(source: ImageSource.camera);

    int timestamp = new DateTime.now().millisecondsSinceEpoch;
    StorageReference storageReference = FirebaseStorage.instance.ref().child("img_" + timestamp.toString() + ".jpg");

    StorageUploadTask uploadTask = storageReference.put(galleryImage);

    var storageTaskSnapshot = await uploadTask.onComplete;
    var downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    if(downloadUrl != null) {
      print(downloadUrl);
    }
    Map<String, dynamic> messageMap = {
      "image": downloadUrl,
      "sendBy": Constants.myName,
      "time": DateTime.now().millisecondsSinceEpoch,
      "type": "video"
    };
    databaseMethods.addImageMessages(widget.chatRoomId, messageMap);

  }


  @override
  void initState() {
    super.initState();

    databaseMethods.getImageMessages(widget.chatRoomId).then((value) {
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

                    GestureDetector(
                      onTap: () {
                        getImage();
                      },

                      child: Container(
                          child: Icon(Icons.photo,
                            color: Colors.deepOrangeAccent, size: 30.0, semanticLabel: "Gallery",)
                      ),
                    ),
                    SizedBox(width: 20.0,),
                    GestureDetector(
                      onTap: () {
                        _camera();
                      },
                      child: Container(
                          child: Icon(Icons.camera,
                            color: Colors.deepOrangeAccent, size: 30.0,)
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: <Widget>[
//                            GestureDetector(
//                              onTap: () {
//                                _video();
//                              },
//                              child: Container(
//                                  child: Icon(Icons.video_library,
//                                    color: Colors.deepOrangeAccent, size: 30.0,)
//                              ),
//                            ),
//                            SizedBox(width: 20.0,),
//                            GestureDetector(
//                              onTap: () {
//                                _record();
//                              },
//                              child: Container(
//                                  child: Icon(Icons.fiber_manual_record,
//                                    color: Colors.deepOrangeAccent, size: 30.0,)
//                              ),
//                            ),
                          ],
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MessageTile extends StatefulWidget {
  final String imageUrl;
  final bool isSendByMe;
  final String chatRoomId;
  final int time;
  final String type;



  MessageTile(this.imageUrl, this.isSendByMe,  this.chatRoomId, this.time, this.type);

  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return widget.type == "video" ?
//        VideoTile(widget.imageUrl, widget.isSendByMe, widget.chatRoomId, widget.time)
    Container(

    )
        : ImageTile(widget.imageUrl, widget.isSendByMe, widget.chatRoomId, widget.time);

  }
}


class ImageTile extends StatefulWidget {

  final String imageUrl;
  final bool isSendByMe;
  final String chatRoomId;
  final int time;

  ImageTile(this.imageUrl, this.isSendByMe,  this.chatRoomId, this.time);

  @override
  _ImageTileState createState() => _ImageTileState();
}

class _ImageTileState extends State<ImageTile> {

  Dialogs dialogs = new Dialogs();

  DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
        onLongPress: () {
//        dialogs.information(context, "Do you want to delete", "");
          databaseMethods.getDocumentID(widget.chatRoomId, widget.imageUrl, widget.time);

        },
        child: Container(
          padding: EdgeInsets.only(left: widget.isSendByMe ? 0 : 5, right: widget.isSendByMe ? 5 : 0,),
          margin: EdgeInsets.symmetric(vertical: 8),

          alignment: widget.isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width/2,
                height: MediaQuery.of(context).size.height/3,
                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
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
                    BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5))
                        : BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5), bottomLeft: Radius.circular(5))
                ),
                child: Image.network(widget.imageUrl),
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


class VideoTile extends StatefulWidget {

  final String imageUrl;
  final bool isSendByMe;
  final String chatRoomId;
  final int time;

  VideoTile(this.imageUrl, this.isSendByMe,  this.chatRoomId, this.time);
  @override
  _VideoTileState createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {

  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.imageUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height/3,
        width: MediaQuery.of(context).size.width/2,
      child: Column(
        children: <Widget>[
          FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.done) {
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  );
                }
                else{
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }
          ),
          FloatingActionButton(
            onPressed: () {
              // Wrap the play or pause in a call to `setState`. This ensures the
              // correct icon is shown
              setState(() {
                // If the video is playing, pause it.
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  // If the video is paused, play it.
                  _controller.play();
                }
              });
            },
            // Display the correct icon depending on the state of the player.
            child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          )

        ],
      )



    );
  }
}

