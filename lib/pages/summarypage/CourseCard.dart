import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/res/CustomIcons.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';
import 'package:ta/widgets/LinearProgressIndicator.dart' as LPI;
import 'package:ta/widgets/TapTooltip.dart';

class CourseCard extends StatelessWidget {
  final Function onTap;
  final Course course;
  final bool showIcons;
  final bool showAnimations;
  final bool showPadding;

  CourseCard({this.onTap, this.course, this.showIcons = true, this.showAnimations = true, this.showPadding = true})
      : super(key: Key(course.displayName));

  @override
  Widget build(BuildContext context) {
    var infoStr = [];
    if (course.block != null) {
      infoStr.add(sprintf(Strings.get("period_number"), [course.block]));
    }
    if (course.room != null) {
      infoStr.add(sprintf(Strings.get("room_number"), [course.room]));
    }
    return Padding(
      padding: showPadding ? const EdgeInsets.fromLTRB(8, 8, 8, 0) : EdgeInsets.zero,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: course.displayName + " ",
                      style: Theme.of(context).textTheme.title,
                    ),
                    if (course.overallMark != null && course.overallMark >= 90 && showIcons)
                      (course.overallMark < 99)
                          ? WidgetSpan(
                              child: TapTooltip(
                              message: Strings.get("fire_info"),
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              child: Icon(
                                CustomIcons.fire,
                                color: Colors.orange,
                                size: 20,
                              ),
                            ))
                          : WidgetSpan(
                              child: TapTooltip(
                              message: Strings.get("diamond_info"),
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              child: Icon(
                                CustomIcons.diamond,
                                color: Colors.lightBlue,
                                size: 17,
                              ),
                            )),
                    if (course.cached && showIcons)
                      WidgetSpan(
                          child: TapTooltip(
                            message: Strings.get("cached_info"),
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: Container(
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(4)),
                                ),
                                child: Text(
                                  Strings.get("cached"),
                                  style: TextStyle(color: getGrey(100, context: context)),
                                ),
                              ),
                            ),
                          )
                      ),
                  ]),
                ),
                SizedBox(height: 4),
                if (infoStr.length > 0) Text(infoStr.join("  -  "), style: Theme.of(context).textTheme.subhead),
                SizedBox(height: 16),
                course.overallMark != null
                    ? LPI.LinearProgressIndicator(
                        lineHeight: 20.0,
                        animationDuration: showAnimations ? 700 : 0,
                        value1: course.overallMark / 100,
                        center: Text(num2Str(course.overallMark) + "%", style: TextStyle(color: Colors.black)),
                        value1Color: Theme.of(context).colorScheme.secondary,
                      )
                    : LPI.LinearProgressIndicator(
                        lineHeight: 20.0,
                        value1: 0,
                        center: Text(Strings.get("marks_unavailable"), style: TextStyle(color: Colors.black)),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
