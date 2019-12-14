import 'package:flutter/material.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/widgets/CrossFade.dart';

import '../../../tools.dart';
import 'SmallMarkChart.dart';
import 'SmallMarkChartDetail.dart';

class MarksListTile extends StatefulWidget {
  final Assignment _assignment;
  final WeightTable _weights;
  final Key key;
  final bool whatIfMode;
  final Function editAssignment;
  final Function removeAssignment;

  MarksListTile(this._assignment, this._weights, this.whatIfMode,
      {this.key, this.editAssignment, this.removeAssignment})
      : super(key: key);

  @override
  MarksListTileState createState() => MarksListTileState(_assignment, _weights);
}

class MarksListTileState extends State<MarksListTile>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final Assignment _assignment;
  final WeightTable _weights;
  var showDetail = false;

  MarksListTileState(this._assignment, this._weights);

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var avg = _assignment.getAverage(_weights);
    var avgText = avg == null
        ? SizedBox(width: 0, height: 0)
        : Text(Strings.get("avg:") + num2Str(avg) + "%",
            style: TextStyle(fontSize: 16, color: Colors.grey));

    var summary = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        key: Key("summary"),
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_assignment.displayName, style: Theme.of(context).textTheme.title),
                SizedBox(
                  height: 4,
                ),
                avgText,
                if (_assignment.isNoWeight)
                  Text(Strings.get("no_weight"),
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                if (_assignment.feedback != null)
                  Text(Strings.get("feedback_available"),
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
              ],
            ),
          ),
          Flexible(child: SmallMarkChart(_assignment))
        ],
      ),
    );
    var detail = Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        key: Key("detail"),
        children: <Widget>[
          CrossFade(
            firstChild: SizedBox(
              height: 16,
              width: double.infinity,
            ),
            secondChild: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton.icon(
                  label: Text(Strings.get("edit").toUpperCase()),
                  icon: Icon(Icons.edit),
                  disabledTextColor:
                  isLightMode(context: context) ? Colors.grey[700] : Colors.grey[300],
                  textColor: isLightMode(context: context) ? Colors.grey[700] : Colors.grey[300],
                  onPressed: _assignment.expanded == true
                      ? () {
                    widget.editAssignment(context, _assignment);
                  }
                      : null,
                ),
                SizedBox(
                  width: 24,
                ),
                FlatButton.icon(
                  label: Text(Strings.get("remove").toUpperCase()),
                  icon: Icon(Icons.delete),
                  disabledTextColor:
                  isLightMode(context: context) ? Colors.grey[700] : Colors.grey[300],
                  textColor: isLightMode(context: context) ? Colors.grey[700] : Colors.grey[300],
                  onPressed: _assignment.expanded == true
                      ? () {
                    widget.removeAssignment(_assignment);
                  }
                      : null,
                ),
              ],
            ),
            showFirst: widget.whatIfMode != true,
          ),
          Text(
            _assignment.displayName,
            style: Theme.of(context).textTheme.title,
          ),
          SizedBox(
            height: 4,
          ),
          avgText,
          SizedBox(
            height: 4,
          ),
          if (_assignment.feedback != null)
            Text(
              Strings.get("feedback:") + _assignment.feedback,
              style: TextStyle(
                  fontSize: 16,
                  color: isLightMode(context: context) ? Colors.grey[800] : Colors.grey[200]),
              textAlign: TextAlign.center,
            ),
          SizedBox(
            height: 12,
          ),
          SmallMarkChartDetail(_assignment)
        ],
      ),
    );

    return Container(
      color: _assignment.edited == true ? Colors.amber.withAlpha(40) : null,
      child: InkWell(
        onTap: () {
          setState(() {
            if (_assignment.expanded == true) {
              _assignment.expanded = false;
            } else {
              _assignment.expanded = true;
            }
          });
        },
        child: CrossFade(
          firstChild: summary,
          secondChild: detail,
          showFirst: _assignment.expanded != true,
        ),
      ),
    );
  }
}
