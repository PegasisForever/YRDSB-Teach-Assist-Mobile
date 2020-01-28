import 'package:flutter/material.dart';

class CrossFade extends StatelessWidget {
  CrossFade({this.showFirst, this.firstChild, this.secondChild, key}) : super(key: key);

  final bool showFirst;
  final Widget firstChild;
  final Widget secondChild;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      key: Key("tip"),
      firstChild: firstChild,
      secondChild: secondChild ?? Container(),
      crossFadeState: showFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 300),
      firstCurve: Curves.easeInOutCubic,
      secondCurve: Curves.easeInOutCubic,
      sizeCurve: Curves.easeInOutCubic,
    );
  }
}
