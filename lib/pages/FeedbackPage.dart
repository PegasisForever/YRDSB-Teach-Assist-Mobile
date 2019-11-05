import 'package:flutter/material.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/widgets/BetterState.dart';
import 'package:ta/widgets/EditText.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends BetterState<FeedbackPage> {
  final _contactInfoController = TextEditingController();
  final _feedbackController = TextEditingController();
  final _contactInfoFocusNode = FocusNode();
  final _feedbackFocusNode = FocusNode();
  var _contactErrorText = ErrorText(null);
  var _feedbackValid = true;
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.get("send_feedback")),
        actions: <Widget>[
          _isLoading
              ? Stack(
                  alignment: Alignment(0, 0),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: CircularProgressIndicator(
                        backgroundColor: Color(0x66FFFFFF),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.onPrimary),
                      ),
                    )
                  ],
                )
              : IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_contactInfoController.text.isEmpty) {
                      setState(() {
                        _contactErrorText.text = Strings.get("plz_fill_in_ur_contact_info");
                      });
                      return;
                    }
                    if (_feedbackController.text.isEmpty) {
                      setState(() {
                        _feedbackValid = false;
                      });
                      return;
                    }

                    setState(() {
                      _isLoading=true;
                    });
                  },
                )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            EditText(
              textInputAction: TextInputAction.next,
              nextFocusNode: _feedbackFocusNode,
              focusNode: _contactInfoFocusNode,
              controller: _contactInfoController,
              hint: Strings.get("contact_info"),
              errorText: _contactErrorText,
              icon: Icons.contact_mail,
            ),
            SizedBox(height: 12),
            Expanded(
              child: TextField(
                expands: true,
                maxLines: null,
                focusNode: _feedbackFocusNode,
                controller: _feedbackController,
                textAlignVertical: TextAlignVertical.top,
                onChanged: (s) {
                  if (!_feedbackValid) {
                    setState(() {
                      _feedbackValid = true;
                    });
                  }
                },
                decoration: InputDecoration(
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                    errorText: _feedbackValid ? null : Strings.get("plz_fill_in_ur_feedback"),
                    labelText: Strings.get("feedback")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
