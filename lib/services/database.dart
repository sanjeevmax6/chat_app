import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class DatabaseMethods {

  getUserByUsername(String username) async{
    return await Firestore.instance.collection("users")
        .where("name", isEqualTo: username)
        .getDocuments();
  }

  getUserByUserEmail(String userEmail) async{
    return await Firestore.instance.collection("users")
        .where("email", isEqualTo: userEmail)
        .getDocuments();
  }

  uploadUserInfo(userMap) {
    Firestore.instance.collection("users")
        .add(userMap).catchError((error) {
          print(error.toString());
    });
  }

  createChatRoom( String chatRoomId, chatRoomMap) {
    Firestore.instance.collection("ChatRoom")
        .document(chatRoomId).set(chatRoomMap).catchError((error) {
          print(error.toString());
    });
  }

  addConversationMessages(String chatRoomId, messageMap) async{
    Firestore.instance.collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(messageMap).catchError((error) {
          print(error.toString());
    });
  }

  addImageMessages(String chatRoomId, messageMap) async{
    Firestore.instance.collection("ImageRoom")
        .document(chatRoomId)
        .collection("images")
        .add(messageMap).catchError((error) {
      print(error.toString());
    });
  }

  getConversationMessages(String chatRoomId) async{
    return await Firestore.instance.collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
    .orderBy("time", descending: false)
        .snapshots();
  }

  getImageMessages(String chatRoomId) async{
    return await Firestore.instance.collection("ImageRoom")
        .document(chatRoomId)
        .collection("images")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRooms(String userName) async{
    return await Firestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: userName)
        .snapshots();
  }

  getDocumentID(String chatRoomId, String message, int time) async {
    Firestore.instance.collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .get().then((querySnapshot){
          querySnapshot.documents.forEach((doc) {
            if(doc.data()["message"] == message && doc.data()["time"] == time) {
              doc.reference.delete();
            }
    });
    });
  }


}