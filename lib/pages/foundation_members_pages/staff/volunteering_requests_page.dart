import 'package:HelpHere/app/services/staff_service.dart';
import 'package:HelpHere/components/app_card.dart';
import 'package:HelpHere/style/app_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VolunteeringRequests extends StatefulWidget {
  VolunteeringRequests({Key key}) : super(key: key);

  @override
  _VolunteeringRequestsState createState() => _VolunteeringRequestsState();
}

class _VolunteeringRequestsState extends State<VolunteeringRequests> {
  StaffService _staffService;

  @override
  void initState() {
    _staffService = Provider.of<StaffService>(context, listen: false);
    _staffService.loadUnregisteredVolunteers();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StaffService>(
        builder: (context, volunteersService, child) {
      var volunteers = volunteersService.unregisteredVolunteers;
      return Scaffold(
          backgroundColor: AppColorScheme.backgroundColor,
          body: GestureDetector(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              alignment: Alignment.center,
              child: volunteers.length == 0
                  ? Text(
                      'There are currently no volunteering requests.',
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
                                            color: AppColorScheme.barTextColor,
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
                                          color: AppColorScheme.barTextColor),
                                    ))
                                  ])
                                ],
                              ),
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.all(5),
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/volunteering_request_info',
                                  arguments: {
                                    'volunteering_request': volunteers[i]
                                  });
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
