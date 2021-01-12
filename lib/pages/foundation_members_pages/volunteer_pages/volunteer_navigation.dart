import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../enums/roles_enum.dart';
import '../settings_pages/settings_page.dart';
import '../staff/staff_page.dart';
import '../wards/wards_page.dart';
import '../../../style/app_color_scheme.dart';

class VolunteerNavigation extends StatefulWidget {
  VolunteerNavigation({Key key}) : super(key: key);

  @override
  _VolunteerNavigationState createState() => _VolunteerNavigationState();
}

class _VolunteerNavigationState extends State<VolunteerNavigation> {
  int _currentIndex = 0;

  final List<Widget> mainPages = [
    Wards(),
    Staff(
      accountRole: Role.volunteer,
    ),
    Settings()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
