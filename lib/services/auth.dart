import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/modal/user.dart';

class AuthMethods {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;

  textUser _userFromFirebaseUser(FirebaseUser resultUser) {
    return resultUser != null ? textUser(userId: resultUser.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
//    try{
////      UserCredential result = await _auth.signInWithEmailAndPassword
////        (email: email, password: password);
////      FirebaseUser firebaseUser = result.user;
////      return _userFromFirebaseUser(firebaseUser);
//      FirebaseUser firebaseUser = (await FirebaseAuth.instance.
//      signInWithEmailAndPassword(email: email, password: password))
//          .user;
//      return _userFromFirebaseUser(firebaseUser);
//    }
//    catch(error){
//      print(error.toString());
//    }
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser someUser = result.user;
      return someUser.uid;
    } catch (e) {
      print(e.toString());
      return null;
    }
//  FirebaseAuth.instance.signInWithEmailAndPassword(
//      email: email,
//      password: password)
//      .then((currentUser) => Firestore.instance.collection("users").get()
//
//  )
  }

  Future signUpwithEmailAndPassword(String email, String password) async{
    
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword
        (email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    }
    catch(error) {
      print(error.toString());
    }
  }

  Future resetPass(String email) async {
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }
    catch(error) {
      print(error.toString());
    }
  }

  Future signOut() async {
    try{
      return await _auth.signOut();
    }
    catch(error){
      print(error.toString());
    }
  }

}