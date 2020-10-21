import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:boggle/Position.dart';

class TilePainter extends CustomPainter {

  String letter;
  Position position;
  Color color;
  bool selected;

  TilePainter(String letter, Position position) {
    this.letter = letter;
    this.position = position;
    color = Color(0xfff6adc6); // got this color from https://encycolorpedia.com/f7b3c2#:~:text=The%20hexadecimal%20color%20code%20%23f7b3c2,approximate%20wavelength%20of%20495.6%20nm.
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
    color = Color(0xfff6adc6);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint() ..color = this.color;
    final ts = ui.TextStyle(
      color: Colors.black,
      fontSize: 30,
    );
    final pBuild = ui.ParagraphBuilder(ui.ParagraphStyle(textAlign: TextAlign.center, textDirection: TextDirection.ltr)) .. pushStyle(ts) ..addText(letter);
    final p = pBuild.build();
    final constraints = ui.ParagraphConstraints(width: size.width);
    p.layout(constraints);

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    canvas.drawParagraph(p, Offset(0, (size.height - 30) / 2 ));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) =>  true;
  
}