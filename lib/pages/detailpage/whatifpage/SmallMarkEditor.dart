import 'package:flutter/material.dart';
import 'package:quiver/core.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/pages/detailpage/whatifpage/SmallMarkBar.dart';
import 'package:ta/tools.dart';

class SmallMarkEditor extends StatefulWidget {
  final SmallMark smallMark;
  final Category category;
  final ValueChanged<SmallMark> onChanged;

  SmallMarkEditor({this.smallMark, this.category, this.onChanged,Key key})
      : super(key: key);

  @override
  _SmallMarkEditorState createState() => _SmallMarkEditorState();
}

class _SmallMarkEditorState extends State<SmallMarkEditor> {
  var _weightTextController = TextEditingController();
  SmallMark smallMark;
  double _percentage;

  @override
  void initState() {
    super.initState();
    smallMark = widget.smallMark;
    _weightTextController.text = smallMark != null ? getRoundString(smallMark.weight, 2) : "";
    _percentage = smallMark != null ? smallMark.percentage * 100 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              child: SmallMarkBar(smallMark, widget.category),
              onLongPress: () {
                  if (smallMark != null) {
                    smallMark = null;
                    _percentage = 0;
                    _weightTextController.text = "";
                  } else {
                    smallMark = SmallMark.blank()
                      ..finished = true
                      ..total = 100
                      ..get = 90
                      ..weight = 10;
                    _percentage = 90;
                    _weightTextController.text = "10";
                  }
                  widget.onChanged(smallMark);
              },
              onVerticalDragUpdate: (details) {
                _percentage += -details.primaryDelta / 0.9;
                if (_percentage > 100) _percentage = 100;
                if (_percentage < 0) _percentage = 0;

                  if (smallMark != null) {
                    smallMark.finished = true;
                  } else {
                    smallMark = SmallMark.blank()
                      ..finished = true
                      ..total = 100
                      ..get = 0
                      ..weight = 10;
                    _percentage = 0;
                    _weightTextController.text = "10";
                  }
                  smallMark.get = (smallMark.total * _percentage / 100 * 2).floorToDouble() / 2;
                  widget.onChanged(smallMark);

              },
            ),
          ),
          Flexible(
            flex: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: TextField(
                controller: _weightTextController,
                style: TextStyle(fontSize: 13, color: getGrey(context: context)),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (str) {
                  var newWeight = double.tryParse(str);
                  if (newWeight != null) {
                    smallMark.weight = newWeight;
                    _weightTextController.text = getRoundString(smallMark.weight, 2);
                    widget.onChanged(smallMark);
                  } else {
                    setState(() {
                      _weightTextController.text = getRoundString(smallMark.weight, 2);
                    });
                  }
                },
                decoration: InputDecoration(
                  enabled: smallMark != null,
                  prefix: Text("w: "),
                  contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
