import 'package:HelpHere/app/services/account_service.dart';
import 'package:HelpHere/app/services/help_requests_service.dart';
import 'package:HelpHere/components/app_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../style/app_color_scheme.dart';

class FoundationWards extends StatefulWidget {
  FoundationWards({Key key}) : super(key: key);

  @override
  _FoundationWardsState createState() => _FoundationWardsState();
}

class _FoundationWardsState extends State<FoundationWards> {
  HelpRequestsService _helpRequestsService;

  @override
  void initState() {
    _helpRequestsService =
        Provider.of<HelpRequestsService>(context, listen: false);
    _helpRequestsService.loadApprovedHelpRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AccountService, HelpRequestsService>(
        builder: (context, accountService, helpRequestsService, child) {
      var helpRequests = helpRequestsService.approvedHelpRequests;
      return Scaffold(
        backgroundColor: AppColorScheme.backgroundColor,
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
                  child: helpRequests.length == 0
                      ? Text(
                          'There are currently no foundation wards.',
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
                                              '${helpRequests[i].candidatesName} ${helpRequests[i].candidatesPatronymic} ${helpRequests[i].candidatesPatronymic}',
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    AppColorScheme.barTextColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Spacer()
                                      ]),
                                      Row(children: [
                                        Flexible(
                                            child: Text(
                                          helpRequests[i].description,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color:
                                                  AppColorScheme.barTextColor),
                                        ))
                                      ])
                                    ],
                                  ),
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.all(5),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/foundation_ward_info',
                                      arguments: {
                                        'help_request': helpRequests[i]
                                      });
                                });
                          },
                          itemCount: helpRequests.length,
                        ),
                ),
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
        ),
      );
    });
  }
}
