import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_streaming_app/playerPage.dart';
import 'appData.dart' as AppData;
import 'bottomControls.dart';

class UserPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new UserPageState();
  }
}

class UserPageState extends State<UserPage>{

  Future<void> loadPlayerPage() async{
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(""),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: new IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.red,
          onPressed: (){
            loadPlayerPage();
          }
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new ClipOval(
              clipper: new CircleClipper(),
              child: Image.network(
                AppData.user.photoUrl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: new Text(AppData.user.displayName, style: TextStyle(color: Colors.redAccent, fontSize: 24), textAlign: TextAlign.center,),
            ),
            new Text(AppData.user.email, style: TextStyle(color: Colors.redAccent, fontSize: 14), textAlign: TextAlign.center,),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: new Row(children: <Widget>[
                new Expanded(child: Container(),),
                new Text("Followers: \n${AppData.followers}", style: TextStyle(color: Colors.redAccent, fontSize: 16,),textAlign: TextAlign.center,),
                new Expanded(child: Container(),),
                new Text("Following: \n${AppData.following}", style: TextStyle(color: Colors.redAccent, fontSize: 16),textAlign: TextAlign.center,),
                new Expanded(child: Container(),),
              ],
              ),
            ),
            new Expanded(child: new Container(),),
            new BottomPanel(),
          ],
        ),
      ),
    );
  }

}