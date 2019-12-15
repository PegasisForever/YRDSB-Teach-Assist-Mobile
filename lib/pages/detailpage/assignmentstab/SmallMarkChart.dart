import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';
import 'package:flutter/foundation.dart' as Foundation;

class _SmallMarkChartPainter extends CustomPainter {
  final Assignment _assi;
  final bool _drawKTCA;
  final Map<Category, Color> colorMap = const {
    Category.KU: const Color(0xffffeb3b),
    Category.T: const Color(0xff8bc34a),
    Category.C: const Color(0xff9fa8da),
    Category.A: const Color(0xffffb74d),
    Category.O: const Color(0xff90a4ae),
    Category.F: const Color(0xff81d4fa),
  };

  _SmallMarkChartPainter(this._assi, this._drawKTCA);

  @override
  void paint(Canvas canvas, Size size) {
    var height = size.height;
    var x = 0.0;

    if (_drawKTCA) {
      for (final category in [Category.KU, Category.T, Category.C, Category.A]) {
        if (_assi[category].available) {
          for (final smallMark in _assi[category].smallMarks) {
            _paintBar(
                canvas,
                Strings.get(Foundation.describeEnum(category).toLowerCase() + "_single"),
                colorMap[category],
                smallMark,
                x,
                40,
                height);
            x += 40;
          }
        } else {
          _paintUnavailableBar(canvas,
              Strings.get(Foundation.describeEnum(category).toLowerCase() + "_single"),
              x, 40, height);
          x += 40;
        }
      }
    } else if (_assi[Category.F].available) {
      x += 15;
      for (final smallMark in _assi[Category.F].smallMarks) {
        _paintBar(
            canvas,
            Strings.get("f_single"),
            colorMap[Category.F],
            smallMark,
            x,
            40,
            height);
        x += 40;
      }
      x += 15;
    } else {
      x += 15;
      for (final smallMark in _assi[Category.O].smallMarks) {
        _paintBar(
            canvas,
            Strings.get("o_single"),
            colorMap[Category.O],
            smallMark,
            x,
            40,
            height);
        x += 40;
      }
      x += 15;
    }
  }

  void _paintUnavailableBar(Canvas canvas, String text, double x,
      double width, double height) {
    TextPainter(
        text: TextSpan(text: text, style: TextStyle(fontSize: 16.0, color: getGrey(100))),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: width, minWidth: width)
      ..paint(canvas, Offset(x, height - 16)) // category text

      ..text = TextSpan(text: "N/A", style: TextStyle(fontSize: 16.0, color: getGrey(100)))
      ..layout(maxWidth: width, minWidth: width)
      ..paint(canvas, Offset(x, height - 40)); // "N/A" text
  }

  void _paintBar(Canvas canvas, String text, Color color, SmallMark smallMark, double x,
      double width, double height) {
    TextPainter(
        text: TextSpan(text: text, style: TextStyle(fontSize: 16.0, color: getGrey(100))),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: width, minWidth: width)
      ..paint(canvas, Offset(x, height - 16)); // category text

    if (smallMark.finished) {
      var mark = smallMark.percentage * 100;
      var paint = Paint()
        ..style = PaintingStyle.fill
        ..color = color
        ..isAntiAlias = true;
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(
              width * 1 / 6 + x,
              (height - 40) * (1 - mark / 100) + 20,
              width * 1 / 6 + x + width * 2 / 3,
              (height - 40) * (1 - mark / 100) + 20 + (height - 40) * (mark / 100),
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5)),
          paint);

      TextPainter(
          text: TextSpan(
              text: getRoundString(mark, 1),
              style: TextStyle(fontSize: 16.0, color: getGrey(100))),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center)
        ..layout(maxWidth: width, minWidth: width)
        ..paint(canvas, Offset(x, (height - 40) * (1 - mark / 100) - 2));
    } else {
      TextPainter(
          text: TextSpan(text: "N", style: TextStyle(fontSize: 16.0, color: Colors.red)),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center)
        ..layout(maxWidth: width, minWidth: width)
        ..paint(canvas, Offset(x, height - 40));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class SmallMarkChart extends StatelessWidget {
  final Assignment _assi;

  SmallMarkChart(this._assi);

  @override
  Widget build(BuildContext context) {
    var isKTCAAvailable =
        _assi[Category.KU].available ||
            _assi[Category.T].available ||
            _assi[Category.C].available ||
            _assi[Category.A].available;
    var drawKTCA = isKTCAAvailable ||
        (!_assi[Category.O].available && !_assi[Category.F].available);

    var width = 0.0;
    if (drawKTCA) {
      for (final category in [Category.KU, Category.T, Category.C, Category.A]) {
        width += max(1, _assi[category].smallMarks.length) * 40;
      }
    } else if (_assi[Category.F].available) {
      width += 40 * _assi[Category.F].smallMarks.length + 30;
    } else {
      width += 40 * _assi[Category.O].smallMarks.length + 30;
    }

    return Container(
      height: 100,
      width: width,
      child: CustomPaint(
        painter: _SmallMarkChartPainter(_assi, drawKTCA),
      ),
    );
  }
}
