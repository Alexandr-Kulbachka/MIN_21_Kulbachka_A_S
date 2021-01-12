import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../style/app_color_scheme.dart';
import 'foundation_wards_page.dart';
import 'help_requests_page.dart';

class Wards extends StatefulWidget {
  Wards({Key key}) : super(key: key);

  @override
  _WardsState createState() => _WardsState();
}

class _WardsState extends State<Wards> {
  int _currentIndex = 0;

  final List<Widget> wardsPages = [HelpRequests(), FoundationWards()];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: AppColorScheme.backgroundColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColorScheme.appbarColor,
            title: TabBar(
              tabs: [
                Tab(text: 'Help Requests'),
                Tab(text: 'Foundation Wards'),
              ],
              onTap: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
          body: wardsPages[_currentIndex]),
    );
  }
}
