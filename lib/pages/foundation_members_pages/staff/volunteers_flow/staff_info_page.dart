import 'package:HelpHere/app/services/account_service.dart';
import 'package:HelpHere/components/app_text_field.dart';
import 'package:HelpHere/enums/roles_enum.dart';
import 'package:HelpHere/models/user.dart';
import 'package:HelpHere/style/app_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StaffInfo extends StatefulWidget {
  final User volunteer;

  StaffInfo({Key key, this.volunteer}) : super(key: key);

  @override
  _StaffInfoState createState() => _StaffInfoState();
}

class _StaffInfoState extends State<StaffInfo> {
  TextEditingController _nameController;
  TextEditingController _surnameController;
  TextEditingController _ageController;
  TextEditingController _emailController;
  TextEditingController _specialtyController;

  String _title;

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

    _title =
        widget.volunteer.name.isNotEmpty && widget.volunteer.surname.isNotEmpty
            ? '${widget.volunteer.name} ${widget.volunteer.surname}'
            : '';

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
    return Consumer<AccountService>(builder: (context, accountService, child) {
      return Scaffold(
          backgroundColor: AppColorScheme.backgroundColor,
          appBar: AppBar(
            backgroundColor: AppColorScheme.appbarColor,
            centerTitle: true,
            title: Text(
              _title,
              maxLines: 2,
              softWrap: true,
            ),
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
          textColor: _nameController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
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
