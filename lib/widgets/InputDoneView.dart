import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';

class InputDoneView extends StatefulWidget {
  @override
  _InputDoneViewState createState() => _InputDoneViewState();
}

class _InputDoneViewState extends State<InputDoneView> with AfterLayoutMixin<InputDoneView> {
  bool _visible = false;

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      _visible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        width: 40,
        height: 40,
        padding: EdgeInsets.all(4),
        child: AnimatedOpacity(
          opacity: _visible ? 1.0 : 0.0,
          duration: Duration(milliseconds: 200),
          child: Material(
            shape: CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                setState(() {
                  _visible = false;
                });
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Center(
                child: Icon(Icons.keyboard_arrow_down),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
