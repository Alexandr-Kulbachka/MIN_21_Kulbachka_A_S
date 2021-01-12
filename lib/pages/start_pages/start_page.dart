import 'package:HelpHere/components/circled_button.dart';
import 'package:HelpHere/style/app_color_scheme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartPage extends StatefulWidget {
  StartPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            backgroundColor: AppColorScheme.backgroundColor,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColorScheme.appbarColor,
              centerTitle: true,
              title: Text(
                'Help Here',
                style: TextStyle(color: AppColorScheme.barTextColor),
              ),
            ),
            body: FutureBuilder(
              future: _initialization,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return _somethingWentWrong();
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  return Center(
                    child: Column(children: [
                      Spacer(
                        flex: 2,
                      ),
                      Container(
                        height: 60,
                        width: 200,
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: AppColorScheme.appbarColor,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: RaisedButton(
                          color: AppColorScheme.backgroundColor,
                          child: Text(
                            'New help request',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColorScheme.textColor,
                              fontSize: 20,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed('/new_help_request');
                          },
                        ),
                      ),
                      Spacer(),
                      Container(
                        height: 60,
                        width: 200,
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: AppColorScheme.appbarColor,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: RaisedButton(
                          color: AppColorScheme.backgroundColor,
                          child: Text(
                            'Registration',
                            style: TextStyle(
                              color: AppColorScheme.textColor,
                              fontSize: 20,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed('/account_type_choice');
                          },
                        ),
                      ),
                      Spacer(),
                      Container(
                        height: 60,
                        width: 200,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 2, color: AppColorScheme.appbarColor),
                            borderRadius: BorderRadius.circular(10)),
                        child: RaisedButton(
                          color: AppColorScheme.backgroundColor,
                          child: Text(
                            'Authorization',
                            style: TextStyle(
                              color: AppColorScheme.textColor,
                              fontSize: 20,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed('/authorization');
                          },
                        ),
                      ),
                      Spacer(
                        flex: 3,
                      ),
                    ]),
                  );
                }
                return _loading();
              },
            )));
  }

  Widget _somethingWentWrong() {
    return Center(
      child: Container(
        width: 300,
        height: 200,
        child: Center(
          child: Text(
            'Something went wrong',
            style: TextStyle(color: AppColorScheme.appbarColor, fontSize: 25),
          ),
        ),
      ),
    );
  }

  Widget _loading() {
    return Center(
      child: Container(
        height: 50,
        width: 50,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColorScheme.appbarColor),
        ),
      ),
    );
  }
}
