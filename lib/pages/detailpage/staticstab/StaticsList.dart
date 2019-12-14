import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';
import 'package:ta/widgets/CrossFade.dart';
import 'package:ta/widgets/LinearProgressIndicator.dart' as LPI;
import 'package:flutter/foundation.dart' as Foundation;

class StaticsList extends StatefulWidget {
  StaticsList(this._course, this._whatIfMode);

  final Course _course;
  final bool _whatIfMode;

  @override
  _StaticsListState createState() => _StaticsListState();
}

class _StaticsListState extends State<StaticsList> with AutomaticKeepAliveClientMixin {
  final Map<Category, Color> darkColorMap = {
    Category.KU: const Color(0xffc49000),
    Category.T: const Color(0xff388e3c),
    Category.C: const Color(0xff3949ab),
    Category.A: const Color(0xffef6c00),
  };


  final Map<Category, Color> lightColorMap = {
    Category.KU: const Color(0xffffeb3b),
    Category.T: const Color(0xff8bc34a),
    Category.C: const Color(0xff9fa8da),
    Category.A: const Color(0xffffb74d),
    Category.O: const Color(0xff90a4ae),
    Category.F: null,
  };

  _StaticsListState();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    lightColorMap[Category.F] = primaryColorOf(context);

    var _course = widget._course;
    var isLight = isLightMode(context: context);
    var sidePadding = (widthOf(context) - 500) / 2;
    return (_course.overallMark != null && _course.assignments.length > 0)
        ? ListView(
      padding: EdgeInsets.symmetric(
        horizontal: sidePadding > 0 ? sidePadding : 0,
      ),
      children: <Widget>[
        _getTermOverall(),
        _getOverallChart(isLight),
        Divider(),
        _getPieChart(),
        Divider(),
        _getChart(Category.KU, isLight),
        Divider(),
        _getChart(Category.T, isLight),
        Divider(),
        _getChart(Category.C, isLight),
        Divider(),
        _getChart(Category.A, isLight),
      ],
    )
        : Center(
      child: Text(
        Strings.get("statistics_unavailable"),
        style: Theme
            .of(context)
            .textTheme
            .subhead,
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
    var _course = widget._course;
    var analysis = widget._whatIfMode ? _course.getCourseAnalysis() : null;
    final List<_PieData> chartData = widget._whatIfMode ? [
      for (final category in Category.values)
        if (category != Category.O || _course.weightTable[Category.O].CW > 0)
          _PieData(
              Strings.get(Foundation.describeEnum(category).toLowerCase()),
              _course.weightTable[category].CW,
              analysis[category],
              lightColorMap[category])
    ] : [
      for (final category in Category.values)
        if (category != Category.O || _course.weightTable[Category.O].CW > 0)
          _PieData(
              Strings.get(Foundation.describeEnum(category).toLowerCase()),
              _course.weightTable[category].CW,
              _course.weightTable[category].SA,
              lightColorMap[category])
    ];
    return <PieSeries<_PieData, String>>[
      PieSeries<_PieData, String>(
          explodeAll: true,
          animationDuration: 0,
          dataSource: chartData,
          pointColorMapper: (data, _) => data.get > 0 ? data.color : Colors.grey,
          xValueMapper: (data, _) => data.name,
          yValueMapper: (data, _) => data.weight,
          enableSmartLabels: false,
          dataLabelMapper: (data, _) => data.name + "\n" + num2Str(data.get) + "%",
          startAngle: 90,
          endAngle: 90,
          pointRadiusMapper: (data, _) => ((data.get) * 0.7 + 20).toString() + "%",
          dataLabelSettings: DataLabelSettings(
              textStyle: ChartTextStyle(
                  color: isLightMode(context: context) ? Colors.black : Colors.white),
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
              labelIntersectAction: LabelIntersectAction.none))
    ];
  }

  Widget _getTermOverall() {
    var _course = widget._course;
    var newOverall = _course
        .getCourseAnalysis()
        .overallList
        .last;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: <Widget>[
          Text(
            Strings.get("overall"),
            style: Theme
                .of(context)
                .textTheme
                .title,
          ),
          CrossFade(
            showFirst: !widget._whatIfMode,
            firstChild: Center(
              child: Text(
                num2Str(_course.overallMark) + "%",
                style: TextStyle(fontSize: 60),
              ),
            ),
            secondChild: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  num2Str(_course.overallMark) + "%",
                  style: TextStyle(fontSize: 40),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.arrow_forward, size: 32),
                ),
                Text(
                  num2Str(newOverall) + "%",
                  style: TextStyle(fontSize: 40),
                ),
              ],
            ),
          ),
          widget._whatIfMode
              ? (_course.overallMark > newOverall
              ? LPI.LinearProgressIndicator(
            key: Key("a"),
            lineHeight: 20.0,
            value1: newOverall / 100,
            value2: _course.overallMark / 100,
            value1Color: Theme
                .of(context)
                .colorScheme
                .primary,
            value2Color: Colors.red[400],
          )
              : LPI.LinearProgressIndicator(
            key: Key("b"),
            lineHeight: 20.0,
            value1: _course.overallMark / 100,
            value2: newOverall / 100,
            value1Color: Theme
                .of(context)
                .colorScheme
                .primary,
            value2Color: Colors.green,
          ))
              : LPI.LinearProgressIndicator(
            key: Key("c"),
            lineHeight: 20.0,
            value1: _course.overallMark / 100,
            value1Color: Theme
                .of(context)
                .colorScheme
                .primary,
          )
        ],
      ),
    );
  }

  Widget _getOverallChart(bool isLight) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 4),
          SizedBox(
            width: double.maxFinite,
            height: 200,
            child: _getDefaultSplineChart(_getChartData(null, isLight, isOverall: true)),
          ),
        ],
      ),
    );
  }

  Widget _getChart(Category category, bool isLight) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              Strings.get(Foundation.describeEnum(category).toLowerCase() + "_long"),
              style: Theme
                  .of(context)
                  .textTheme
                  .title,
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            height: 200,
            child: _getDefaultSplineChart(_getChartData(category, isLight)),
          ),
        ],
      ),
    );
  }

  List<SplineSeries<Assignment, String>> _getChartData(Category category, bool isLight,
      {bool isOverall = false}) {
    var _course = widget._course;
    Color color;
    ChartValueMapper<Assignment, num> yValueMapper;

    if (isOverall) {
      var overallList = _course
          .getCourseAnalysis()
          .overallList;
      yValueMapper = (_, index) {
        return num2Round(overallList[index]);
      };
      color = primaryColorOf(context);
    } else {
      color = isLight ? darkColorMap[category] : lightColorMap[category];
      yValueMapper = (Assignment assignment, _) =>
      assignment[category].hasFinished
          ? num2Round(assignment[category].percentage * 100)
          : null;
    }

    return [
      SplineSeries<Assignment, String>(
        animationDuration: 1,
        color: color,
        markerSettings: MarkerSettings(
          isVisible: true,
          color: Theme
              .of(context)
              .canvasColor,
          borderWidth: 3,
        ),
        enableTooltip: true,
        splineType: SplineType.monotonic,
        dataSource: _course.assignments,
        emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.drop),
        xValueMapper: (Assignment assignment, _) => assignment.name,
        yValueMapper: yValueMapper,
        name: Strings.get(isOverall ? "overall" :
        Foundation.describeEnum(category).toLowerCase() + "_long"),
      )
    ];
  }

  SfCartesianChart _getDefaultSplineChart(List<SplineSeries<Assignment, String>> data) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(isVisible: false),
      primaryYAxis: NumericAxis(
          minimum: 0,
          maximum: 105,
          axisLine: AxisLine(width: 0),
          labelFormat: '{value}%',
          maximumLabels: 5,
          majorTickLines: MajorTickLines(size: 0)),
      series: data,
      tooltipBehavior: TooltipBehavior(
        enable: true,
        animationDuration: 0,
      ),
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
