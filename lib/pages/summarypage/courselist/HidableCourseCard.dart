import 'package:flutter/material.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/pages/summarypage/CourseCard.dart';
import 'package:ta/widgets/CrossFade.dart';
import 'package:ta/widgets/WithContextMenu.dart';

class HidableCourseCard extends StatelessWidget {
  final bool isShow;
  final String menuText;
  final VoidCallback onMenuTap;
  final Course course;

  HidableCourseCard({this.isShow, this.menuText, this.onMenuTap, this.course})
      : super(key: Key(course.hashCode.toString()));

  @override
  Widget build(BuildContext context) {
    return CrossFade(
      showFirst: isShow,
      firstChild: WithContextMenu(
        menuItems: {
          menuText: () {
            onMenuTap();
            Navigator.pop(context);
          },
        },
        child: CourseCard(
          showPadding: false,
          course: course,
          onTap: () {
            Navigator.pushNamed(
              context,
              "/detail",
              arguments: [course],
            );
          },
        ),
      ),
    );
  }
}
