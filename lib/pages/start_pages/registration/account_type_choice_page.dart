import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../style/app_color_scheme.dart';
import '../../../enums/roles_enum.dart';

class AccountTypeChoicePage extends StatefulWidget {
  AccountTypeChoicePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AccountTypeChoicePageState();
}

class _AccountTypeChoicePageState extends State<AccountTypeChoicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorScheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColorScheme.appbarColor,
        centerTitle: true,
        title: Text(
          'Account type',
          style: TextStyle(color: AppColorScheme.barTextColor),
        ),
      ),
      body: Center(
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
                'Admin',
                style: TextStyle(
                  color: AppColorScheme.textColor,
                  fontSize: 20,
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/account_info', arguments: {
                  'accountRole': Role.admin,
                  'title': 'New Account Info'
                });
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
                'Volunteer',
                style: TextStyle(
                  color: AppColorScheme.textColor,
                  fontSize: 20,
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/account_info', arguments: {
                  'accountRole': Role.volunteer,
                  'title': 'New Account Info'
                });
              },
            ),
          ),
          Spacer(
            flex: 3,
          ),
        ]),
      ),
    );
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
