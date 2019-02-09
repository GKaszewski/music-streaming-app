import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'playerPage.dart';
import 'appData.dart' as AppData;

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }

}

class HomePageState extends State<HomePage>{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void openSignInPage() {
    Navigator.of(context).pushNamed('/signIn');
  }

  Future<void> loadPlayerPage(FirebaseUser user) async{
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => new PlayerPage(user: user,)));
  }

  Future<void> checkIfUserIsAlreadyLoggedIn() async{
    if(await _auth.currentUser() != null){
      FirebaseUser user = await _auth.currentUser();
      AppData.user = user;
      loadPlayerPage(user);
      print(user.displayName);
    }
  }

  @override
  void initState(){
    super.initState();
    checkIfUserIsAlreadyLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            new Text("Welcome to Music Streaming App!", style: TextStyle(color: Colors.red),),
            new RaisedButton(
              onPressed: openSignInPage,
              color: Colors.red,
              child: Text("Sign in", style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }

}