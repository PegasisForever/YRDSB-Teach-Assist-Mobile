import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ta/plugins/dataStore.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/pages/detailpage/abouttab/AboutTab.dart';
import 'package:ta/pages/detailpage/assignmentstab/MarksList.dart';
import 'package:ta/pages/detailpage/statisticstab/StatisticsList.dart';
import 'package:ta/res/CustomIcons.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';
import 'package:ta/widgets/BetterState.dart';
import 'package:ta/widgets/CrossFade.dart';

class DetailPage extends StatefulWidget {
  DetailPage(this.course);

  final Course course;

  @override
  _DetailPageState createState() => _DetailPageState(course);
}

class _DetailPageState extends BetterState<DetailPage> {
  Course _course;
  Course _originalCourse;
  var whatIfMode = false;
  var showWhatIfTips = prefs.getBool("show_what_if_tip") ?? true;

  _DetailPageState(Course course)
      : _course = course.copy(),
        _originalCourse = course.copy();

  updateCourse(course) {
    setState(() {
      _course = course;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_course.displayName, maxLines: 2),
          actions: <Widget>[
            if (_course.overallMark != null)
              IconButton(
                icon: Icon(whatIfMode ? CustomIcons.lightbulb_filled : Icons.lightbulb_outline),
                onPressed: () async {
                  if (showWhatIfTips) {
                    var isEnableWhatIf =
                        await Navigator.pushNamed(context, "/detail/whatif_welcome");
                    if (isEnableWhatIf != true) {
                      return;
                    }
                    showWhatIfTips = false;
                    prefs.setBool("show_what_if_tip", false);
                  }
                  setState(() {
                    whatIfMode = !whatIfMode;
                    if (!whatIfMode) {
                      _course = _originalCourse.copy();
                    }
                  });
                },
              )
          ],
          bottom: TabBar(
            isScrollable: widthOf(context) > 500,
            indicatorColor: getPrimary(),
            labelColor: Theme.of(context).textTheme.title.color,
            tabs: [
              Tab(text: Strings.get("assignments")),
              Tab(text: Strings.get("statistics")),
              Tab(text: Strings.get("about")),
            ],
          ),
          textTheme: Theme.of(context).textTheme,
          iconTheme: Theme.of(context).iconTheme,
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              flex: 0,
              child: CrossFade(
                key: Key("add-btn"),
                firstChild: Container(
                  color: Colors.amber,
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(Strings.get("what_if_mode_activated"),
                        style: TextStyle(color: Colors.black)),
                  )),
                ),
                secondChild: Container(),
                showFirst: whatIfMode,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  MarksList(_course, whatIfMode, updateCourse),
                  StatisticsList(_course, whatIfMode),
                  AboutTab(_course),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
