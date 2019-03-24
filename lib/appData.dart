library app_data;
import 'dart:collection';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_streaming_app/song.dart';

FirebaseUser user;
int followers = 0;
int following = 0;

Queue<Song> userQueue = new Queue();

StreamController queueUpdated = new StreamController.broadcast();
Stream get fetchEvent => queueUpdated.stream;
