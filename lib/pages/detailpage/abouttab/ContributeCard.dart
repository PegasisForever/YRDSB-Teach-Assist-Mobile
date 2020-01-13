
import 'package:flutter/material.dart';
import 'package:ta/widgets/EditText.dart';

import 'package:ta/tools.dart';

class ContributeCard extends StatefulWidget {
  final String courseCode;

  ContributeCard({@required this.courseCode});

  @override
  _ContributeCardState createState() => _ContributeCardState();
}

class _ContributeCardState extends State<ContributeCard> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final showSubmitButton = controller.text != "";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 4, top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Contribute",
                style: Theme.of(context).textTheme.title,
              ),
              AnimatedOpacity(
                opacity: showSubmitButton ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                child: FlatButton.icon(
                  onPressed: showSubmitButton ? () {} : null,
                  icon: Icon(Icons.send),
                  label: Text("Submit"),
                  textColor: getPrimary(),
                  padding: EdgeInsets.zero,
                ),
              )
            ],
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              children: <Widget>[
                Text(
                    "Contributting to teach assist by providing missing course name. Your contribution will be reviewed by the developer and then be visible to all students."),
                SizedBox(
                  height: 12,
                ),
                EditText(
                  controller: controller,
                  hint: "Course Name",
                  errorText: ErrorText(null),
                  onChanged: (str){
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
