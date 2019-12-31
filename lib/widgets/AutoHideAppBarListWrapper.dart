import 'package:flutter/material.dart';
import 'package:ta/tools.dart';

class AutoHideAppBarListWrapper extends StatefulWidget {
  final Widget child;
  final double maxOffsetY;
  final TwoValueChanged<double, double> onAppBarSnapChanged;

  AutoHideAppBarListWrapper({
    this.child,
    this.onAppBarSnapChanged,
    this.maxOffsetY = -56,
    Key key,
  }) : super(key: key);

  @override
  AutoHideAppBarListWrapperState createState() => AutoHideAppBarListWrapperState();
}

class AutoHideAppBarListWrapperState extends State<AutoHideAppBarListWrapper>
    with TickerProviderStateMixin {
  double appBarOffsetY = 0;
  double appBarElevation = 0;
  double scrollPosition = 0;
  Direction scrollDirection;
  Animation<double> _animation;
  Tween<double> _tween;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _tween = Tween(begin: 0, end: widget.maxOffsetY);
    var curve = CurvedAnimation(parent: _animationController, curve: Curves.easeInOutCubic);
    _animation = _tween.animate(curve)
      ..addListener(() {
        appBarOffsetY = _animation.value;

        if (scrollPosition > (-appBarOffsetY)) {
          appBarElevation = 4;
        } else {
          appBarElevation = 0;
        }
        widget.onAppBarSnapChanged(appBarOffsetY, appBarElevation);
      });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      child: widget.child,
      onNotification: (noti) {
        scrollPosition = noti.metrics.pixels;
        if (noti is ScrollUpdateNotification) {
          if (!noti.metrics.outOfRange) {
            _animationController.stop();
            scrollDirection = noti.scrollDelta > 0 ? Direction.UP : Direction.DOWN;
            appBarOffsetY -= noti.scrollDelta;
            if (appBarOffsetY < widget.maxOffsetY) {
              appBarOffsetY = widget.maxOffsetY;
            } else if (appBarOffsetY > 0) {
              appBarOffsetY = 0;
            }
            if (-appBarOffsetY > scrollPosition) {
              appBarOffsetY = -scrollPosition;
            }
          }

          if (scrollPosition > (-appBarOffsetY)) {
            appBarElevation = 4;
          } else {
            appBarElevation = 0;
          }
        } else if (noti is ScrollEndNotification) {
          if (scrollDirection == Direction.UP) {
            if (scrollPosition > -widget.maxOffsetY) {
              _tween.begin = appBarOffsetY;
              _tween.end = widget.maxOffsetY;
              _animationController.reset();
              _animationController.forward();
            }
          } else {
            _tween.begin = appBarOffsetY;
            _tween.end = 0;
            _animationController.reset();
            _animationController.forward();
          }
        }

        return false;
      },
    );
  }
}
