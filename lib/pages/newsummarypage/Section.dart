import 'package:flutter/material.dart';

class Section extends StatelessWidget {
  final Widget card;
  final String title;
  final String buttonText;
  final VoidCallback onTap;

  Section({this.card, this.title, this.buttonText,this.onTap});

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
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4,4,0,4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(buttonText),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward,
                      size: 20,)
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
