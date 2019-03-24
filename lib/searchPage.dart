import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_streaming_app/playerPage.dart';
import 'package:music_streaming_app/song.dart';
import 'appData.dart' as AppData;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flushbar/flushbar.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SearchPageState();
  }
}

class SearchPageState extends State<SearchPage> {
  Song _song = new Song(
      albumUrl: "",
      audioUrl: "",
      songAuthor: "",
      songName: "",
      albumName: "",
      tags: null);
  List<Song> searchedSongs = new List<Song>();

  @override
  void initState() {
    // searchedSongs.add(_song);
  }

  Future<void> loadPlayerPage(FirebaseUser user, Song song) async {
    Navigator.of(context).pop();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => new PlayerPage(user: user)));
  }

  final TextEditingController textEditingController =
      new TextEditingController();

  Future<List<Song>> getSongs(String query) async {
    List<Song> songs = new List<Song>();
    String apiUrl =
        "https://streaming-platform-service.herokuapp.com/song/search/${query}";
    var response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      List data;
      var s = json.decode(response.body);
      data = s;
      data.forEach((element) {
        var song = Song.fromJson(element);
        songs.add(song);
        print(song.songName);
      });

      print(songs.length);
      return songs;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          "Search",
          style: TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: new IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.red,
            onPressed: () {
              loadPlayerPage(AppData.user, _song);
            }),
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
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: new ListView.builder(
                    itemBuilder: (ctxt, i){
                      var song =searchedSongs[i];
                      return ListTile(
                        title: SongWidget(song),
                      );
                    },
                    itemCount: searchedSongs.length,
              ),
                ),
            ),

            new BottomPanel(),
          ],
        ),
      ),
    );
  }

  Future<void> searchSong(String str, BuildContext context) async {
    var songs = await getSongs(str);
    setState(() {
      songs.forEach((song){
        searchedSongs.add(song);
      });
    });
    textEditingController.text = "";
  }
}

class SongWidget extends StatelessWidget {
  final Song _song;

  SongWidget(Song song) : _song = song {}

  Future<void> addSongToQuery(Song song, BuildContext context) async {
    if (song != null || song.songName != "") {
      AppData.userQueue.add(song);
      var notification = new Flushbar(
        message: "Added ${song.songAuthor} - ${song.songName} to queue.",
        duration: Duration(seconds: 2),
        flushbarPosition: FlushbarPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.6),
      );
      notification.show(context);
    } else {
      var notification = new Flushbar(
        message:
            "Couldn't find ${song.songAuthor} - ${song.songName} in database!",
        duration: Duration(seconds: 2),
        flushbarPosition: FlushbarPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.6),
      );
      notification.show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.black45.withOpacity(0.1),
      child: Row(
        children: <Widget>[
          new RawMaterialButton(
            shape: CircleBorder(),
            fillColor: Colors.white,
            splashColor: Colors.white12,
            highlightColor: Colors.white12.withOpacity(.5),
            onPressed: () {
              addSongToQuery(_song, context);
            },
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Icon(Icons.add, color: Colors.red),
            ),
          ),
          Text(_song.songName + "\n ${_song.songAuthor}", style: TextStyle(color: Colors.red),),
        ],
      ),
    );
  }
}
