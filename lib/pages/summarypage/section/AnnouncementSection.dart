import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:ta/plugins/dataStore.dart';
import 'package:ta/pages/drawerpages/openCustomTab.dart';
import 'package:ta/pages/summarypage/section/Section.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/widgets/CrossFade.dart';

class AnnouncementSection extends SectionCandidate {
  @override
  _AnnouncementSectionState createState() => _AnnouncementSectionState();

  @override
  bool shouldDisplay() {
    var announcement = prefs.getString("announcement");
    if (announcement == "" ||
        announcement == null ||
        prefs.getBool("announcement-${announcement.hashCode}") == false) {
      return false;
    } else {
      return true;
    }
  }
}

class _AnnouncementSectionState extends State<AnnouncementSection> {
  bool isDismissed = false;

  @override
  Widget build(BuildContext context) {
    var announcement = prefs.getString("announcement");

    return CrossFade(
      firstChild: Section(
        title: Strings.get("announcement"),
        buttonText: Strings.get("dismiss"),
        buttonIcon: Icons.close,
        onTap: () {
          prefs.setBool("announcement-${announcement.hashCode}", false);
          setState(() {
            isDismissed = true;
          });
        },
        card: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: MarkdownBody(
              fitContent: false,
              data: announcement,
              onTapLink: (url) {
                openCustomTab(context, url);
              },
            ),
          ),
        ),
      ),
      secondChild: Container(),
      showFirst: !isDismissed,
    );
  }
}
