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
  static ThemeData _themeData;
  static ThemeData _darkThemeData;
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
    if (_themeData == null) {
      _darkThemeData = Theme.of(context).copyWith(
          sliderTheme: SliderThemeData(
              disabledActiveTrackColor: Colors.grey[500],
              disabledInactiveTrackColor: Colors.grey[500],
              disabledThumbColor: Colors.grey[600],
              activeTrackColor: Theme
                  .of(context)
                  .colorScheme
                  .secondary,
              inactiveTrackColor: Theme
                  .of(context)
                  .colorScheme
                  .secondary,
              thumbColor: Theme
                  .of(context)
                  .colorScheme
                  .primary));
      _themeData = Theme.of(context).copyWith(
          sliderTheme: SliderThemeData(
              disabledActiveTrackColor: Colors.grey[400],
              disabledInactiveTrackColor: Colors.grey[400],
              disabledThumbColor: Colors.grey[500],
              activeTrackColor: Theme
                  .of(context)
                  .colorScheme
                  .secondary,
              inactiveTrackColor: Theme
                  .of(context)
                  .colorScheme
                  .secondary,
              thumbColor: Theme
                  .of(context)
                  .colorScheme
                  .primary));
    }

    return Theme(
      data: isLightMode(context: context) ? _themeData : _darkThemeData,
      child: Slider(
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
      ),
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

  StickSliderTile({this.labelWidth,
    this.label,
    this.enabled = true,
    this.max = 1000,
    this.min = 0,
    this.value,
    this.onChanged});

  @override
  _StickSliderTileState createState() => _StickSliderTileState();
}

class _StickSliderTileState extends State<StickSliderTile> {
  var _numberTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var _value = widget.value;
    var rounded = getRoundString(_value, 1);
    if (_numberTextController.text != rounded) {
      _numberTextController.text = getRoundString(_value, 1);
    }

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
              enabled: widget.enabled,
              controller: _numberTextController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.numberWithOptions(signed: widget.min < 0, decimal: true),
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
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
