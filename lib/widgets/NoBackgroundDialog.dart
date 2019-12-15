import 'package:flutter/material.dart';

class NoBackgroundDialog extends StatelessWidget {
  final Duration insetAnimationDuration;
  final Curve insetAnimationCurve;
  final Widget child;
  final double maxWidth;

  const NoBackgroundDialog(
      {Key key,
      this.insetAnimationDuration = const Duration(milliseconds: 100),
      this.insetAnimationCurve = Curves.decelerate,
      this.child,
      this.maxWidth = double.infinity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DialogTheme dialogTheme = DialogTheme.of(context);
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets +
          const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
      duration: insetAnimationDuration,
      curve: insetAnimationCurve,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 280.0, maxWidth: maxWidth),
            child: child,
          ),
        ),
      ),
    );
  }
}
