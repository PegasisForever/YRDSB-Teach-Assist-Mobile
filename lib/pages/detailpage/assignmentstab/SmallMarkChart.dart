import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';

class _SmallMarkChartPainter extends CustomPainter {
  final Assignment _assi;
  final bool _KTCAAvailable;
  final Color _Kcolor = Color(0xffffeb3b);
  final Color _Tcolor = Color(0xff8bc34a);
  final Color _Ccolor = Color(0xff9fa8da);
  final Color _Acolor = Color(0xffffb74d);
  final Color _Ocolor = Color(0xff90a4ae);

  _SmallMarkChartPainter(this._assi,this._KTCAAvailable);

  @override
  void paint(Canvas canvas, Size size) {
    var height = size.height;

    if (_KTCAAvailable){
      _paintBar(
          canvas, Strings.get("ku_single"), _Kcolor, _assi.KU, 0, 40, height);
      _paintBar(
          canvas, Strings.get("t_single"), _Tcolor, _assi.T, 40, 40, height);
      _paintBar(
          canvas, Strings.get("c_single"), _Ccolor, _assi.C, 80, 40, height);
      _paintBar(
          canvas, Strings.get("a_single"), _Acolor, _assi.A, 120, 40, height);
    }else{
      _paintBar(
          canvas, Strings.get("o_single"), _Ocolor, _assi.O, 15, 40, height);
    }

  }

  void _paintBar(Canvas canvas, String text, Color color, SmallMark smallMark,
      double x, double width, double height) {
    TextPainter(
        text: TextSpan(
            text: text, style: TextStyle(fontSize: 16.0, color: Colors.grey)),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: width, minWidth: width)
      ..paint(canvas, Offset(x, height - 16));

    if (smallMark.available) {
      var mark = smallMark.get / smallMark.total * 100;
      var paint = Paint()
        ..style = PaintingStyle.fill
        ..color = color
        ..isAntiAlias = true;
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(
              width * 1 / 6 + x,
              (height - 40) * (1 - mark / 100) + 20,
              width * 1 / 6 + x + width * 2 / 3,
              (height - 40) * (1 - mark / 100) +
                  20 +
                  (height - 40) * (mark / 100),
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5)),
          paint);

      if (smallMark.finished) {
        TextPainter(
            text: TextSpan(
                text: getRoundString(mark, 1),
                style: TextStyle(fontSize: 16.0, color: Colors.grey)),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center)
          ..layout(maxWidth: width, minWidth: width)
          ..paint(canvas, Offset(x, (height - 32) * (1 - mark / 100) - 2));
      } else {
        TextPainter(
            text: TextSpan(
                text: "N", style: TextStyle(fontSize: 16.0, color: Colors.red)),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center)
          ..layout(maxWidth: width, minWidth: width)
          ..paint(canvas, Offset(x, (height - 32) - 2));
      }
    } else {
      TextPainter(
          text: TextSpan(
              text: "N/A",
              style: TextStyle(fontSize: 16.0, color: Colors.grey)),
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
    var KTCAAvailable = _assi.KU.available ||
        _assi.T.available ||
        _assi.C.available ||
        _assi.A.available;
    return Container(
      height: 100,
      width: KTCAAvailable?160:70,
      child: CustomPaint(
        painter: _SmallMarkChartPainter(_assi,KTCAAvailable),
      ),
    );
  }
}
