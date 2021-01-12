import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../style/app_color_scheme.dart';
import '../../../components/settings_components/settings_button.dart';

class Account extends StatefulWidget {
  Account({Key key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: AppColorScheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColorScheme.appbarColor,
          centerTitle: true,
          title: Text('Account'),
        ),
        body: Container(
          margin: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              SettingsButton(
                  icon: Icons.person_search,
                  title: 'Account Info',
                  onTap: () {
                    Navigator.pushNamed(context, '/account_info',
                        arguments: {'title': 'Account Info'});
                  }),
              SettingsButton(
                  icon: Icons.assignment_ind_rounded,
                  title: 'Authorization Info',
                  onTap: () {
                    Navigator.pushNamed(
                        context, '/settings/authorization_info');
                  }),
            ],
          ),
        ),
      );
  }
}
