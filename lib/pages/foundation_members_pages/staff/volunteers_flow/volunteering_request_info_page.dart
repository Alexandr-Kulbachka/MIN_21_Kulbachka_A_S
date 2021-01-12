import 'package:HelpHere/app/services/account_service.dart';
import 'package:HelpHere/app/services/staff_service.dart';
import 'package:HelpHere/components/app_button.dart';
import 'package:HelpHere/components/app_text_field.dart';
import 'file:///C:/Users/Alexandr_Kulbachka/pet_projects/HelpHere/lib/components/dialogs/fb_auth_success_error_message.dart';
import 'package:HelpHere/enums/roles_enum.dart';
import 'package:HelpHere/models/user.dart';
import 'package:HelpHere/style/app_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VolunteeringRequestInfo extends StatefulWidget {
  final User volunteer;

  VolunteeringRequestInfo({Key key, this.volunteer}) : super(key: key);

  @override
  _VolunteeringRequestInfoState createState() =>
      _VolunteeringRequestInfoState();
}

class _VolunteeringRequestInfoState extends State<VolunteeringRequestInfo> {
  TextEditingController _nameController;
  TextEditingController _surnameController;
  TextEditingController _ageController;
  TextEditingController _emailController;
  TextEditingController _specialtyController;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.volunteer.name ?? '-');
    _surnameController =
        TextEditingController(text: widget.volunteer.surname ?? '-');
    _ageController =
        TextEditingController(text: widget.volunteer.age.toString() ?? '-');
    _emailController =
        TextEditingController(text: widget.volunteer.email ?? '-');
    _specialtyController =
        TextEditingController(text: widget.volunteer.specialty ?? '-');

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _specialtyController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AccountService, StaffService>(
        builder: (context, accountService, volunteersService, child) {
      return Scaffold(
          backgroundColor: AppColorScheme.backgroundColor,
          appBar: AppBar(
            backgroundColor: AppColorScheme.appbarColor,
            centerTitle: true,
            title: Text('Volunteering Request Info'),
          ),
          body: GestureDetector(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ListView(
                  children: [
                    _fields(accountService.account.role == Role.admin)
                  ],
                ),
                Positioned(
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AppButton(
                                margin: EdgeInsets.only(bottom: 10),
                                text: 'Decline',
                                textSize: 20,
                                textColor: AppColorScheme.declineButtonColor,
                                borderColor: AppColorScheme.declineButtonColor,
                                buttonColor: AppColorScheme.backgroundColor,
                                height: 50,
                                width: 150,
                                onPressed: () async {
                                  var result =
                                      await volunteersService.deleteVolunteer(
                                          volunteerDocumentId:
                                              widget.volunteer.documentId);

                                  fbAuthSuccessErrorMessage(
                                      result: result,
                                      context: context,
                                      successText:
                                          'Volunteering request declined!',
                                      onPopAction: (context) {
                                        Navigator.of(context,
                                            rootNavigator: true)
                                          ..pop()
                                          ..pop();
                                      });
                                }),
                            AppButton(
                                margin: EdgeInsets.only(bottom: 10),
                                text: 'Approve',
                                textSize: 20,
                                textColor: AppColorScheme.approveButtonColor,
                                borderColor: AppColorScheme.approveButtonColor,
                                buttonColor: AppColorScheme.backgroundColor,
                                height: 50,
                                width: 150,
                                onPressed: () async {
                                  var result = await volunteersService
                                      .updateVolunteerStatus(
                                          id: widget.volunteer.id,
                                          isRegistered: true);

                                  await volunteersService
                                      .loadUnregisteredVolunteers();

                                  fbAuthSuccessErrorMessage(
                                      result: result,
                                      context: context,
                                      successText:
                                          'Volunteering request approved!',
                                      onPopAction: (context) {
                                        Navigator.of(context,
                                            rootNavigator: true)
                                          ..pop()
                                          ..pop();
                                      });
                                }),
                          ],
                        )))
              ],
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

  Widget _fields(bool isAdmin) {
    return Container(
      child: Column(children: [
        AppTextField(
          readOnly: true,
          padding: EdgeInsets.all(10),
          fieldController: _nameController,
          maxLines: 1,
          cursorColor: AppColorScheme.enabledTextFieldColor,
          textColor: AppColorScheme.enabledTextFieldColor,
          labelSize: 17,
          labelText: "Name",
          labelColor: _nameController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          enabledBorderColor: AppColorScheme.enabledTextFieldColor,
          disabledBorderColor: _nameController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
        ),
        AppTextField(
          padding: EdgeInsets.all(10),
          fieldController: _surnameController,
          readOnly: true,
          maxLines: 1,
          cursorColor: AppColorScheme.enabledTextFieldColor,
          textColor: _surnameController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          labelSize: 17,
          labelText: "Surname",
          labelColor: _surnameController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          enabledBorderColor: AppColorScheme.enabledTextFieldColor,
          disabledBorderColor: _surnameController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
        ),
        AppTextField(
          padding: EdgeInsets.all(10),
          fieldController: _ageController,
          readOnly: true,
          maxLines: 1,
          cursorColor: AppColorScheme.enabledTextFieldColor,
          textColor: _ageController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          labelSize: 17,
          labelText: "Age",
          labelColor: _ageController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          enabledBorderColor: AppColorScheme.enabledTextFieldColor,
          disabledBorderColor: _ageController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
        ),
        if (isAdmin)
          AppTextField(
            padding: EdgeInsets.all(10),
            fieldController: _emailController,
            readOnly: true,
            maxLines: 1,
            cursorColor: AppColorScheme.enabledTextFieldColor,
            textColor: _emailController.text.length > 0
                ? AppColorScheme.enabledTextFieldColor
                : AppColorScheme.disabledTextFieldColor,
            labelSize: 17,
            labelText: "Email",
            labelColor: _emailController.text.length > 0
                ? AppColorScheme.enabledTextFieldColor
                : AppColorScheme.disabledTextFieldColor,
            enabledBorderColor: AppColorScheme.enabledTextFieldColor,
            disabledBorderColor: _emailController.text.length > 0
                ? AppColorScheme.enabledTextFieldColor
                : AppColorScheme.disabledTextFieldColor,
          ),
        AppTextField(
          padding: EdgeInsets.all(10),
          fieldController: _specialtyController,
          readOnly: true,
          maxLines: 1,
          cursorColor: AppColorScheme.enabledTextFieldColor,
          textColor: _specialtyController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          labelSize: 17,
          labelText: "Specialty",
          labelColor: _specialtyController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          enabledBorderColor: AppColorScheme.enabledTextFieldColor,
          disabledBorderColor: _specialtyController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
        ),
      ]),
    );
  }
}
