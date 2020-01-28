import 'package:flutter/material.dart';
import 'package:ta/widgets/CrossFade.dart';

class ExpansionTile extends StatefulWidget {
  final bool shouldShowTile;
  final Widget title;
  final List<Widget> children;

  ExpansionTile({this.title, this.children,this.shouldShowTile});

  @override
  _ExpansionTileState createState() => _ExpansionTileState();
}

class _ExpansionTileState extends State<ExpansionTile> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  Animation<double> _iconTurns;
  Animation<double> _heightFactor;
  AnimationController _controller;
  Animatable<double> _halfTween = Tween<double>(begin: 0.0, end: 0.5);
  Animatable<double> _easeInOutTween = CurveTween(curve: Curves.easeInOutCubic);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInOutTween));
    _heightFactor = _controller.drive(_easeInOutTween);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller.view,
      child: Column(children: widget.children),
      builder: (context, child) {
        return Column(
          children: <Widget>[
            CrossFade(
              showFirst: widget.shouldShowTile,
              firstChild: ListTile(
                onTap: _handleTap,
                title: widget.title,
                trailing: RotationTransition(
                  turns: _iconTurns,
                  child: const Icon(Icons.expand_more),
                ),
              ),
            ),

            ClipRect(
              child: Align(
                heightFactor: _heightFactor.value,
                child: child,
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }
}
