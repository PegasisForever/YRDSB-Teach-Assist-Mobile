import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

void openDonatePage(BuildContext context) async {
  await launch(
    "https://www.patreon.com/yrdsbta",
    option: new CustomTabsOption(
      toolbarColor: Theme.of(context).primaryColor,
      enableDefaultShare: true,
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
