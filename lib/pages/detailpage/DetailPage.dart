import 'package:flutter/material.dart';
import 'package:ta/model/Mark.dart';
import 'package:ta/pages/detailpage/MarksList.dart';
import 'package:ta/res/Strings.dart';

class DetailPage extends StatefulWidget{
  DetailPage(this.course);

  final Course course;

  @override
  _DetailPageState createState() => _DetailPageState(course);
}

class _DetailPageState extends State<DetailPage> {

  final Course _course;

  _DetailPageState(this._course);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.white),
          brightness: Brightness.dark,
          title: Text(_course.displayName,
            maxLines: 2,
            style: TextStyle(color: Colors.white),),
          bottom: TabBar(
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: Strings.get("assignments")),
              Tab(text: Strings.get("statics")),
              Tab(text: Strings.get("about")),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MarksList(_course),
            Icon(Icons.data_usage),
            Icon(Icons.info_outline),
          ],
        ),
      ),
    );
  }
}