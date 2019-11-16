import 'package:flutter/material.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/res/Strings.dart';

import '../../../tools.dart';
import 'SmallMarkChart.dart';
import 'SmallMarkChartDetail.dart';

class MarksListTile extends StatefulWidget {
  final Assignment _assignment;
  final WeightTable _weights;
  final Key key;

  MarksListTile(this._assignment, this._weights, {this.key});

  @override
  MarksListTileState createState() => MarksListTileState(_assignment, _weights, key);
}

class MarksListTileState extends State<MarksListTile>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final Assignment _assignment;
  final WeightTable _weights;
  final Key key;
  var showDetail = false;

  MarksListTileState(this._assignment, this._weights, this.key);

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var avg = _assignment.getAverage(_weights);
    var avgText = avg == null
        ? SizedBox(width: 0, height: 0)
        : Text(Strings.get("avg:") + _assignment.getAverage(_weights),
            style: TextStyle(fontSize: 16, color: Colors.grey));

    bool noWeight = isZeroOrNull(_assignment.KU.weight) &&
        isZeroOrNull(_assignment.T.weight) &&
        isZeroOrNull(_assignment.C.weight) &&
        isZeroOrNull(_assignment.A.weight) &&
        isZeroOrNull(_assignment.F.weight) &&
        isZeroOrNull(_assignment.O.weight);

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
                if (noWeight)
                  Text(Strings.get("no_weight"),
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                if (_assignment.feedback != null)
                  Text("Feedback avaliable", style: TextStyle(fontSize: 16, color: Colors.grey)),
              ],
            ),
          ),
          Flexible(child: SmallMarkChart(_assignment))
        ],
      ),
    );
    var detail = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        key: Key("detail"),
        children: <Widget>[
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
              "Feedback: " + _assignment.feedback,
              style: TextStyle(
                  fontSize: 16, color: isLightMode(context) ? Colors.grey[800] : Colors.grey[200]),
              textAlign: TextAlign.center,
            ),
          SizedBox(
            height: 12,
          ),
          SmallMarkChartDetail(_assignment)
        ],
      ),
    );

    return InkWell(
      key: key,
      onTap: () {
        setState(() {
          showDetail = !showDetail;
        });
      },
      child: AnimatedCrossFade(
        firstChild: summary,
        secondChild: detail,
        crossFadeState: showDetail ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 300),
        firstCurve: Curves.easeInOutCubic,
        secondCurve: Curves.easeInOutCubic,
        sizeCurve: Curves.easeInOutCubic,
      ),
    );
  }
}
