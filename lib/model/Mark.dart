import 'dart:convert';

import 'package:ta/dataStore.dart';

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

  SmallMark.fromJSON(Map<String, dynamic> json){
    if (json["available"]){
      this.available=true;
      this.finished=json["finished"];
      this.total=json["total"];
      this.get=json["get"];
      this.weight=json["weight"];
    }else{
      this.available=false;
    }
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
  DateTime dateTime;

  Assignment(this.KU,this.T,this.C,this.A,this.O,this.F,this.name,String date){
    this.dateTime=DateTime.parse(date);
  }

  Assignment.blank();

  Assignment.fromJSON(Map<String, dynamic> json){
    name=json["name"];
    if (json["time"]!=""){
      dateTime=DateTime.parse(json["time"]);
    }

    KU=SmallMark.fromJSON(json["KU"]);
    T=SmallMark.fromJSON(json["T"]);
    C=SmallMark.fromJSON(json["C"]);
    A=SmallMark.fromJSON(json["A"]);
    O=SmallMark.fromJSON(json["O"]);
    F=SmallMark.fromJSON(json["F"]);
  }
}

class Weight{
  double W;
  double CW;
  double SA;

  Weight(this.W,this.CW,this.SA);

  Weight.f(this.CW,this.SA);

  Weight.fromJSON(Map<String, dynamic> json){
    if (json.containsKey("W")){
      W=json["W"];
    }
    CW=json["CW"];
    SA=json["SA"];
  }

  Weight.blank();
}

class Weights{
  Weight KU;
  Weight T;
  Weight C;
  Weight A;
  Weight O;
  Weight F;

  Weights.fromJSON(Map<String, dynamic> json){
    KU=Weight.fromJSON(json["KU"]);
    T=Weight.fromJSON(json["T"]);
    C=Weight.fromJSON(json["C"]);
    A=Weight.fromJSON(json["A"]);
    O=Weight.fromJSON(json["O"]);
    F=Weight.fromJSON(json["F"]);
  }
}


class Course{
  List<Assignment> assignments=List<Assignment>();
  Weights weights;
  DateTime startTime;
  DateTime endTime;
  String name;
  String code;
  String block;
  String room;
  double overallMark;

  String get displayName{
    return this.name == "" ? this.code : this.name;
  }

  Course.fromJSON(Map<String, dynamic> json){
    startTime=DateTime.parse(json["start_time"]);
    endTime=DateTime.parse(json["end_time"]);
    name=json["name"];
    code=json["code"];
    block=json["block"];
    room=json["room"];
    overallMark=json["overall_mark"];

    Map<String, dynamic> markDetail=json["mark_detail"];
    if (markDetail.length==2){
      weights=Weights.fromJSON(markDetail["weights"]);
      for (Map<String, dynamic> assignment in markDetail["assignments"]){
        assignments.add(Assignment.fromJSON(assignment));
      }
    }
  }
}

List<Course> _getCourseList(List<dynamic> json){
  var courses=List<Course>();

  json.forEach((courseJSON){
    courses.add(Course.fromJSON(courseJSON));
  });

  return courses;
}

List<Course> getCourseListOf(String number){
  var json=jsonDecode(prefs.getString("$number-mark"));
  return _getCourseList(json);
}

saveCourseListOf(String number,String json){
  prefs.setString("$number-mark", json);
}