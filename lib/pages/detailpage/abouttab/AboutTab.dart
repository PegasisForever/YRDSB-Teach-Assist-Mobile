import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';

class AboutTab extends StatefulWidget {
  AboutTab(this._course);

  final Course _course;

  @override
  _AboutTabState createState() => _AboutTabState(_course);
}

class _AboutTabState extends State<AboutTab> with AutomaticKeepAliveClientMixin {
  final Course _course;

  _AboutTabState(this._course);

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var courseInfoText =
        Strings.get("course_about_name:") + testBlank(_course.name) + "\n";
    courseInfoText +=
        Strings.get("course_about_code:") + testBlank(_course.code) + "\n";
    courseInfoText +=
        Strings.get("course_about_period:") + testBlank(_course.block) + "\n";
    courseInfoText +=
        Strings.get("course_about_room:") + testBlank(_course.room) + "\n";
    courseInfoText += Strings.get("course_about_starttime:") +
        testBlank(DateFormat("yyyy-MM-dd").format(_course.startTime)) +
        "\n";
    courseInfoText += Strings.get("course_about_endtime:") +
        testBlank(DateFormat("yyyy-MM-dd").format(_course.endTime));

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            _course.displayName,
            style: Theme.of(context).textTheme.title,
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16,12,16,16),
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
