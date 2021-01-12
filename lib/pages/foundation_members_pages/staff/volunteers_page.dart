import 'package:HelpHere/app/services/account_service.dart';
import 'package:HelpHere/app/services/staff_service.dart';
import 'package:HelpHere/components/app_card.dart';
import 'package:HelpHere/style/app_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Volunteers extends StatefulWidget {
  final bool isNeedToDisplayAppbar;

  Volunteers({Key key, this.isNeedToDisplayAppbar = true}) : super(key: key);

  @override
  _VolunteersState createState() => _VolunteersState();
}

class _VolunteersState extends State<Volunteers> {
  StaffService _staffService;

  @override
  void initState() {
    _staffService = Provider.of<StaffService>(context, listen: false);
    _staffService.loadRegisteredVolunteers();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AccountService, StaffService>(
        builder: (context, accountService, staffService, child) {
      var volunteers = staffService.registeredVolunteers;
      return Scaffold(
          backgroundColor: AppColorScheme.backgroundColor,
          appBar: widget.isNeedToDisplayAppbar
              ? AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: AppColorScheme.appbarColor,
                  centerTitle: true,
                  title: Text('Volunteers'),
                )
              : null,
          body: GestureDetector(
            child: accountService.account.isRegistered != null &&
                    !accountService.account.isRegistered
                ? Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Your account has not yet been approved by the administrator',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColorScheme.appbarColor,
                      ),
                    ),
                  )
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.center,
                    child: volunteers.length == 0
                        ? Text(
                            'There are currently no volunteers.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColorScheme.appbarColor,
                            ),
                          )
                        : ListView.builder(
                            itemBuilder: (context, i) {
                              return GestureDetector(
                                  child: AppCard(
                                    Column(
                                      children: [
                                        Row(children: [
                                          Flexible(
                                            flex: 3,
                                            child: Container(
                                              child: Text(
                                                '${volunteers[i].name ?? volunteers[i].email} ${volunteers[i].surname ?? ""}',
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: false,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColorScheme
                                                      .barTextColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Spacer()
                                        ]),
                                        Row(children: [
                                          Flexible(
                                              child: Text(
                                            volunteers[i].specialty ?? '',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: AppColorScheme
                                                    .barTextColor),
                                          ))
                                        ])
                                      ],
                                    ),
                                    padding: EdgeInsets.all(5),
                                    margin: EdgeInsets.all(5),
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(context, '/staff_info',
                                        arguments: {'staff': volunteers[i]});
                                  });
                            },
                            itemCount: volunteers.length,
                          ),
                  ),
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
          ));
    });
  }
}
