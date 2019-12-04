import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ta/tools.dart';

class StickSlider extends StatefulWidget {
  final double speed;
  final ValueChanged<double> onDelta;
  final bool enabled;

  StickSlider({this.speed = 1, this.onDelta, this.enabled = true});

  @override
  _StickSliderState createState() => _StickSliderState();
}

class _StickSliderState extends State<StickSlider> {
  double _stickValue;
  Timer _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _stickValue != null ? _stickValue : 0,
      min: -1,
      max: 1,
      onChanged: widget.enabled
          ? (v) {
        setState(() {
          _stickValue = v;
        });

        Timer.periodic(Duration(milliseconds: 16), (timer) {
          if (_timer != null && _timer != timer) _timer.cancel();
          _timer = timer;
          if (_stickValue != null) {
            widget.onDelta(powWithSign(_stickValue * widget.speed, 2));
          }
        });
      }
          : null,
      onChangeEnd: (v) {
        setState(() {
          _stickValue = null;
        });

        if (_timer != null) _timer.cancel();
      },
    );
  }
}

class StickSliderTile extends StatefulWidget {
  final String label;
  final double labelWidth;
  final double max;
  final double min;
  final double value;
  final ValueChanged<double> onChanged;
  final bool enabled;
  final FocusNode focusNode;

  StickSliderTile({this.labelWidth,
    this.label,
    this.enabled = true,
    this.max = 1000,
    this.min = 0,
    this.value,
    this.onChanged,
    this.focusNode});

  @override
  _StickSliderTileState createState() => _StickSliderTileState();
}

class _StickSliderTileState extends State<StickSliderTile> {
  var _numberTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _numberTextController.text = getRoundString(widget.value, 2);
  }

  @override
  Widget build(BuildContext context) {
    var _value = widget.value;

    return Row(
      children: <Widget>[
        SizedBox(
          width: 16,
        ),
        SizedBox(
          width: widget.labelWidth,
          child: Text(
            widget.label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Flexible(
          flex: 0,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 35),
            child: TextField(
              keyboardAppearance: isLightMode(context: context)?Brightness.light:Brightness.dark,
              enabled: widget.enabled,
              focusNode: widget.focusNode,
              controller: _numberTextController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.numberWithOptions(signed: widget.min < 0, decimal: true),
              onChanged: (str) {
                var value = double.tryParse(str);
                if (value != null && value <= widget.max && value >= widget.min) {
                  widget.onChanged(value);
                }
              },
              onSubmitted: (str) {
                var value = double.tryParse(str);
                if (value != null && value <= widget.max && value >= widget.min) {
                  widget.onChanged(value);
                } else if (value != null && (value >= widget.max || value <= widget.min)) {
                  setState(() {
                    _numberTextController.text = getRoundString(_value, 1);
                  });
                }
                FocusScope.of(context).unfocus();
              },
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            width: 100,
            child: StickSlider(
              enabled: widget.enabled,
              speed: cap((widget.max - widget.min) / 120, 0.3, 1),
              onDelta: (d) {
                _value += d;
                if (_value < widget.min) {
                  _value = widget.min;
                } else if (_value > widget.max) {
                  _value = widget.max;
                }

                var rounded = _value.round();
                var str = rounded.toString();
                if (str != _numberTextController.text) {
                  widget.onChanged(rounded.toDouble());
                  _numberTextController.text = str;
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
