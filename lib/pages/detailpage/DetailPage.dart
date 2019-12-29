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

class _DetailPageState extends BetterState<DetailPage> with SingleTickerProviderStateMixin {
  Course _course;
  Course _originalCourse;
  var whatIfMode = false;
  var showWhatIfTips = prefs.getBool("show_what_if_tip") ?? true;
  Animation<double> _animation;
  Tween<double> _tween;
  AnimationController _animationController;

  _DetailPageState(Course course)
      : _course = course.copy(),
        _originalCourse = course.copy();

  updateCourse(course) {
    setState(() {
      _course = course;
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _tween = Tween(begin: 48, end: 80);
    var curve = CurvedAnimation(parent: _animationController, curve: Curves.easeInOutCubic);
    _animation = _tween.animate(curve)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        body: DefaultTabController(
      length: 3,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
          SliverAppBar(
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

                        _tween.begin = 80;
                        _animationController.reset();
                        _tween.end = 48;
                        _animationController.forward();
                      } else {
                        _tween.begin = 48;
                        _animationController.reset();
                        _tween.end = 80;
                        _animationController.forward();
                      }
                    });
                  },
                )
            ],
            forceElevated: innerBoxIsScrolled,
            floating: true,
            pinned: true,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(_animation.value),
              child: Column(
                children: <Widget>[
                  TabBar(
                    isScrollable: widthOf(context) > 500,
                    indicatorColor: getPrimary(),
                    labelColor: Theme.of(context).textTheme.title.color,
                    tabs: [
                      Tab(text: Strings.get("assignments")),
                      Tab(text: Strings.get("statistics")),
                      Tab(text: Strings.get("about")),
                    ],
                  ),
                  CrossFade(
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
                  )
                ],
              ),
            ),
            textTheme: Theme.of(context).textTheme,
            iconTheme: Theme.of(context).iconTheme,
          ),
        ],
        body: TabBarView(
          children: [
            MarksList(_course, whatIfMode, updateCourse),
            StatisticsList(_course, whatIfMode),
            AboutTab(_course),
          ],
        ),
      ),
    ));
  }
}