import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_streaming_app/playerPage.dart';
import 'package:music_streaming_app/song.dart';
import 'appData.dart' as AppData;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flushbar/flushbar.dart';

class SearchPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new SearchPageState();
  }

}

class SearchPageState extends State<SearchPage>{
  Song _song = new Song(albumUrl: "", audioUrl: "", songAuthor: "", songName: "", albumName: "", tags: null);
  
  Future<void> loadPlayerPage(FirebaseUser user, Song song) async{
    Navigator.of(context).pop();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => new PlayerPage(user: user)));
  }

  final TextEditingController textEditingController = new TextEditingController();

  Future<Song> getSong(String name) async{
    String apiUrl = "https://streaming-platform-service.herokuapp.com/song/${name}";
    var response = await http.get(apiUrl);
    if(response.statusCode == 200){
      print(Song.fromJson(json.decode(response.body)).songName);
      return Song.fromJson(json.decode(response.body));
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Search", style: TextStyle(color: Colors.red), textAlign: TextAlign.center,),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: new IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.red,
          onPressed: (){
            loadPlayerPage(AppData.user, _song);
          }
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: new TextField(
                decoration: new InputDecoration(
                  hintText: "Type in here your song name",
                  hintStyle: TextStyle(color: Colors.redAccent),
                ),
                controller: textEditingController,
                onSubmitted: (String str) {
                  searchSong(str, context);
                },
              ),
            ),
            new Expanded(child: new Container(),),
            
            new BottomPanel(),
          ],
        ),
      ),
    );
  }

  Future<void> searchSong(String str, BuildContext context) async{
    _song = await getSong(str.toLowerCase());
    if(_song.songName != null){
      AppData.userQueue.add(_song);
      var notification = new Flushbar(
        message: "Added ${_song.songAuthor} - ${_song.songName} to queue.",
        duration: Duration(seconds: 2),
        flushbarPosition: FlushbarPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
      notification.show(context);
    }
    else if(_song.songName == null){
      _song = new Song(albumUrl: "", audioUrl: "", songAuthor: "", songName: "", albumName: "", tags: null);
      var errorNotifictionBar = new Flushbar(
        message: "Couldn't find: ${str}!",
        duration: Duration(seconds: 4),
        flushbarPosition: FlushbarPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
      errorNotifictionBar.show(context);
    }
    textEditingController.text = "";
  }

}