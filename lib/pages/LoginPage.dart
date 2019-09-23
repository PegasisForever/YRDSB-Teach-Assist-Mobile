import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ta/model/User.dart';
import 'package:ta/network/network.dart';
import 'package:ta/res/Strings.dart';
import 'package:ta/widgets/EditText.dart';

import '../res/Themes.dart';
import '../tools.dart';

class LoginPage extends StatefulWidget {
  LoginPage() : super();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _studentNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  ErrorText _studentNumberErrorText = ErrorText(null);
  ErrorText _passwordErrorText = ErrorText(null);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(new LifecycleEventHandler(() {
      adjustNavColor(context);
      return;
    }));
  }

  @override
  Widget build(BuildContext context) {
    adjustNavColor(context);

    return Scaffold(
      body: Builder(
        builder: (BuildContext context){
          return ScrollConfiguration(
            behavior: DisableOverScroll(),
            child: Center(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 24),
                children: <Widget>[
                  SizedBox(
                    height: 28,
                  ),
                  Theme.of(context).brightness == Brightness.light
                      ? Image.asset(
                    "assets/images/yrdsb_logo.png",
                    height: 80,
                  )
                      : Image.asset(
                    "assets/images/yrdsb_logo_dark.png",
                    height: 80,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Image.asset(
                    "assets/images/ta_logo.png",
                    height: 40,
                  ),
                  SizedBox(
                    height: 120,
                  ),
                  Center(
                    widthFactor: 0,
                    child: Text(Strings.get("login_your_account", context),
                        style: Theme.of(context).textTheme.title),
                  ),
                  SizedBox(height: 18),
                  EditText(
                    controller: _studentNumberController,
                    maxWidth: 400,
                    hint: Strings.get("student_number"),
                    errorText: _studentNumberErrorText,
                    icon: Icons.account_circle,
                    inputType: TextInputType.numberWithOptions(
                        signed: false, decimal: false),
                  ),
                  SizedBox(height: 12),
                  EditText(
                    controller: _passwordController,
                    maxWidth: 400,
                    hint: Strings.get("password"),
                    errorText: _passwordErrorText,
                    icon: Icons.lock,
                    isPassword: true,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: ButtonBar(
                      children: <Widget>[
                        _isLoading
                            ? CircularProgressIndicator()
                            : Placeholder(
                          fallbackWidth: 0,
                          fallbackHeight: 0,
                        ),
                        RaisedButton(
                          color: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).cardColor,
                          child: Text(Strings.get("login").toUpperCase()),
                          onPressed: !_isLoading
                              ? () async {

                            if (_studentNumberController.text == "") {
                              setState(() {
                                _studentNumberErrorText.text = Strings.get(
                                    "plz_fill_in_ur_student_number");
                              });
                              return;
                            }
                            if (_passwordController.text == "") {
                              setState(() {
                                _passwordErrorText.text =
                                    Strings.get("plz_fill_in_ur_pwd");
                              });
                              return;
                            }

                            setState(() {
                              _isLoading = true;
                            });

                            var user=User(_studentNumberController.text,
                                _passwordController.text, true);

                            try{
                              var res=await regi(user);
                              addUser(user);
                              setCurrentUser(user);
                              Navigator.pushReplacementNamed(context, "/");
                            }catch(e){
                              _handleError(e,context);
                            }
                            setState(() {
                              _isLoading = false;
                            });
                          }
                              : null,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          );
        },
      ));
  }


  _handleError(Exception e,BuildContext context){
    if (e is SocketException) {
      if (e.message == "Connection failed") {
        showSnackBar(context, Strings.get("connection_failed"));
      } else {
        showSnackBar(context, e.message);
      }
    } else if (e is HttpException) {
      switch(e.message){
        case "401":{
          setState(() {
            _passwordErrorText.text=Strings.get("student_number_or_password_incorrect");
          });
          break;
        }
        case "500":{
          showSnackBar(context, Strings.get("server_internal_error"));
          break;
        }
        default:{
          showSnackBar(context, Strings.get("error_code")+e.message);
        }
      }
    }else{
      showSnackBar(context, e.toString());
    }
  }
}
