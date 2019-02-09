import 'homePage.dart';
import 'signUpPage.dart';
import 'signInPage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'playerPage.dart';
import 'userPage.dart';
import 'searchPage.dart';

void main(){
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  ).then((_){
    runApp(new MusicPlayerApp());
  });
}

class MusicPlayerApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new  MaterialApp(
      title: "Music Streaming App",
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new HomePage(),
        '/signIn': (BuildContext context) => new SignInPage(),
        '/signUp': (BuildContext context) => new SignUpPage(),
        '/player': (BuildContext context) => new PlayerPage(),
        '/search': (BuildContext context) => new SearchPage(),
        '/user': (BuildContext context) => new UserPage(),
      },
      home: new HomePage(),
    );
  }
}

