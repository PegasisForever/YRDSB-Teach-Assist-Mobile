import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';

class StaticsList extends StatefulWidget {
  StaticsList(this._course);

  final Course _course;

  @override
  _StaticsListState createState() => _StaticsListState(_course);
}

class _StaticsListState extends State<StaticsList> {
  final Course _course;
  final Color _Kcolor = Color(0xffc49000);
  final Color _Tcolor = Color(0xff388e3c);
  final Color _Ccolor = Color(0xff3949ab);
  final Color _Acolor = Color(0xffef6c00);

  final Color _KPcolor = Color(0xffffeb3b);
  final Color _TPcolor = Color(0xff8bc34a);
  final Color _CPcolor = Color(0xff9fa8da);
  final Color _APcolor = Color(0xffffb74d);
  final Color _FPcolor = Color(0xff81d4fa);

  _StaticsListState(this._course);

  @override
  Widget build(BuildContext context) {
    return _course.overallMark != null
        ? ListView(
            children: <Widget>[
              _getTermOverall(),
              Divider(),
              _getPieChart(),
              Divider(),
              _getChart("knowledge_understanding"),
              Divider(),
              _getChart("thinking"),
              Divider(),
              _getChart("communication"),
              Divider(),
              _getChart("application"),
            ],
          )
        : Center(
            child: Text(
              Strings.get("statics_unavailable"),
              style: Theme.of(context).textTheme.subhead,
            ),
          );
  }

  Widget _getPieChart() {
    return SizedBox(
      width: double.maxFinite,
      height: 250,
      child: SfCircularChart(
        series: _getPieSeries(),
      ),
    );
  }

  List<PieSeries<_PieData, String>> _getPieSeries() {
    final List<_PieData> chartData = <_PieData>[
      _PieData('A', _course.weights.A.CW, _course.weights.A.SA, _APcolor),
      _PieData('C', _course.weights.C.CW, _course.weights.C.SA, _CPcolor),
      _PieData('T', _course.weights.T.CW, _course.weights.T.SA, _TPcolor),
      _PieData('K/U', _course.weights.KU.CW, _course.weights.KU.SA, _KPcolor),
      _PieData('Final', _course.weights.F.CW, _course.weights.F.SA, _FPcolor),
    ];
    return <PieSeries<_PieData, String>>[
      PieSeries<_PieData, String>(
          explodeAll:true,
          animationDuration: 0,
          dataSource: chartData,
          pointColorMapper: (data, _) => data.get>0?data.color:Colors.grey,
          xValueMapper: (data, _) => data.name,
          yValueMapper: (data, _) => data.weight,
          enableSmartLabels: false,
          dataLabelMapper: (data, _) =>
              data.name + "\n" + getRoundString(data.get, 2) + "%",
          startAngle: 90,
          endAngle: 90,
          pointRadiusMapper: (data, _) => ((data.get)*0.7+20).toString() + "%",
          dataLabelSettings: DataLabelSettings(
              isVisible: true, labelPosition: LabelPosition.outside,
              labelIntersectAction: LabelIntersectAction.none))
    ];
  }

  Widget _getTermOverall() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Text(
            Strings.get("overall"),
            style: Theme.of(context).textTheme.title,
          ),
          Text(
            getRoundString(_course.overallMark, 2) + "%",
            style: TextStyle(fontSize: 60),
          ),
          LinearPercentIndicator(
            animation: false,
            lineHeight: 20.0,
            animationDuration: 500,
            percent: _course.overallMark / 100,
            linearStrokeCap: LinearStrokeCap.roundAll,
            progressColor: Theme.of(context).accentColor,
          )
        ],
      ),
    );
  }

  Widget _getChart(String category) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              Strings.get(category),
              style: Theme.of(context).textTheme.title,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          SizedBox(
            width: double.maxFinite,
            height: 200,
            child: _getDefaultSplineChart(_getChartData(category)),
          ),
        ],
      ),
    );
  }

  List<SplineSeries<Assignment, String>> _getChartData(String category) {
    ChartValueMapper<Assignment, num> yValueMapper;
    Color color;
    if (category == "knowledge_understanding") {
      yValueMapper = (Assignment assignment, _) => assignment.KU.available
          ? assignment.KU.get / assignment.KU.total * 100
          : null;
      color = _Kcolor;
    } else if (category == "thinking") {
      yValueMapper = (Assignment assignment, _) => assignment.T.available
          ? assignment.T.get / assignment.T.total * 100
          : null;
      color = _Tcolor;
    } else if (category == "communication") {
      yValueMapper = (Assignment assignment, _) => assignment.C.available
          ? assignment.C.get / assignment.C.total * 100
          : null;
      color = _Ccolor;
    } else if (category == "application") {
      yValueMapper = (Assignment assignment, _) => assignment.A.available
          ? assignment.A.get / assignment.A.total * 100
          : null;
      color = _Acolor;
    }

    return <SplineSeries<Assignment, String>>[
      SplineSeries<Assignment, String>(
        animationDuration: 1,
        color: color,
        enableTooltip: true,
        dataSource: _course.assignments,
        emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.drop),
        xValueMapper: (Assignment assignment, _) => assignment.name,
        yValueMapper: yValueMapper,
        markerSettings: MarkerSettings(isVisible: true),
        name: Strings.get(category),
      )
    ];
  }

  SfCartesianChart _getDefaultSplineChart(
      List<SplineSeries<Assignment, String>> data) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(isVisible: false),
      primaryYAxis: NumericAxis(
          minimum: 0,
          maximum: 110,
          axisLine: AxisLine(width: 0),
          labelFormat: '{value}%',
          maximumLabels: 5,
          majorTickLines: MajorTickLines(size: 0)),
      series: data,
      tooltipBehavior:
          TooltipBehavior(enable: true, opacity: 0.7, animationDuration: 0),
    );
  }
}

class _PieData {
  _PieData(this.name, this.weight, this.get, this.color);

  final String name;
  final double weight;
  final double get;
  final Color color;
}
