import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {

  static String sharedPreferenceUserLoggedInKey = 'iSLOGGEDIN';
  static String sharedPreferenceUserNameKey = 'USERNAMEKEY';
  static String sharedPreferenceUserEmailKey = 'USEREMAILKEY';


  static Future<bool> saveUserLoggedIn(bool isUserLoggedIn) async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);

  }

  static Future<bool> saveUserName(String userName) async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceUserNameKey, userName);

  }

  static Future<bool> saveUserEmail(String userEmail) async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(sharedPreferenceUserEmailKey, userEmail);

  }

  static Future<bool> getUserLoggedIn() async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getBool(sharedPreferenceUserLoggedInKey);

  }

  static Future<String> getUserName() async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserNameKey);

  }

  static Future<String> getUserEmail() async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserEmailKey);

  }
}
