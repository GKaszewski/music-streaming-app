

import 'dart:math';

import 'package:flutter/material.dart';

class RadialSeekbar extends StatefulWidget{
  final double trackWidth;
  final Color trackColor;

  final double progressWidth;
  final double progressPercent;
  final Color progressColor;

  final double thumbSize;
  final double thumbPosition;
  final Color thumbColor;

  final Widget child;

  RadialSeekbar({
    this.trackWidth = 3,
    this.trackColor = Colors.grey,
    this.progressWidth = 4.5,
    this.progressPercent = 0.0,
    this.progressColor = Colors.red,
    this.thumbSize = 5,
    this.thumbPosition = 0.0,
    this.thumbColor = Colors.white,
    this.child,
  });

  @override
  _RadialSeekbarState createState() => new _RadialSeekbarState();
}

class _RadialSeekbarState extends State<RadialSeekbar>{
  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      foregroundPainter: new RadialSeekbarPainter(
          trackWidth: widget.trackWidth,
          trackColor: widget.trackColor,
          progressWidth: widget.progressWidth,
          progressPercent: widget.progressPercent,
          progressColor: widget.progressColor,
          thumbSize: widget.thumbSize,
          thumbPosition: widget.thumbPosition,
          thumbColor: widget.thumbColor
      ),
      child: widget.child,
    );
  }
}

class RadialSeekbarPainter extends CustomPainter{
  final double trackWidth;
  final Paint trackPaint;

  final double progressWidth;
  final double progressPercent;
  final Paint progressPaint;

  final double thumbSize;
  final double thumbPosition;
  final Paint thumbPaint;

  RadialSeekbarPainter({
    @required this.trackWidth,
    @required trackColor,
    @required this.progressWidth,
    @required this.progressPercent,
    @required progressColor,
    @required this.thumbSize,
    @required this.thumbPosition,
    @required thumbColor,
  }) :trackPaint = new Paint()
    ..color = trackColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = trackWidth,
        progressPaint = new Paint()
          ..color = progressColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = progressWidth
          ..strokeCap = StrokeCap.butt,
        thumbPaint = new Paint()
          ..color = thumbColor
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {

    final center = new Offset(size.width / 2, size.height / 2);
    final radius = (min(size.width, size.height) / 2) * 1.10;

    canvas.drawCircle(
      center,
      radius,
      trackPaint,
    );

    final progressAngle = 2 * pi * progressPercent;

    canvas.drawArc(
      new Rect.fromCircle(
        center: center,
        radius: radius,
      ),
      -pi / 2,
      progressAngle,
      false,
      progressPaint,
    );

    final thumbAngle = 2 * pi * thumbPosition - (pi / 2);
    final thumbX = cos(thumbAngle) * radius;
    final thumbY = sin(thumbAngle) * radius;
    final thumbCenter = new Offset(thumbX, thumbY) + center;
    final thumbRadius = thumbSize / 2;
    canvas.drawCircle(
      thumbCenter,
      thumbRadius,
      thumbPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
