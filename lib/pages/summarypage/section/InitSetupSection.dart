import 'package:flutter/material.dart';
import 'package:ta/model/User.dart';
import 'package:ta/pages/summarypage/section/Section.dart';
import 'package:ta/plugins/dataStore.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/widgets/CrossFade.dart';
import 'package:ta/widgets/SmallIconButton.dart';
import 'package:ta/widgets/TipsCard.dart';

class InitSetupSection extends SectionCandidate {
  @override
  State<StatefulWidget> createState() => _InitSetupSectionState();

  @override
  bool shouldDisplay() {
    return !(prefs.getBool("init-setup-done-${currentUser.number}") ?? false);
  }
}

class _InitSetupSectionState extends State<InitSetupSection> {
  bool showTips = true;

  @override
  Widget build(BuildContext context) {
    return CrossFade(
      showFirst: showTips,
      firstChild: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: TipsCard(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          text: Strings.get("init_setup_text"),
          leading: Icon(Icons.info_outline),
          trailing: SmallIconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              Future.delayed(Duration(milliseconds: 300)).then((v){
                prefs.setBool("init-setup-done-${currentUser.number}", true);
              });
              Navigator.pushNamed(context, "/setup");
              setState(() {
                showTips = false;
              });
            },
          ),
        ),
      ),
    );
  }
}
