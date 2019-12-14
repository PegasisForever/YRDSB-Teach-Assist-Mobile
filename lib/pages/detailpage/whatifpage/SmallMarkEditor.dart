import 'package:flutter/material.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/pages/detailpage/whatifpage/SmallMarkBar.dart';
import 'package:ta/tools.dart';

class SmallMarkEditor extends StatefulWidget {
  final SmallMark smallMark;
  final Category category;
  final ValueChanged<SmallMark> onChanged;

  SmallMarkEditor({this.smallMark, this.category, this.onChanged});

  @override
  _SmallMarkEditorState createState() => _SmallMarkEditorState();
}

class _SmallMarkEditorState extends State<SmallMarkEditor> {
  var _weightTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _weightTextController.text =
        widget.smallMark != null ? getRoundString(widget.smallMark.weight, 2) : "0";
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: Column(
        children: <Widget>[
          Expanded(
            child: SmallMarkBar(widget.smallMark, widget.category),
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
                    widget.smallMark.weight = newWeight;
                    _weightTextController.text = getRoundString(widget.smallMark.weight, 2);
                    widget.onChanged(widget.smallMark);
                  } else {
                    setState(() {
                      _weightTextController.text = getRoundString(widget.smallMark.weight, 2);
                    });
                  }
                },
                decoration: InputDecoration(
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
