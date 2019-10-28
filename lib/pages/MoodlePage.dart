import 'package:flutter/material.dart';
import 'package:ta/res/Strings.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MoodlePage extends StatefulWidget{
  @override
  _MoodlePageState createState() => _MoodlePageState();
}

class _MoodlePageState extends State<MoodlePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.get("moodle")),
      ),
      body: WebView(
        initialUrl: 'https://moodle2.yrdsb.ca/login/index.php',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}