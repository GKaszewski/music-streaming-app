import 'dart:async';
import 'dart:collection';

import 'package:audioplayer/audioplayer.dart';
import 'appData.dart' as AppData;
import 'bottomControls.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'song.dart';

class PlayerPage extends StatefulWidget {
  final FirebaseUser user;

  PlayerPage({Key key, this.user}) : super(key: key);
  @override
  State<StatefulWidget> createState() => new PlayerPageState(user);
}

enum PlayerState {
  PLAYING,
  PAUSED,
  STOPPED,
}

class PlayerPageState extends State<PlayerPage> {
  FirebaseUser user;
  AudioPlayer audioPlayer;
  PlayerState _playerState = PlayerState.STOPPED;
  Duration position;
  Duration duration;
  StreamSubscription _positionSub;
  StreamSubscription _audioPlayerStateSub;
  String displayName = "";
  Queue<Song> tempQueue = new Queue();

  Icon buttonIcon = new Icon(
    Icons.play_arrow,
    color: Colors.red,
    size: 30,
  );
  Song currentSong = new Song(
      albumUrl: "",
      audioUrl: "",
      songAuthor: "",
      songName: "",
      albumName: "",
      tags: null);

  PlayerPageState(this.user) {
    if (currentSong == null) {
      currentSong = new Song(
          albumUrl: "",
          audioUrl: "",
          songAuthor: "",
          songName: "",
          albumName: "",
          tags: null);
    }
  }

