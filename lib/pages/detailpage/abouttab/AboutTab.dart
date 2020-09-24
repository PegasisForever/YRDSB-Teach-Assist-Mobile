import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';

class AboutTab extends StatefulWidget {
  AboutTab({this.course});

  final Course course;

  @override
  AboutTabState createState() => AboutTabState();
}

class AboutTabState extends State<AboutTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    var course = widget.course;

    super.build(context);
    var sidePadding = (getScreenWidth(context) - 500) / 2;
    var courseInfoText = Strings.get("course_about_name:") + testBlank(course.name) + "\n";
    courseInfoText += Strings.get("course_about_code:") + testBlank(course.code) + "\n";
    courseInfoText += Strings.get("course_about_period:") + testBlank(course.block) + "\n";
    courseInfoText += Strings.get("course_about_room:") + testBlank(course.room) + "\n";
    courseInfoText += Strings.get("course_about_starttime:") +
        (course.startTime != null
            ? DateFormat("yyyy-MM-dd").format(course.startTime)
            : Strings.get("unknown")) +
        "\n";
    courseInfoText += Strings.get("course_about_endtime:") +
        (course.endTime != null
            ? DateFormat("yyyy-MM-dd").format(course.endTime)
            : Strings.get("unknown"));

    return ListView(
      padding: EdgeInsets.only(
        top: 56 + 16.0,
        left: max(sidePadding, 14),
        right: max(sidePadding, 14),
        bottom: getBottomPadding(context),
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            course.displayName,
            style: Theme.of(context).textTheme.title,
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: SelectableText(
              courseInfoText,
              style: TextStyle(height: 1.7),
            ),
          ),
        )
      ],
    );
  }
}
