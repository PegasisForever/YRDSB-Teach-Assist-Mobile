import 'package:flutter/material.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';
import 'package:intl/intl.dart';

class AboutTab extends StatefulWidget {
  AboutTab(this._course);

  final Course _course;

  @override
  _AboutTabState createState() => _AboutTabState(_course);
}

class _AboutTabState extends State<AboutTab> {
  final Course _course;

  _AboutTabState(this._course);

  @override
  Widget build(BuildContext context) {
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
        SizedBox(height: 12,),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(Strings.get("course_about_name:")+testBlank(_course.name)),
                SizedBox(height: 6,),
                Text(Strings.get("course_about_code:")+testBlank(_course.code)),
                SizedBox(height: 6,),
                Text(Strings.get("course_about_period:")+testBlank(_course.block)),
                SizedBox(height: 6,),
                Text(Strings.get("course_about_room:")+testBlank(_course.room)),
                SizedBox(height: 6,),
                Text(Strings.get("course_about_starttime:")+testBlank(DateFormat("yyyy-MM-dd").format(_course.startTime))),
                SizedBox(height: 6,),
                Text(Strings.get("course_about_endtime:")+testBlank(DateFormat("yyyy-MM-dd").format(_course.endTime))),
              ],
            ),
          ),
        )
      ],
    );
  }
}
