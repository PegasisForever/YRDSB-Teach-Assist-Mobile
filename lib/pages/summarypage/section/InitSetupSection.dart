import 'package:flutter/material.dart';
import 'package:ta/model/User.dart';
import 'package:ta/pages/summarypage/section/Section.dart';
import 'package:ta/plugins/dataStore.dart';
import 'package:ta/res/Strings.dart';
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: TipsCard(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        text: Strings.get("init_setup_text"),
        leading: Icon(Icons.info_outline),
        trailing: SmallIconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () {
            Navigator.pushNamed(context, "/setup");
            setState(() {
//              showTips = false;
//              prefs.setBool("show_assi_edit_tip", false);
            });
          },
        ),
      ),
    );
  }
}
