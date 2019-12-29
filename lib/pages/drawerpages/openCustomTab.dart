import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

void openCustomTab(BuildContext context, String url) async {
  await launch(
    url,
    option: CustomTabsOption(
      toolbarColor: Theme.of(context).canvasColor,
      enableDefaultShare: false,
      enableUrlBarHiding: true,
      showPageTitle: true,
      animation: new CustomTabsAnimation.fade(),
      extraCustomTabs: <String>[
        'org.mozilla.firefox',
        'com.microsoft.emmx',
      ],
    ),
  );
}
