import 'dart:math';

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
import 'package:ta/widgets/AutoHideAppBarListWrapper.dart';
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
  double appBarOffsetY = 0;
  double appBarElevation = 0;
  final markListKey = GlobalKey<AutoHideAppBarListWrapperState>();
  final statisticsListKey = GlobalKey<AutoHideAppBarListWrapperState>();
  final aboutKey = GlobalKey<AutoHideAppBarListWrapperState>();
  int currentPage = 0;

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
      child: NotificationListener<ScrollUpdateNotification>(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + _animation.value,
              ),
              child: TabBarView(
                children: [
                  AutoHideAppBarListWrapper(
                    key: markListKey,
                    onAppBarSnapChanged: onAppBarSnapChanged,
                    child: MarksList(
                      course: _course,
                      whatIfMode: whatIfMode,
                      updateCourse: updateCourse,
                    ),
                  ),
                  AutoHideAppBarListWrapper(
                    key: statisticsListKey,
                    onAppBarSnapChanged: onAppBarSnapChanged,
                    child: StatisticsList(
                      course: _course,
                      whatIfMode: whatIfMode,
                    ),
                  ),
                  AutoHideAppBarListWrapper(
                    key: aboutKey,
                    onAppBarSnapChanged: onAppBarSnapChanged,
                    child: AboutTab(
                      course: _course,
                    ),
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: Offset(0, appBarOffsetY),
              child: Material(
                elevation: appBarElevation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Opacity(
                      opacity: 1 + appBarOffsetY / 56.0,
                      child: AppBar(
                        title: Text(
                          _course.displayName,
                          overflow: TextOverflow.fade,
                        ),
                        actions: <Widget>[
                          if (_course.overallMark != null)
                            IconButton(
                              icon: Icon(whatIfMode
                                  ? CustomIcons.lightbulb_filled
                                  : Icons.lightbulb_outline),
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
                        textTheme: Theme.of(context).textTheme,
                        iconTheme: Theme.of(context).iconTheme,
                      ),
                    ),
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
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        onNotification: (noti) {
          var markOffset = markListKey.currentState?.appBarOffsetY ?? 0.0;
          var markElevation = markListKey.currentState?.appBarElevation ?? 0.0;
          var statisticsOffset = statisticsListKey.currentState?.appBarOffsetY ?? 0.0;
          var statisticsElevation = statisticsListKey.currentState?.appBarElevation ?? 0.0;
          var aboutOffset = aboutKey.currentState?.appBarOffsetY ?? 0.0;
          var aboutElevation = aboutKey.currentState?.appBarElevation ?? 0.0;

          if (!(noti.metrics is PageMetrics)) {
            // Listview scroll
            setState(() {
              if (currentPage == 0) {
                appBarOffsetY = markOffset;
                appBarElevation = markElevation;
              } else if (currentPage == 1) {
                appBarOffsetY = statisticsOffset;
                appBarElevation = statisticsElevation;
              } else if (currentPage == 2) {
                appBarOffsetY = aboutOffset;
                appBarElevation = aboutElevation;
              }
            });
          } else {
            // Tabview scroll
            var percent = noti.metrics.pixels / getScreenWidth(context);
            currentPage = percent.round();

            if (percent <= 1) {
              // Scroll between 1st & 2nd tab
              setState(() {
                appBarOffsetY = (1 - percent) * markOffset + percent * statisticsOffset;
                if (appBarOffsetY < -56) {
                  appBarOffsetY = -56;
                } else if (appBarOffsetY > 0) {
                  appBarOffsetY = 0;
                }

                appBarElevation = (1 - percent) * markElevation + percent * statisticsElevation;
                if (appBarElevation > 4) {
                  appBarElevation = 4;
                } else if (appBarElevation < 0) {
                  appBarElevation = 0;
                }
              });
            } else if (percent <= 2) {
              // Scroll between 2nd & 3rd tab
              setState(() {
                appBarOffsetY =
                    (1 - (percent - 1)) * statisticsOffset + (percent - 1) * aboutOffset;
                if (appBarOffsetY < -56) {
                  appBarOffsetY = -56;
                } else if (appBarOffsetY > 0) {
                  appBarOffsetY = 0;
                }

                appBarElevation =
                    (1 - (percent - 1)) * statisticsElevation + (percent - 1) * aboutElevation;
                if (appBarElevation > 4) {
                  appBarElevation = 4;
                } else if (appBarElevation < 0) {
                  appBarElevation = 0;
                }
              });
            }
          }
          return true;
        },
      ),
    ));
  }


  void onAppBarSnapChanged(double offset,double elevation){
    setState(() {
      appBarOffsetY=offset;
      appBarElevation=elevation;
    });
  }
}
