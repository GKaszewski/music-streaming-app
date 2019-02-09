import 'dart:math';

import 'package:flutter/material.dart';
import 'song.dart';
class Controls extends StatelessWidget {

  const Controls({
    Key key,
    @required this.demoSong,
  }) : super(key: key);

  final Song demoSong;

  @override
  Widget build(BuildContext context) {
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
                      text: demoSong.songName + "\n",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    new TextSpan(
                      text: demoSong.songAuthor,
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

                    new Expanded(child: new Container()),


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
}

class PreviousButton extends StatelessWidget {
  const PreviousButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new IconButton(
        splashColor: Colors.redAccent,
        highlightColor: Colors.transparent,
        icon: new Icon(
          Icons.skip_previous,
          color: Colors.white,
          size: 30,
        ),
        onPressed: () {}
    );
  }
}

class CircleClipper extends CustomClipper<Rect>{

  @override
  Rect getClip(Size size) {
    return new Rect.fromCircle(
      center: new Offset(size.width / 2, size.height / 2),
      radius: min(size.width, size.height) / 2,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}