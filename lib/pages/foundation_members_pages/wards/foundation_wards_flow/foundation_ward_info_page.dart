import 'package:HelpHere/app/services/account_service.dart';
import 'package:HelpHere/components/app_text_field.dart';
import 'package:HelpHere/enums/roles_enum.dart';
import 'package:HelpHere/models/help_request.dart';
import 'package:HelpHere/style/app_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FoundationWardInfo extends StatefulWidget {
  final HelpRequest helpRequest;

  FoundationWardInfo({Key key, this.helpRequest}) : super(key: key);

  @override
  _FoundationWardInfoState createState() => _FoundationWardInfoState();
}

class _FoundationWardInfoState extends State<FoundationWardInfo> {
  TextEditingController _nameController;
  TextEditingController _patronymicController;
  TextEditingController _surnameController;
  TextEditingController _ageController;
  TextEditingController _phoneNumberController;
  TextEditingController _emailController;
  TextEditingController _addressController;
  TextEditingController _descriptionController;

  String _title;

  @override
  void initState() {
    _nameController =
        TextEditingController(text: widget.helpRequest.candidatesName ?? '-');
    _patronymicController = TextEditingController(
        text: widget.helpRequest.candidatesPatronymic ?? '-');
    _surnameController = TextEditingController(
        text: widget.helpRequest.candidatesSurname ?? '-');
    _ageController = TextEditingController(
        text: widget.helpRequest.candidatesAge.toString() ?? '-');
    _phoneNumberController = TextEditingController(
        text: widget.helpRequest.phoneNumber.toString() ?? '-');
    _emailController =
        TextEditingController(text: widget.helpRequest.email ?? '-');
    _addressController =
        TextEditingController(text: widget.helpRequest.address ?? '-');
    _descriptionController =
        TextEditingController(text: widget.helpRequest.description ?? '-');

    _title = widget.helpRequest.candidatesName.isNotEmpty &&
            widget.helpRequest.candidatesSurname.isNotEmpty
        ? '${widget.helpRequest.candidatesName} ${widget.helpRequest.candidatesSurname}'
        : '';

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _patronymicController.dispose();
    _surnameController.dispose();
    _ageController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();

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
            title: Text(_title),
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
      margin: EdgeInsets.only(bottom: 75),
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
          fieldController: _patronymicController,
          readOnly: true,
          maxLines: 1,
          cursorColor: AppColorScheme.enabledTextFieldColor,
          textColor: _patronymicController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          labelSize: 17,
          labelText: "Patronymic",
          labelColor: _patronymicController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          enabledBorderColor: AppColorScheme.enabledTextFieldColor,
          disabledBorderColor: _patronymicController.text.length > 0
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
            fieldController: _phoneNumberController,
            readOnly: true,
            maxLines: 1,
            cursorColor: AppColorScheme.enabledTextFieldColor,
            textColor: _phoneNumberController.text.length > 0
                ? AppColorScheme.enabledTextFieldColor
                : AppColorScheme.disabledTextFieldColor,
            labelSize: 17,
            labelText: "Phone number",
            labelColor: _phoneNumberController.text.length > 0
                ? AppColorScheme.enabledTextFieldColor
                : AppColorScheme.disabledTextFieldColor,
            enabledBorderColor: AppColorScheme.enabledTextFieldColor,
            disabledBorderColor: _phoneNumberController.text.length > 0
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
        if (isAdmin)
          AppTextField(
            padding: EdgeInsets.all(10),
            fieldController: _addressController,
            readOnly: true,
            maxLines: 1,
            cursorColor: AppColorScheme.enabledTextFieldColor,
            textColor: _addressController.text.length > 0
                ? AppColorScheme.enabledTextFieldColor
                : AppColorScheme.disabledTextFieldColor,
            labelSize: 17,
            labelText: "Address",
            labelColor: _addressController.text.length > 0
                ? AppColorScheme.enabledTextFieldColor
                : AppColorScheme.disabledTextFieldColor,
            enabledBorderColor: AppColorScheme.enabledTextFieldColor,
            disabledBorderColor: _addressController.text.length > 0
                ? AppColorScheme.enabledTextFieldColor
                : AppColorScheme.disabledTextFieldColor,
          ),
        AppTextField(
          padding: EdgeInsets.all(10),
          fieldController: _descriptionController,
          readOnly: true,
          maxLines: null,
          cursorColor: AppColorScheme.enabledTextFieldColor,
          textColor: _descriptionController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          labelSize: 17,
          labelText: "Description",
          labelColor: _descriptionController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          enabledBorderColor: AppColorScheme.enabledTextFieldColor,
          disabledBorderColor: _descriptionController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
        ),
      ]),
    );
  }
}
