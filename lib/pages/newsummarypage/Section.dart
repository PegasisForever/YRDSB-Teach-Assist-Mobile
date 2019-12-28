import 'package:flutter/material.dart';

List<Widget> getSectionWidgets(List<SectionCandidate> sections) {
  var list = <Widget>[];
  sections.forEach((section) {
    if (section.shouldDisplay()) {
      list.add(section);
    }
  });

  return list;
}


abstract class SectionCandidate extends StatefulWidget {
  bool shouldDisplay();
}

class Section extends StatelessWidget {
  final Widget card;
  final String title;
  final String buttonText;
  final IconData buttonIcon;
  final VoidCallback onTap;

  Section({this.card, this.title, this.buttonText,this.buttonIcon=Icons.arrow_forward, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 12),
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
                          buttonIcon,
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
        SizedBox(height: 12),
      ],
    );
  }
}
