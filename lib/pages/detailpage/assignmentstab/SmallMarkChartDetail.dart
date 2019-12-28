import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';

class _SmallMarkChartDetailPainter extends CustomPainter {
  final Assignment _assi;
  final Map<Category, Color> colorMap = const {
    Category.KU: const Color(0xffffeb3b),
    Category.T: const Color(0xff8bc34a),
    Category.C: const Color(0xff9fa8da),
    Category.A: const Color(0xffffb74d),
    Category.O: const Color(0xff90a4ae),
    Category.F: const Color(0xff81d4fa),
  };

  _SmallMarkChartDetailPainter(this._assi);

  @override
  void paint(Canvas canvas, Size size) {
    var width = size.width;
    var height = size.height;

    var barCount = 0.0;
    for (final category in Category.values) {
      barCount += max((category == Category.O || category == Category.F) ? 0 : 1,
          _assi[category].smallMarks.length);
    }
    var barWidth = width / barCount;

    var i = 0;
    for (final category in Category.values) {
      if (_assi[category].available) {
        for (final smallMark in _assi[category].smallMarks) {
          _paintBar(canvas, Strings.get(describeEnum(category).toLowerCase()), colorMap[category],
              smallMark, barWidth * (i++), barWidth, height);
        }
      } else if (category != Category.O && category != Category.F) {
        _paintUnavailableBar(canvas, Strings.get(describeEnum(category).toLowerCase()),
            barWidth * (i++), barWidth, height);
      }
    }
  }

  void _paintUnavailableBar(Canvas canvas, String text, double x, double width, double height) {
    TextPainter(
        text: TextSpan(text: text, style: TextStyle(fontSize: 16.0, color: getGrey(100))),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: width, minWidth: width)
      ..paint(canvas, Offset(x, height - 32)) // category text

      ..text = TextSpan(text: "N/A", style: TextStyle(fontSize: 16.0, color: getGrey(100)))
      ..layout(maxWidth: width, minWidth: width)
      ..paint(canvas, Offset(x, height - 54)); // "N/A" text
  }

  void _paintBar(Canvas canvas, String text, Color color, SmallMark smallMark, double x,
      double width, double height) {
    TextPainter(
        text: TextSpan(text: text, style: TextStyle(fontSize: 16.0, color: getGrey(100))),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: width, minWidth: width)
      ..paint(canvas, Offset(x, height - 32)) // category text

      ..text = TextSpan(
          text: Strings.get("w:") + getRoundString(smallMark.weight, 2),
          style: TextStyle(fontSize: 12.0, color: getGrey(100)))
      ..layout(maxWidth: width, minWidth: width)
      ..paint(canvas, Offset(x, height - 12)); //weight text

    if (smallMark.finished) {
      var mark = smallMark.percentage * 100;
      var paint = Paint()
        ..style = PaintingStyle.fill
        ..color = color
        ..isAntiAlias = true;
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            7 + x,
            (height - 66) * (1 - mark / 100) + 33,
            width - 7 + x,
            height - 33,
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
          paint);

      TextPainter(
          text:
              TextSpan(text: num2Str(mark), style: TextStyle(fontSize: 16.0, color: getGrey(100))),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center)
        ..layout(maxWidth: width, minWidth: width)
        ..paint(canvas, Offset(x, (height - 66) * (1 - mark / 100)))
        ..text = TextSpan(
            text: getRoundString(smallMark.get, 2) + "/" + getRoundString(smallMark.total, 2),
            style: TextStyle(fontSize: 12.0, color: getGrey(100)))
        ..layout(maxWidth: width, minWidth: width)
        ..paint(canvas, Offset(x, (height - 66) * (1 - mark / 100) + 16));
    } else {
      TextPainter(
          text: TextSpan(text: "N", style: TextStyle(fontSize: 16.0, color: Colors.red)),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center)
        ..layout(maxWidth: width, minWidth: width)
        ..paint(canvas, Offset(x, height - 54));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class SmallMarkChartDetail extends StatelessWidget {
  final Assignment _assi;
  final double height;

  SmallMarkChartDetail(this._assi, {this.height = 220});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.maxFinite,
      child: CustomPaint(
        painter: _SmallMarkChartDetailPainter(_assi),
      ),
    );
  }
}
