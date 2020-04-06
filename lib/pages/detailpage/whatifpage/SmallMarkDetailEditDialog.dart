import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';

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
  String _getText;
  String _totalText;
  String _percentageText;
  String _weightText;
  SmallMark smallMark;

  @override
  void initState() {
    super.initState();
    smallMark = widget.smallMark;

    _getText = num2Str(smallMark.get);
    _totalText = num2Str(smallMark.total);
    _percentageText = num2Str(smallMark.percentage * 100);
    _weightText = num2Str(smallMark.weight);
    _getTextController.text = _getText;
    _totalTextController.text = _totalText;
    _percentageTextController.text = _percentageText;
    _weightTextController.text = _weightText;
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
                child: CheckboxListTile(
                  dense: true,
                  title: Text(Strings.get("available")),
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
                child: CheckboxListTile(
                  dense: true,
                  title: Text(Strings.get("finished")),
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
                    enabled: smallMark.enabled && smallMark.finished,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                Text("Weight: "),
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: _weightTextController,
                    enabled: smallMark.enabled,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
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
              RaisedButton(
                color: Theme.of(context).colorScheme.primary,
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
