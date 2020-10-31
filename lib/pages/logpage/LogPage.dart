import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:ta/log.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/tools.dart';

class LogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.get("logs")),
        elevation: 4,
        textTheme: Theme.of(context).textTheme,
        iconTheme: Theme.of(context).iconTheme,
        actions: [
          IconButton(
            icon: Icon(Icons.copy),
            onPressed: () async {
              await FlutterClipboard.copy("your text to copy");
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(Strings.get("logs_copied")),
                  actions: [
                    FlatButton(
                      child: Text(Strings.get("ok")),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.only(
          top: 8,
          bottom: getBottomPadding(context),
        ),
        itemCount: logBuffer.length,
        itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(logBuffer[i]),
        ),
        separatorBuilder: (context, i) => Divider(),
      ),
    );
  }
}
