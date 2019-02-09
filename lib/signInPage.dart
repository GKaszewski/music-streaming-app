import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'appData.dart' as AppData;
import 'playerPage.dart';

class SignInPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new SignInPageState();
  }
}

class SignInPageState extends State<SignInPage>{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  bool isLoading = false;

  @override
  void initState(){
    super.initState();
  }

  Future<void> loadPlayerPage(FirebaseUser user) async{
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => new PlayerPage(user: user,)));
  }

  Future<void> signInWithGoogle() async{
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication authentication = await googleSignInAccount.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: authentication.accessToken,
      idToken: authentication.idToken,
    );
    FirebaseUser user = await _auth.signInWithCredential(credential);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    AppData.user = currentUser;
    loadPlayerPage(user);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(""),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            /*new RaisedButton(
              color: Colors.red,
              onPressed: () {},
              child: Text("Login with Facebook", style: TextStyle(color: Colors.white),),
            ),*/
            new RaisedButton(
              color: Colors.red,
              onPressed: () => signInWithGoogle(),
              child: Text("Login with Google", style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}