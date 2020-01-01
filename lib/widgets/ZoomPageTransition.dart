import 'package:flutter/material.dart';

class ZoomPageTransition extends StatefulWidget {
  const ZoomPageTransition({
    Key key,
    this.animation,
    this.secondaryAnimation,
    this.child,
    this.showEnterAnimation,
  }) : super(key: key);

  // A curve sequence that is similar to the 'fastOutExtraSlowIn' curve used in
  // the native transition.
  static final List<TweenSequenceItem<double>> fastOutExtraSlowInTweenSequenceItems =
      <TweenSequenceItem<double>>[
    TweenSequenceItem<double>(
      tween: Tween<double>(begin: 0.0, end: 0.4)
          .chain(CurveTween(curve: const Cubic(0.05, 0.0, 0.133333, 0.06))),
      weight: 0.166666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(begin: 0.4, end: 1.0)
          .chain(CurveTween(curve: const Cubic(0.208333, 0.82, 0.25, 1.0))),
      weight: 1.0 - 0.166666,
    ),
  ];
  static final TweenSequence<double> _scaleCurveSequence =
      TweenSequence<double>(fastOutExtraSlowInTweenSequenceItems);
  static final FlippedTweenSequence _flippedScaleCurveSequence =
      FlippedTweenSequence(fastOutExtraSlowInTweenSequenceItems);

  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final bool showEnterAnimation;
  final Widget child;

  @override
  _ZoomPageTransitionState createState() => _ZoomPageTransitionState();
}

class _ZoomPageTransitionState extends State<ZoomPageTransition> {
  AnimationStatus _currentAnimationStatus;
  AnimationStatus _lastAnimationStatus;

  @override
  void initState() {
    super.initState();
    widget.animation.addStatusListener((AnimationStatus animationStatus) {
      _lastAnimationStatus = _currentAnimationStatus;
      _currentAnimationStatus = animationStatus;
    });
  }

  // This check ensures that the animation reverses the original animation if
  // the transition were interruped midway. This prevents a disjointed
  // experience since the reverse animation uses different fade and scaling
  // curves.
  bool get _transitionWasInterrupted {
    bool wasInProgress = false;
    bool isInProgress = false;

    switch (_currentAnimationStatus) {
      case AnimationStatus.completed:
      case AnimationStatus.dismissed:
        isInProgress = false;
        break;
      case AnimationStatus.forward:
      case AnimationStatus.reverse:
        isInProgress = true;
        break;
    }
    switch (_lastAnimationStatus) {
      case AnimationStatus.completed:
      case AnimationStatus.dismissed:
        wasInProgress = false;
        break;
      case AnimationStatus.forward:
      case AnimationStatus.reverse:
        wasInProgress = true;
        break;
    }
    return wasInProgress && isInProgress;
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> _forwardStartScreenScaleTransition = widget.secondaryAnimation
        .drive(Tween<double>(begin: 1.00, end: 1.05).chain(ZoomPageTransition._scaleCurveSequence));

    final Animation<double> _reverseEndScreenScaleTransition = widget.secondaryAnimation.drive(
        Tween<double>(begin: 1.00, end: 1.10).chain(ZoomPageTransition._flippedScaleCurveSequence));

    var animatedBuilder = AnimatedBuilder(
      animation: widget.secondaryAnimation,
      builder: (BuildContext context, Widget child) {
        if (widget.secondaryAnimation.status == AnimationStatus.forward ||
            _transitionWasInterrupted) {
          return ScaleTransition(
            scale: _forwardStartScreenScaleTransition,
            child: child,
          );
        } else if (widget.secondaryAnimation.status == AnimationStatus.reverse) {
          return ScaleTransition(
            scale: _reverseEndScreenScaleTransition,
            child: child,
          );
        }
        return child;
      },
      child: widget.child,
    );

    if (widget.showEnterAnimation) {
      final Animation<double> _forwardEndScreenScaleTransition = widget.animation.drive(
          Tween<double>(begin: 0.85, end: 1.00).chain(ZoomPageTransition._scaleCurveSequence));
      final Animation<double> _forwardEndScreenFadeTransition = widget.animation.drive(
          Tween<double>(begin: 0.0, end: 1.00)
              .chain(CurveTween(curve: const Interval(0.125, 0.250))));
      final Animation<double> _reverseStartScreenScaleTransition = widget.animation.drive(
          Tween<double>(begin: 0.9, end: 1.0).chain(ZoomPageTransition._flippedScaleCurveSequence));

      final Animation<double> _reverseStartScreenFadeTransition = widget.animation.drive(
          Tween<double>(begin: 0.00, end: 1.00)
              .chain(CurveTween(curve: const Interval(1 - 0.2075, 1 - 0.0825))));

      animatedBuilder = AnimatedBuilder(
        animation: widget.animation,
        builder: (BuildContext context, Widget child) {
          if (widget.animation.status == AnimationStatus.forward || _transitionWasInterrupted) {
            return FadeTransition(
              opacity: _forwardEndScreenFadeTransition,
              child: ScaleTransition(
                scale: _forwardEndScreenScaleTransition,
                child: child,
              ),
            );
          } else if (widget.animation.status == AnimationStatus.reverse) {
            return ScaleTransition(
              scale: _reverseStartScreenScaleTransition,
              child: FadeTransition(
                opacity: _reverseStartScreenFadeTransition,
                child: child,
              ),
            );
          }
          return child;
        },
        child: animatedBuilder,
      );
    }

    return animatedBuilder;
  }
}
