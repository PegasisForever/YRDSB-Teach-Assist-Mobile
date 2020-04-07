import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';
import 'package:ta/widgets/DenseCheckboxListTile.dart';

class SmallMarkDetailEditDialog extends StatefulWidget {
  final SmallMark smallMark;
  final Category category;

  SmallMarkDetailEditDialog({this.smallMark, this.category});

  @override
  _SmallMarkDetailEditDialogState createState() => _SmallMarkDetailEditDialogState();
}

class _SmallMarkDetailEditDialogState extends State<SmallMarkDetailEditDialog> {
  var _getTextController = TextEditingController();
  var _totalTextController = TextEditingController();
  var _percentageTextController = TextEditingController();
  var _weightTextController = TextEditingController();
  String _getText = "";
  String _totalText = "";
  String _percentageText = "";
  String _weightText = "";
  SmallMark smallMark;

  @override
  void initState() {
    super.initState();
    smallMark = widget.smallMark;
    if (smallMark == null)
      smallMark = SmallMark.blank()
        ..enabled = false
        ..finished = true
        ..total = 100
        ..get = 90
        ..weight = 10;

    _getText = getRoundString(smallMark.get, 2);
    _totalText = getRoundString(smallMark.total, 2);
    _percentageText = getRoundString(smallMark.percentage * 100, 2);
    _weightText = getRoundString(smallMark.weight, 2);

    if (smallMark.enabled) {
      _totalTextController.text = _totalText;
      _weightTextController.text = _weightText;
      if (smallMark.finished) {
        _getTextController.text = _getText;
        _percentageTextController.text = _percentageText;
      }
    }
  }

  void updatePercentageText() {
    _percentageText = getRoundString(smallMark.percentage * 100, 2);
    if (smallMark.enabled && smallMark.finished) {
      _percentageTextController.text = _percentageText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Text(
              sprintf(Strings.get("edit_mark"), [Strings.get(describeEnum(widget.category).toLowerCase() + "_long")]),
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: DenseCheckboxListTile(
                  text: Text(Strings.get("available")),
                  value: smallMark.enabled,
                  onChanged: (value) {
                    setState(() {
                      smallMark.enabled = value;
                      if (value) {
                        if (smallMark.finished) {
                          _getTextController.text = _getText;
                          _percentageTextController.text = _percentageText;
                        }
                        _totalTextController.text = _totalText;
                        _weightTextController.text = _weightText;
                      } else {
                        if (_getTextController.text != "") _getText = _getTextController.text;
                        if (_totalTextController.text != "") _totalText = _totalTextController.text;
                        if (_percentageTextController.text != "") _percentageText = _percentageTextController.text;
                        if (_weightTextController.text != "") _weightText = _weightTextController.text;

                        _getTextController.text = "";
                        _totalTextController.text = "";
                        _percentageTextController.text = "";
                        _weightTextController.text = "";
                      }
                    });
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: DenseCheckboxListTile(
                  text: Text(Strings.get("finished")),
                  value: smallMark.finished,
                  onChanged: smallMark.enabled
                      ? (value) {
                          setState(() {
                            smallMark.finished = value;
                            if (value) {
                              if (smallMark.enabled) {
                                _getTextController.text = _getText;
                                _percentageTextController.text = _percentageText;
                              }
                            } else {
                              if (_getTextController.text != "") _getText = _getTextController.text;
                              if (_totalTextController.text != "") _totalText = _totalTextController.text;
                              if (_percentageTextController.text != "")
                                _percentageText = _percentageTextController.text;
                              if (_weightTextController.text != "") _weightText = _weightTextController.text;

                              _getTextController.text = "";
                              _percentageTextController.text = "";
                            }
                          });
                        }
                      : null,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: _getTextController,
                    autofocus: true,
                    enabled: smallMark.enabled && smallMark.finished,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    onChanged: (str) {
                      var newGet = double.tryParse(str);
                      if (newGet != null) {
                        setState(() {
                          smallMark.get = newGet;
                          updatePercentageText();
                        });
                      }
                    },
                    onSubmitted: (str) {
                      var newGet = double.tryParse(str);
                      if (newGet != null) {
                        setState(() {
                          smallMark.get = newGet;
                          _getTextController.text = getRoundString(smallMark.get, 2);
                          updatePercentageText();
                        });
                      } else {
                        setState(() {
                          _getTextController.text = getRoundString(smallMark.get, 2);
                          updatePercentageText();
                        });
                      }
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                    ),
                  ),
                ),
                Text(" / ", style: TextStyle(fontSize: 20)),
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: _totalTextController,
                    enabled: smallMark.enabled,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    onChanged: (str) {
                      var newTotal = double.tryParse(str);
                      if (newTotal != null) {
                        setState(() {
                          smallMark.total = newTotal;
                          updatePercentageText();
                        });
                      }
                    },
                    onSubmitted: (str) {
                      var newTotal = double.tryParse(str);
                      if (newTotal != null) {
                        setState(() {
                          smallMark.total = newTotal;
                          _totalTextController.text = getRoundString(smallMark.total, 2);
                          updatePercentageText();
                        });
                      } else {
                        setState(() {
                          _totalTextController.text = getRoundString(smallMark.total, 2);
                          updatePercentageText();
                        });
                      }
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                    ),
                  ),
                ),
                Text(" = ", style: TextStyle(fontSize: 20)),
                SizedBox(
                  width: 70,
                  child: TextField(
                    controller: _percentageTextController,
                    enabled: smallMark.enabled && smallMark.finished,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    onChanged: (str) {
                      var newPercentage = double.tryParse(str);
                      if (newPercentage != null) {
                        setState(() {
                          smallMark.get = newPercentage / 100 * smallMark.total;
                          _getTextController.text = getRoundString(smallMark.get, 2);
                        });
                      }
                    },
                    onSubmitted: (str) {
                      var newPercentage = double.tryParse(str);
                      if (newPercentage != null) {
                        setState(() {
                          smallMark.get = newPercentage / 100 * smallMark.total;
                          _getTextController.text = getRoundString(smallMark.get, 2);
                          _percentageTextController.text = getRoundString(smallMark.percentage * 100, 2);
                        });
                      } else {
                        setState(() {
                          _getTextController.text = getRoundString(smallMark.get, 2);
                          _percentageTextController.text = getRoundString(smallMark.percentage * 100, 2);
                        });
                      }
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      suffixText: "%",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                Text(Strings.get("weight:")),
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: _weightTextController,
                    enabled: smallMark.enabled,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    onChanged: (str) {
                      var newWeight = double.tryParse(str);
                      if (newWeight != null) {
                        smallMark.weight = newWeight;
                      }
                    },
                    onSubmitted: (str) {
                      var newWeight = double.tryParse(str);
                      if (newWeight != null) {
                        setState(() {
                          smallMark.weight = newWeight;
                          _weightTextController.text = getRoundString(smallMark.weight, 2);
                        });
                      } else {
                        setState(() {
                          _weightTextController.text = getRoundString(smallMark.weight, 2);
                        });
                      }
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                    ),
                  ),
                )
              ],
            ),
          ),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text(Strings.get("cancel").toUpperCase()),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              RaisedButton(
                color: Theme.of(context).colorScheme.primary,
                child: Text(
                  Strings.get("save").toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop(smallMark);
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
