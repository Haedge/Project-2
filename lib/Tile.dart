import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:boggle/Position.dart';

class TilePainter extends CustomPainter {

  String letter;
  Position position;
  Color color;
  bool selected;

  TilePainter(Characters letter, Position position) {
    this.letter = letter.toString();
    this.position = position;
    color = Colors.white;
    selected = false;
  }

  String getLetter(){return letter;}

  Position getPosition(){return position;}

  bool isSelected(){return selected;}

  void select() {
    selected = true;
    color = Colors.orangeAccent;
  }

  void changeColor(Color c) {color = c;}

  void reset() {
    selected = false;
    color = Colors.white;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint() ..color = this.color;

    final ParagraphBuilder pBuild = ParagraphBuilder(ParagraphStyle(textAlign: TextAlign.center)) ..addText(letter);
    final Paragraph p = pBuild.build();

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    canvas.drawParagraph(p, Offset(0, 0));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) =>  true;
  
}