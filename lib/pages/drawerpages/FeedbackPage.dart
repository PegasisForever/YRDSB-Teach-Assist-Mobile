import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ta/network/network.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';
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
          Builder(
            builder: (context) {
              return _isLoading
                  ? Stack(
                      alignment: Alignment(0, 0),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: CircularProgressIndicator(
                            backgroundColor: Color(0x66FFFFFF),
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.onPrimary),
                          ),
                        )
                      ],
                    )
                  : IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () async {
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
                          _isLoading = true;
                        });

                        try {
                          await sendFeedBack(_contactInfoController.text, _feedbackController.text);
                          setState(() {
                            _isLoading = false;
                          });
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(Strings.get("thank_you_for_giving_feedback")),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text(Strings.get("ok").toUpperCase()),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                  contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
                                );
                              });
                          Navigator.pop(context);
                        } catch (e) {
                          _handleError(e, context);
                        } finally {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                    );
            },
          )
        ],
        textTheme: Theme.of(context).textTheme,
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16,4,16,16),
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
                    keyboardAppearance:
                        isLightMode(context: context) ? Brightness.light : Brightness.dark,
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
        ),
      ),
    );
  }

  _handleError(Exception e, BuildContext context) {
    if (e is SocketException) {
      if (e.message == "Connection failed" || e.osError.message == "Connection refused") {
        showSnackBar(context, Strings.get("connection_failed"));
      } else {
        showSnackBar(
            context, Strings.get("error") + (e.message != "" ? e.message : e.osError.message));
      }
    } else if (e is HttpException) {
      switch (e.message) {
        case "500":
          {
            showSnackBar(context, Strings.get("server_internal_error"));
            break;
          }
        default:
          {
            showSnackBar(context, Strings.get("error_code") + e.message);
          }
      }
    } else {
      showSnackBar(context, Strings.get("error") + e.toString());
    }
  }
}
