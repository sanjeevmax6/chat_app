import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  _launchURL(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Didnt happen");
      throw 'Could not launch $url';

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child:Column(
            children: <Widget>[
              Text("For any queries please contact", style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.deepOrangeAccent
              ),
              ),
              SizedBox(height: 10.0),
              InkWell(
                child: Text('sanvegas2001@gmail.com',style: TextStyle(
                  color: Colors.blue,
                  fontSize: 30.0,
                  decoration: TextDecoration.underline,
                ),),
                onTap: () {
                  _launchURL('sanvegas2001@gmail.com', 'Chat_App Support', '');
                },
              ),
            ],
          ),

        ),

      ),
    );
  }
}
