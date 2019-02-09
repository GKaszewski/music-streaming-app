import 'package:meta/meta.dart';
import 'package:html/parser.dart';
import 'dart:convert';
import 'dart:collection';

class Song{
  final String audioUrl;
  final String albumName;
  final String albumUrl;
  final String songName;
  final String songAuthor;
  final List<String> tags;

  Song({
    @required this.audioUrl,
    @required this.albumUrl,
    @required this.songName,
    @required this.songAuthor,
    this.albumName,
    this.tags
});

factory Song.fromJson(dynamic json){
  return Song(
    audioUrl: json['songUrl'],
    albumUrl: json['albumUrl'],
    songName: json['title'],
    songAuthor: json['author'],
    albumName: json['albumName'],
  );
}
}