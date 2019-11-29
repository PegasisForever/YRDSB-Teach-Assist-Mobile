import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:ta/tools.dart';

void openMoodlePage(BuildContext context) async {
  await launch(
    "https://moodle2.yrdsb.ca/",
    option: new CustomTabsOption(
      toolbarColor: primaryColorOf(context),
      enableDefaultShare: false,
      enableUrlBarHiding: true,
      showPageTitle: true,
      animation: new CustomTabsAnimation.slideIn(),
      extraCustomTabs: <String>[
        'org.mozilla.firefox',
        'com.microsoft.emmx',
      ],
    ),
  );
}
