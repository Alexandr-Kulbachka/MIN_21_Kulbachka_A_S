import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../enums/roles_enum.dart';
import '../staff/staff_page.dart';
import '../wards/wards_page.dart';
import '../settings_pages/settings_page.dart';
import '../../../style/app_color_scheme.dart';

class AdminNavigation extends StatefulWidget {
  AdminNavigation({Key key}) : super(key: key);

  @override
  _AdminNavigationState createState() => _AdminNavigationState();
}

class _AdminNavigationState extends State<AdminNavigation> {
  int _currentIndex = 0;

  final List<Widget> mainPages = [
    Wards(),
    Staff(
      accountRole: Role.admin,
    ),
    Settings()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppColorScheme.backgroundColor,
        body: mainPages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColorScheme.appbarColor,
          showUnselectedLabels: false,
          unselectedLabelStyle: TextStyle(fontSize: 13),
          unselectedItemColor: AppColorScheme.barDisabledElementColor,
          selectedLabelStyle: TextStyle(fontSize: 16),
          selectedItemColor: AppColorScheme.barEnabledElementColor,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.assignment_ind_outlined,
              ),
              label: 'Wards',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: 'Staff',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
              ),
              label: 'Settings',
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
