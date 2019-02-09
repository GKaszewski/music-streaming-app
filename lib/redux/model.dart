import 'package:music_streaming_app/song.dart';

class SongItem{
  Song song;
  bool isPlaying;

  SongItem(this.song, this.isPlaying);
}

class AddItemAction{
  final SongItem item;

  AddItemAction(this.item);
}