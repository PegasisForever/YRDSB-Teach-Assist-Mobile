import 'package:flutter/material.dart';

class SmallIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;

  SmallIconButton({this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: Material(
        type: MaterialType.transparency,
        clipBehavior: Clip.antiAlias,
        shape: CircleBorder(),
        elevation: 0,
        child: InkWell(
          child: Center(child: icon),
          onTap: onPressed,
        ),
      ),
    );
  }
}
