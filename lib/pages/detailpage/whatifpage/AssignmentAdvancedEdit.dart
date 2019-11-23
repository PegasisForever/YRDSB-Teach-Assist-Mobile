import 'package:flutter/material.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/widgets/StickSlider.dart';

class AdvancedEdit extends StatefulWidget {
  final Assignment assignment;
  final ValueChanged<Assignment> onChanged;

  AdvancedEdit({this.assignment, this.onChanged});

  @override
  AdvancedEditState createState() => AdvancedEditState();
}

class AdvancedEditState extends State<AdvancedEdit> {
  @override
  Widget build(BuildContext context) {
    var assi = widget.assignment;
    return Column(
      children: <Widget>[
        TabBar(
          isScrollable: true,
          labelColor: Theme.of(context).colorScheme.primary,
          tabs: [
            Tab(text: Strings.get("ku")),
            Tab(text: Strings.get("t")),
            Tab(text: Strings.get("c")),
            Tab(text: Strings.get("a")),
            Tab(text: Strings.get("o")),
          ],
        ),
        SizedBox(
          height: 192,
          child: TabBarView(
            children: <Widget>[
              _SmallMarkAdvancedEdit(
                category: "ku",
                smallMark: assi.KU,
                onChanged: (mark) {
                  assi.KU = mark;
                  widget.onChanged(assi);
                },
              ),
              _SmallMarkAdvancedEdit(
                category: "t",
                smallMark: assi.T,
                onChanged: (mark) {
                  assi.T = mark;
                  widget.onChanged(assi);
                },
              ),
              _SmallMarkAdvancedEdit(
                category: "c",
                smallMark: assi.C,
                onChanged: (mark) {
                  assi.C = mark;
                  widget.onChanged(assi);
                },
              ),
              _SmallMarkAdvancedEdit(
                category: "a",
                smallMark: assi.A,
                onChanged: (mark) {
                  assi.A = mark;
                  widget.onChanged(assi);
                },
              ),
              _SmallMarkAdvancedEdit(
                category: "o",
                smallMark: assi.O,
                onChanged: (mark) {
                  assi.O = mark;
                  widget.onChanged(assi);
                },
              ),
            ],
          ),
          ),

      ],
    );
  }
}

class _SmallMarkAdvancedEdit extends StatefulWidget {
  final String category;
  final SmallMark smallMark;

  final ValueChanged<SmallMark> onChanged;

  _SmallMarkAdvancedEdit({this.category, this.smallMark, this.onChanged})
      : super(key: Key(category));

  @override
  _SmallMarkAdvancedEditState createState() => _SmallMarkAdvancedEditState();
}

class _SmallMarkAdvancedEditState extends State<_SmallMarkAdvancedEdit> {
  @override
  Widget build(BuildContext context) {
    var mark = widget.smallMark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Enabled",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Checkbox(
                value: mark.available,
                onChanged: (v) {
                  setState(() {
                    mark.available = v;
                    widget.onChanged(mark);
                  });
                },
              )
            ],
          ),
        ),
        StickSliderTile(
          enabled: mark.available,
          value: mark.get,
          min: 0,
          max: mark.total ?? 100,
          label: "Get",
          labelWidth: 60,
          onChanged: (value) {
            setState(() {
              mark.get = value;
              widget.onChanged(mark);
            });
          },
        ),
        StickSliderTile(
          enabled: mark.available,
          value: mark.total,
          min: mark.get ?? 0,
          max: 100,
          label: "Total",
          labelWidth: 60,
          onChanged: (value) {
            setState(() {
              mark.total = value;
              widget.onChanged(mark);
            });
          },
        ),
        StickSliderTile(
          enabled: mark.available,
          value: mark.weight,
          min: 0,
          max: 50,
          label: "Weight",
          labelWidth: 60,
          onChanged: (value) {
            setState(() {
              mark.weight = value;
              widget.onChanged(mark);
            });
          },
        ),
      ],
    );
  }
}
