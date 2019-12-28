import 'package:flutter/material.dart';
import 'package:ta/res/Strings.dart';

import 'Section.dart';

class AnnouncementSection extends SectionCandidate {
  @override
  bool shouldDisplay() {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Section(
      title: Strings.get("announcement"),
      buttonText: Strings.get("dismiss"),
      onTap: (){

      },
      card: Card(
        child: Placeholder(fallbackHeight: 200),
      ),
    );
  }
}
