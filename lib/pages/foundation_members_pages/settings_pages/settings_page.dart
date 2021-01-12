import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../../style/app_color_scheme.dart';
import '../../../app/firebase/firebase_auth.dart';
import '../../../app/services/account_service.dart';
import '../../../app/services/admin_account_code_service.dart';
import '../../../app/services/help_requests_service.dart';
import '../../../app/services/staff_service.dart';
import '../../../components/app_button.dart';
import '../../../components/settings_components/settings_button.dart';
import '../../../enums/roles_enum.dart';

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  FBAuth _fbAuth;

  void initState() {
    _fbAuth = FBAuth.getInstance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer4<AccountService, AdminAccountCodeService,
            HelpRequestsService, StaffService>(
        builder: (context, accountService, adminAccountCodeService,
            helpRequestsService, volunteersService, child) {
      return Scaffold(
        backgroundColor: AppColorScheme.backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColorScheme.appbarColor,
          centerTitle: true,
          title: Text('Settings'),
        ),
        body: Container(
          margin: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              SettingsButton(
                  icon: Icons.person,
                  title: 'Account',
                  onTap: () {
                    Navigator.pushNamed(context, '/settings/account');
                  }),
              if (accountService.account.role == Role.admin)
                SettingsButton(
                    icon: Icons.all_inclusive,
                    title: 'Generate code for admin account registration',
                    onTap: () {
                      Navigator.pushNamed(
                          context, '/settings/generate_admin_code');
                    }),
              SettingsButton(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: AppColorScheme.backgroundColor,
                            title: Text(
                              'Are you sure you want to log out of your account?',
                              style: TextStyle(
                                color: AppColorScheme.textColor,
                              ),
                            ),
                            actions: [
                              AppButton(
                                  text: 'YES',
                                  buttonColor: AppColorScheme.appbarColor,
                                  textColor: AppColorScheme.barTextColor,
                                  onPressed: () async {
                                    await _fbAuth.signOut();

                                    adminAccountCodeService
                                        .clearLocalCodesStorage();
                                    accountService.clearLocalAccountInfo();
                                    helpRequestsService
                                        .clearLocalHelpRequestsStorage();
                                    volunteersService
                                        .clearLocalVolunteersStorage();

                                    Navigator.of(context)
                                        .pushReplacementNamed('/');
                                  }),
                              AppButton(
                                  text: 'NO',
                                  buttonColor: AppColorScheme.appbarColor,
                                  textColor: AppColorScheme.barTextColor,
                                  onPressed: () => Navigator.of(context).pop())
                            ],
                          );
                        });
                  })
            ],
          ),
        ),
      );
    });
  }
}
