import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new SignUpPageState();
}

class SignUpPageState extends State<SignUpPage>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Sign in", style: new TextStyle(color: Colors.red),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: new Center(
        child: new Column(
          children: <Widget>[
            new RaisedButton(
              onPressed: () {},
              color: Colors.red,
              textColor: Colors.white,
              child: new Text("Sign up with Facebook"),
            ),
            new RaisedButton(
              onPressed: () {},
              color: Colors.red,
              textColor: Colors.white,
              child: new Text("Sign up with Google"),
            )
          ],
        ),
      ),
    );
  }
}
