import 'package:flutter/material.dart';

class SectionsResult {
  List<Widget> sectionWidgets;
  String text;
}

SectionsResult getSectionWidgets(List<SectionCandidate> sections) {
  var list = <Widget>[];
  sections.forEach((section) {
    var response = section.getSectionResponse();
    if (response.shouldDisplay) {
      list.add(section);
    }
  });

  return SectionsResult()..sectionWidgets = list;
}

class WelcomeText {
  int priority = 0;
  String text;
}

class SectionResponse {
  bool shouldDisplay;
  WelcomeText welcomeText = WelcomeText();
}

abstract class SectionCandidate extends StatelessWidget {
  SectionResponse getSectionResponse();
}

class Section extends StatelessWidget {
  final Widget card;
  final String title;
  final String buttonText;
  final VoidCallback onTap;

  Section({this.card, this.title, this.buttonText, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(fontSize: 22),
              ),
              if (onTap != null)
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 4, 0, 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(buttonText),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                  onTap: onTap,
                ),
            ],
          ),
        ),
        card,
      ],
    );
  }
}
