import 'package:flutter/material.dart';
import 'package:ta/tools.dart';

class AutoHideAppBarListWrapper extends StatefulWidget {
  final Widget child;
  final TwoValueChanged<double, double> onAppBarSnapChanged;

  AutoHideAppBarListWrapper({this.child, this.onAppBarSnapChanged, Key key}) : super(key: key);

  @override
  AutoHideAppBarListWrapperState createState() => AutoHideAppBarListWrapperState();
}

class AutoHideAppBarListWrapperState extends State<AutoHideAppBarListWrapper>
    with TickerProviderStateMixin {
  double appBarOffsetY = 0;
  double elevation = 0;
  double scrollPosition = 0;
  Direction scrollDirection;
  Animation<double> _animation;
  Tween<double> _tween;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _tween = Tween(begin: 0, end: -56);
    var curve = CurvedAnimation(parent: _animationController, curve: Curves.easeInOutCubic);
    _animation = _tween.animate(curve)
      ..addListener(() {
        appBarOffsetY = _animation.value;

        if (scrollPosition > (-appBarOffsetY)) {
          elevation = 4;
        } else {
          elevation = 0;
        }
        widget.onAppBarSnapChanged(appBarOffsetY, elevation);
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
            if (appBarOffsetY < -56) {
              appBarOffsetY = -56;
            } else if (appBarOffsetY > 0) {
              appBarOffsetY = 0;
            }
            if (-appBarOffsetY > scrollPosition) {
              appBarOffsetY = -scrollPosition;
            }
          }

          if (scrollPosition > (-appBarOffsetY)) {
            elevation = 4;
          } else {
            elevation = 0;
          }
        } else if (noti is ScrollEndNotification) {
          if (scrollDirection == Direction.UP) {
            if (scrollPosition > 56) {
              _tween.begin = appBarOffsetY;
              _tween.end = -56;
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
