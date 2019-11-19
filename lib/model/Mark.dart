import 'dart:convert';

import 'package:ta/dataStore.dart';
import 'package:ta/prasers/ParsersCollection.dart';
import 'package:ta/res/Strings.dart';

import '../tools.dart';

class SmallMark{
  bool available;
  bool finished;
  double total;
  double get;
  double weight;

  get percent{
    if (!available){
      return "N/A";
    }else{
      return "${getRoundString((get/total*100),2)}%";
    }
  }

  SmallMark.unavailable(){
    this.available=false;
  }

  SmallMark.blank();
}

class Assignment{
  SmallMark KU;
  SmallMark T;
  SmallMark C;
  SmallMark A;
  SmallMark O;
  SmallMark F;
  String name;
  String feedback;
  DateTime time;

  Assignment(this.KU,this.T,this.C,this.A,this.O,this.F,this.name,String date){
    if (date != null) {
      this.time = DateTime.parse(date);
    }
  }

  Assignment.blank();

  get displayName{
    if (name.isNotEmpty){
      return name;
    }else{
      return Strings.get("untitled_assignment");
    }
  }

  String getAverage(WeightTable weights){
    var get=0.0;
    var total=0.0;

    if (KU.available && KU.finished){
      get+=KU.get/KU.total*weights.KU.CW;
      total+=weights.KU.CW;
    }
    if (T.available && T.finished){
      get+=T.get/T.total*weights.T.CW;
      total+=weights.T.CW;
    }
    if (C.available && C.finished){
      get+=C.get/C.total*weights.C.CW;
      total+=weights.C.CW;
    }
    if (A.available && A.finished){
      get+=A.get/A.total*weights.A.CW;
      total+=weights.A.CW;
    }
    if (O.available && O.finished){
      get+=O.get/O.total*weights.O.CW;
      total+=weights.O.CW;
    }

    if(total>0){
      var avg=get/total;
      return getRoundString(avg*100,1)+"%";
    }else{
      return null;
    }
  }
}

class Weight{
  double W;
  double CW;
  double SA;

  Weight(this.W,this.CW,this.SA);

  Weight.f(this.CW,this.SA);

  Weight.blank();
}

class WeightTable{
  Weight KU;
  Weight T;
  Weight C;
  Weight A;
  Weight O;
  Weight F;

  WeightTable.blank();
}


class Course{
  List<Assignment> assignments;
  WeightTable weightTable;
  DateTime startTime;
  DateTime endTime;
  String name;
  String code;
  String block;
  String room;
  double overallMark;
  bool cached;

  String get displayName{
    if (name!=null){
      return name;
    }else if(code !=null){
      return code;
    }else{
      return Strings.get("unnamed_course");
    }
  }

  Course.blank();
}

List<Course> getCourseListOf(String number){
  var json=jsonDecode(prefs.getString("$number-mark"));
  return parseCourseList(json);
}

saveCourseListOf(String number,Map<String, dynamic> json){
  prefs.setString("$number-mark", jsonEncode(json));
}