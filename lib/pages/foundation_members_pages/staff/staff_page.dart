import 'package:HelpHere/enums/roles_enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'admins_page.dart';
import 'volunteering_requests_page.dart';
import 'volunteers_page.dart';
import '../../../style/app_color_scheme.dart';

class Staff extends StatefulWidget {
  final Role accountRole;

  Staff({Key key, this.accountRole}) : super(key: key);

  @override
  _StaffState createState() => _StaffState();
}

class _StaffState extends State<Staff> {
  int _currentIndex = 0;

  List<Widget> _staffPages;
  List<Widget> _tabs;

  @override
  void initState() {
    _staffPages = widget.accountRole == Role.admin
        ? [
            VolunteeringRequests(),
            Volunteers(isNeedToDisplayAppbar: false),
            Admins(isNeedToDisplayAppbar: false),
          ]
        : [
            Volunteers(isNeedToDisplayAppbar: false),
            Admins(isNeedToDisplayAppbar: false),
          ];

    _tabs = widget.accountRole == Role.admin
        ? [
            Tab(
                child: Text(
              'Volunteering Requests',
              textAlign: TextAlign.center,
              maxLines: 2,
            )),
            Tab(text: 'Volunteers'),
            Tab(text: 'Admins'),
          ]
        : [
            Tab(text: 'Volunteers'),
            Tab(text: 'Admins'),
          ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
          backgroundColor: AppColorScheme.backgroundColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColorScheme.appbarColor,
            title: TabBar(
              tabs: _tabs,
              onTap: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
          body: _staffPages[_currentIndex]),
    );
  }
}