  void initAudioPlayer() {
    audioPlayer = new AudioPlayer();
    _positionSub = audioPlayer.onAudioPositionChanged
        .listen((p) => setState(() => position = p));
    _audioPlayerStateSub = audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        setState(() {
          duration = audioPlayer.duration;
        });
      } else if (s == AudioPlayerState.STOPPED) {
        onComplete();
        setState(() {
          position = duration;
        });
      } else if (s == AudioPlayerState.PAUSED) {
        _playerState = PlayerState.PAUSED;
        buttonIcon = Icon(Icons.pause);
        duration = duration;
        position = position;
      }
    }, onError: (msg) {
      setState(() {
        _playerState = PlayerState.STOPPED;
        duration = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    });
  }

  void onComplete() {
    setState(() {
      //AppData.userQueue.removeFirst();
      buttonIcon = Icon(Icons.play_arrow);
      audioPlayer.stop();
      currentSong = new Song(
          albumUrl: "",
          audioUrl: "",
          songAuthor: "",
          songName: "",
          albumName: "",
          tags: null);
      _playerState = PlayerState.STOPPED;
      checkQueue();
      if (currentSong != null) {
        play(currentSong.audioUrl);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    tempQueue.add(currentSong);
    initAudioPlayer();
    getCurrentUser();
    checkQueue();
  }

  void checkQueue() {

    if (AppData.userQueue.isNotEmpty) {
      Song tempSong = AppData.userQueue.removeFirst();
      if (tempSong != null) {
        if (currentSong.songName == "") {
          setState(() {
            currentSong = tempSong;
          });
        }
      }
    }
  }

  Future<void> getCurrentUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    user = await auth.currentUser();
  }

  Future<void> play(String url) async {
    await audioPlayer.stop();
    await audioPlayer.play(url);
    setState(() {
      _playerState = PlayerState.PLAYING;
      buttonIcon = new Icon(
        Icons.pause,
        color: Colors.red,
        size: 30,
      );
    });
  }

  Future<void> pause() async {
    await audioPlayer.pause();
    setState(() {
      _playerState = PlayerState.PAUSED;
      buttonIcon = new Icon(
        Icons.play_arrow,
        color: Colors.red,
        size: 30,
      );
    });
  }

  Future<void> stop() async {
    await audioPlayer.stop();
    setState(() {
      _playerState = PlayerState.STOPPED;
      position = new Duration();
    });
  }

  Future<void> skipForward() async {
    await audioPlayer.stop();
    setState(() {
      _playerState = PlayerState.STOPPED;
      position = new Duration();
    });
    checkQueue();
    await audioPlayer.play(currentSong.audioUrl);
    setState(() {
      _playerState = PlayerState.PLAYING;
      buttonIcon = new Icon(
        Icons.pause,
        color: Colors.red,
        size: 30,
      );
    });
  }

  Future<void> signOut() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();
  }

  void goToHome() {
    signOut();
    Navigator.of(context).pushNamed('/home');
  }

  void openUserPage() {
    Navigator.of(context).pushNamed('/user');
  }

  void openSearchPage() {
    Navigator.of(context).pushNamed('/search');
  }

  /*@override
  void dispose() {
    _positionSub.cancel();
    _audioPlayerStateSub.cancel();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            "Home",
            style: TextStyle(color: Colors.red),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            color: Colors.red,
            onPressed: goToHome,
          ),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.settings),
              color: Colors.red,
              onPressed: () {},
            ),
          ],
        ),
        body: new Column(
          children: <Widget>[
            //Seek bar and album cover
            new Expanded(
              child: new Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50, bottom: 60),
                  child: new Container(
                    width: 200,
                    height: 200,
                    child: ClipOval(
                      clipper: new CircleClipper(),
                      child: Image.network(
                        currentSong.albumUrl,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            //Controls and music info
            createMusicControlPanel(),
            //Bottom panel
            new BottomPanel(),
          ],
        ));
  }

  RawMaterialButton createPlayButton() {
    return new RawMaterialButton(
      shape: new CircleBorder(),
      fillColor: Colors.white,
      splashColor: Colors.white12,
      highlightColor: Colors.white12.withOpacity(0.5),
      onPressed: () {
        play(currentSong.audioUrl);
        if (_playerState == PlayerState.PLAYING) {
          pause();
        } else if (_playerState == PlayerState.PAUSED) {
          play(currentSong.audioUrl);
        }
      },
      child: Padding(padding: const EdgeInsets.all(8.0), child: buttonIcon),
    );
  }

  Container createMusicControlPanel() {
    return new Container(
      width: double.infinity,
      child: Material(
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 30),
          child: new Column(
            children: <Widget>[
              new RichText(
                text: new TextSpan(
                  text: '',
                  children: [
                    new TextSpan(
                      text: currentSong.songName + "\n",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    new TextSpan(
                      text: currentSong.songAuthor,
                      style: new TextStyle(
                        color: Colors.white.withOpacity(0.80),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: new Row(
                  children: <Widget>[
                    new Expanded(child: new Container()),
                    new PreviousButton(),
                    new Expanded(child: new Container()),
                    createPlayButton(),
                    new Expanded(child: new Container()),
                    createNextButton(),
                    new Expanded(child: new Container()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconButton createNextButton() {
    return new IconButton(
      splashColor: Colors.redAccent,
      highlightColor: Colors.transparent,
      icon: new Icon(
        Icons.skip_next,
        color: Colors.white,
        size: 30,
      ),
      onPressed: () {
        skipForward();
      },
    );
  }
}

class BottomPanel extends StatelessWidget {
  const BottomPanel({
    Key key,
  }) : super(key: key);

  void goToHome(BuildContext context) {
    Navigator.pushNamed(context, '/player');
  }

  void openUserPage(BuildContext context) {
    Navigator.pushNamed(context, '/user');
  }

  void openSearchPage(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/search');
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      height: 50,
      child: Material(
        color: Colors.redAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Expanded(child: new Container()),
            new IconButton(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              onPressed: () => goToHome(context),
              iconSize: 20,
            ),
            new Expanded(child: new Container()),
            new IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => openSearchPage(context),
            ),
            new Expanded(child: new Container()),
            new IconButton(
              icon: Icon(
                Icons.library_music,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {},
            ),
            new Expanded(child: new Container()),
            new IconButton(
              icon: Icon(
                Icons.account_box,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => openUserPage(context),
            ),
            new Expanded(child: new Container()),
          ],
        ),
      ),
    );
  }
}
