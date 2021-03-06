import 'package:flutter/material.dart';
import 'package:ta/pages/setuppage/FinishedPage.dart';
import 'package:ta/pages/setuppage/SetColor.dart';
import 'package:ta/pages/setuppage/SetShowMoreDecimalPlaces.dart';
import 'package:ta/pages/setuppage/SetShowRecentUpdate.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';
import 'package:ta/widgets/BetterState.dart';

class SetupPage extends StatefulWidget {
  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends BetterState<SetupPage>
    with SingleTickerProviderStateMixin {
  PageController pageController = PageController();
  double percent = 0.01;
  List<Widget> pages;

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (pages == null)
      pages = <Widget>[
        _PageWrapper(
          child: SetColor(),
          goNext: () {
            pageController.animateToPage(
              1,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
            );
          },
          isLast: false,
        ),
        _PageWrapper(
          child: SetShowRecentUpdate(),
          goPrevious: () {
            pageController.animateToPage(
              0,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
            );
          },
          goNext: () {
            pageController.animateToPage(
              2,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
            );
          },
          isLast: false,
        ),
        _PageWrapper(
          child: SetShowMoreDecimalPlaces(),
          goPrevious: () {
            pageController.animateToPage(
              1,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
            );
          },
          goNext: () {
            pageController.animateToPage(
              3,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
            );
          },
          isLast: false,
        ),
        _PageWrapper(
          child: FinishedPage(),
          goPrevious: () {
            pageController.animateToPage(
              1,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
            );
          },
          goNext: () {
            Navigator.pop(context);
          },
          isLast: true,
        ),
      ];

    return Scaffold(
      appBar: AppBar(
        title: LinearProgressIndicator(
          value: percent,
          backgroundColor: Colors.black26,
          valueColor: AlwaysStoppedAnimation<Color>(getPrimary()),
        ),
        textTheme: Theme.of(context).textTheme,
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: NotificationListener<ScrollUpdateNotification>(
        child: PageView(
          controller: pageController,
          children: pages,
        ),
        onNotification: (noti) {
          setState(() {
            percent = (noti.metrics.pixels / getScreenWidth(context)) /
                    (pages.length - 1) *
                    0.99 +
                0.01;
          });
          return true;
        },
      ),
    );
  }
}

class _PageWrapper extends StatelessWidget {
  final Widget child;
  final VoidCallback goPrevious;
  final VoidCallback goNext;
  final bool isLast;

  _PageWrapper({this.child, this.goPrevious, this.goNext, this.isLast});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Center(
            child: child,
          ),
        ),
        Flexible(
          flex: 0,
          child: Padding(
            padding: EdgeInsets.only(
                top: 24,
                left: 24,
                right: 24,
                bottom: 24 + getBottomPadding(context)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                goPrevious == null
                    ? Container()
                    : FlatButton(
                        child: Text(Strings.get("pervious")),
                        onPressed: goPrevious,
                      ),
                goNext == null
                    ? Container()
                    : RaisedButton(
                        child: Text(
                            isLast ? Strings.get("done") : Strings.get("next")),
                        color: Theme.of(context).colorScheme.primary,
                        textColor: Colors.white,
                        onPressed: goNext,
                      )
              ],
            ),
          ),
        )
      ],
    );
  }
}
