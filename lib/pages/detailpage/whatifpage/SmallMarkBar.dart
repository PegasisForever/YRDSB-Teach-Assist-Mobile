import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';

class SmallMarkBar extends StatelessWidget {
  final SmallMark _smallMark;
  final Category _category;

  SmallMarkBar(this._smallMark, this._category);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: CustomPaint(
        painter: _SmallMarkBarPainter(_smallMark, _category),
      ),
    );
  }
}

class _SmallMarkBarPainter extends CustomPainter {
  final SmallMark _smallMark;
  final Category _category;
  final Map<Category, Color> colorMap = const {
    Category.KU: const Color(0xffffeb3b),
    Category.T: const Color(0xff8bc34a),
    Category.C: const Color(0xff9fa8da),
    Category.A: const Color(0xffffb74d),
    Category.O: const Color(0xff90a4ae),
    Category.F: const Color(0xff81d4fa),
  };

  _SmallMarkBarPainter(this._smallMark, this._category);

  @override
  void paint(Canvas canvas, Size size) {
    var height = size.height + 8;
    var width = size.width;
    var categoryText = Strings.get(describeEnum(_category).toLowerCase());
    var labelPainter = TextPainter(
        text: TextSpan(text: categoryText, style: TextStyle(fontSize: 16.0, color: getGrey(100))),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: width, minWidth: width)
      ..paint(canvas, Offset(0, height - 32)); // category text

    if (_smallMark == null) {
      // unavailable
      labelPainter
        ..text = TextSpan(text: "N/A", style: TextStyle(fontSize: 16.0, color: getGrey(100)))
        ..layout(maxWidth: width, minWidth: width)
        ..paint(canvas, Offset(0, height - 54)); // "N/A" text
    } else {
      if (_smallMark.finished) {
        var mark = _smallMark.percentage * 100;
        var paint = Paint()
          ..style = PaintingStyle.fill
          ..color = colorMap[_category]
          ..isAntiAlias = true;
        canvas.drawRRect(
            RRect.fromLTRBAndCorners(
              7,
              (height - 66) * (1 - mark / 100) + 33,
              width - 7,
              height - 33,
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
            paint);

        TextPainter(
            text: TextSpan(
                text: num2Str(mark), style: TextStyle(fontSize: 16.0, color: getGrey(100))),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center)
          ..layout(maxWidth: width, minWidth: width)
          ..paint(canvas, Offset(0, (height - 66) * (1 - mark / 100)))
          ..text = TextSpan(
              text: getRoundString(_smallMark.get, 2) + "/" + getRoundString(_smallMark.total, 2),
              style: TextStyle(fontSize: 12.0, color: getGrey(100)))
          ..layout(maxWidth: width, minWidth: width)
          ..paint(canvas, Offset(0, (height - 66) * (1 - mark / 100) + 16));
      } else {
        TextPainter(
            text: TextSpan(text: "N", style: TextStyle(fontSize: 16.0, color: Colors.red)),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center)
          ..layout(maxWidth: width, minWidth: width)
          ..paint(canvas, Offset(0, height - 54));
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
