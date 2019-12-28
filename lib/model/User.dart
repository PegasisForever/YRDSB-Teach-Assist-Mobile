import 'dart:convert';

import 'package:ta/dataStore.dart';

List<User> userList = [];
User currentUser;

initUser() {
  var usersJSON = prefs.getString("users") ?? "[]";
  var users = jsonDecode(usersJSON);

  for (var user in users) {
    userList.add(User.fromJson(user));
  }

  var currentUserJSON = prefs.getString("currentuser");
  if (currentUserJSON != null) {
    currentUser = User.fromJson(jsonDecode(currentUserJSON));
  } else if (userList.length > 0) {
    setCurrentUser(userList[0]);
  }
}

setCurrentUser(User user) {
  currentUser = user;
  if (currentUser != null) {
    prefs.setString("currentuser", jsonEncode(user));
  } else {
    prefs.setString("currentuser", null);
  }
}

addUser(User newUser) {
  userList.forEach((user) {
    if (user.number == newUser.number) {
      return;
    }
  });
  userList.add(newUser);
  prefs.setString("users", jsonEncode(userList));
}

editUser(User newUser, String oldNumber) {
  var isCurrentUser = currentUser.number == oldNumber;
  removeUser(oldNumber);
  addUser(newUser);

  if (isCurrentUser) {
    setCurrentUser(newUser);
  }
}

removeUser(String number) {
  userList.removeWhere((user) {
    return user.number == number;
  });

  if (currentUser.number == number) {
    if (userList.length > 0) {
      setCurrentUser(userList[0]);
    } else {
      setCurrentUser(null);
    }
  }
  prefs.setString("users", jsonEncode(userList));
}

reorderUser(int oldIndex, int newIndex) {
  var user = userList.removeAt(oldIndex);
  userList.insert(newIndex, user);
  prefs.setString("users", jsonEncode(userList));
}

class User {
  String number;
  String password;
  String displayName;
  bool receiveNotification;

  User(this.number, this.password, this.receiveNotification, {this.displayName = ""});

  User.blank() {
    number = "";
    password = "";
    displayName = "";
    receiveNotification = true;
  }

  User.fromJson(Map<String, dynamic> json)
      : number = json["number"],
        password = json["password"],
        displayName = json["displayname"],
        receiveNotification = json["receive"];

  Map<String, dynamic> toJson() => {
        "number": number,
        "password": password,
        "displayname": displayName,
        "receive": receiveNotification
      };

  User copy() {
    return User.fromJson(this.toJson());
  }

  String getName() {
    if (displayName != "") {
      return displayName;
    } else {
      return number;
    }
  }
}
