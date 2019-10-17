import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ta/model/TimeLineUpdateModels.dart';
import 'package:ta/model/User.dart';
import 'package:ta/tools.dart';

class TimelineTab extends StatefulWidget{
  @override
  _TimelineTabState createState() => _TimelineTabState();
}

class _TimelineTabState extends State<TimelineTab> {
  @override
  Widget build(BuildContext context) {
    var timeline=getTimelineOf(currentUser.number);
    return ListView(
      padding: EdgeInsets.only(bottom: 8+getBottomPadding(context)),
      children: _getTimelineCards(timeline),
    );
  }


  List<Widget> _getTimelineCards(List<TAUpdate> timeline){
    var list = List<Widget>();

    timeline.reversed.forEach((update){
      if (update is AssignmentAdded){
        list.add(Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: _cardFromAssignmentAdded(update),
        ));
      }

    });

    return list;
  }


  Card _cardFromAssignmentAdded(AssignmentAdded update){
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.note_add,size: 32,color: Colors.green,),
                SizedBox(width: 8,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(DateFormat("EEE, MMM d").format(update.time)),
                    Text(update.courseName,style: Theme.of(context).textTheme.title),
                  ],
                )
              ],
            ),
            SizedBox(height: 8),
            Text("New assignment: "+update.assignmentName,style: TextStyle(fontSize: 16)),
            update.overallBefore!=null?Padding(
              padding: EdgeInsets.only(top: 16,bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(getRoundString(update.overallBefore, 1)+"%",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                  Icon(Icons.arrow_forward,size: 32),
                  Text(getRoundString(update.overallAfter, 1)+"%",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold)),
                ],
              ),
            ):SizedBox(width: 0,height: 0)
          ],
        ),
      ),
    );
  }
}