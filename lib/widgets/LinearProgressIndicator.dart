import 'package:flutter/material.dart';

class LinearProgressIndicator extends StatefulWidget {
  final Color backgroundColor;
  final Color value1Color;
  final Color value2Color;
  final double value1;
  final double value2;
  final String text;
  final int animationDuration;
  final double lineHeight;
  final Widget center;

  LinearProgressIndicator(
      {this.backgroundColor = const Color(0xFFB8C7CB),
      this.value1Color,
      this.value2Color,
      this.value1,
      this.value2,
      this.text,
      this.animationDuration = 0,
      this.lineHeight,
        this.center,
        key}) :super(key: key);

  @override
  _LinearProgressIndicatorState createState() => _LinearProgressIndicatorState();
}

class _LinearProgressIndicatorState extends State<LinearProgressIndicator>
    with SingleTickerProviderStateMixin,AutomaticKeepAliveClientMixin {
  Animation<double> animation;
  AnimationController controller;
  double percent1 = 0;
  double percent2 = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: widget.animationDuration), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOutCubic)
      ..addListener(() {
        setState(() {
          percent1 = widget.value1 * animation.value;
          if (widget.value2 != null) {
            percent2 = widget.value2 * animation.value;
          }
        });
      });
    controller.forward();
  }

  @override
  void didUpdateWidget(LinearProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value1 != widget.value1 || oldWidget.value2 != widget.value2 ||
        oldWidget.value1Color != widget.value1Color ||
        oldWidget.value2Color != widget.value2Color) {
      animation = CurvedAnimation(parent: controller, curve: Curves.easeInOutCubic);
      controller.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      width: double.infinity,
      height: widget.lineHeight,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: CustomPaint(
        painter: _LPIPainter(
            backgroundColor: widget.backgroundColor,
            value1Color: widget.value1Color,
            value2Color: widget.value2Color,
            value1: percent1,
            value2: percent2,
            text: widget.text,
            lineHeight: widget.lineHeight),
        child: widget.center != null
            ? Center(
                child: widget.center,
              )
            : Container(),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class _LPIPainter extends CustomPainter {
  Paint _paintBackground;
  Paint _paintValue1;
  Paint _paintValue2;
  final Color backgroundColor;
  final Color value1Color;
  final Color value2Color;
  final double value1;
  final double value2;
  final String text;
  final double lineHeight;

  _LPIPainter(
      {this.backgroundColor,
      this.value1Color,
      this.value2Color,
      this.value1,
      this.value2,
      this.text,
      this.lineHeight}) {
    _paintBackground = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineHeight
      ..strokeCap = StrokeCap.round;

    if (value1 > 0) {
      _paintValue1 = Paint()
        ..color = value1Color
        ..style = PaintingStyle.stroke
        ..strokeWidth = lineHeight
        ..strokeCap = StrokeCap.round;
    }

    if (value2 > 0) {
      _paintValue2 = Paint()
        ..color = value2Color
        ..style = PaintingStyle.stroke
        ..strokeWidth = lineHeight
        ..strokeCap = StrokeCap.round;
    }


  }

  @override
  void paint(Canvas canvas, Size size) {
    final start = Offset(0.0, size.height / 2);
    final end = Offset(size.width, size.height / 2);
    canvas.drawLine(start, end, _paintBackground);
    if (_paintValue2 != null)
      canvas.drawLine(start, Offset(size.width * value2, size.height / 2), _paintValue2);
    if (_paintValue1 != null)
      canvas.drawLine(start, Offset(size.width * value1, size.height / 2), _paintValue1);
  }

  @override
  bool shouldRepaint(_LPIPainter oldDelegate) {
    return oldDelegate.value1 != value1 || oldDelegate.value2 != value2;
  }
}
