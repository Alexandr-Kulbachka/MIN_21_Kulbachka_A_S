import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/regexp/regexp.dart';
import '../../../app/services/account_service.dart';
import '../../../components/app_button.dart';
import '../../../components/app_text_field.dart';
import '../../../components/dialogs/fb_auth_success_error_message.dart';
import '../../../enums/roles_enum.dart';
import '../../../style/app_color_scheme.dart';

class AccountInfo extends StatefulWidget {
  final Role accountRole;
  final String title;

  AccountInfo({Key key, @required this.accountRole, this.title})
      : super(key: key);

  @override
  _AccountInfoState createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  AccountService accountService;

  TextEditingController _nameController;
  TextEditingController _surnameController;
  TextEditingController _ageController;
  TextEditingController _emailController;
  TextEditingController _specialtyController;

  FocusNode _nameFocusNode;
  FocusNode _surnameFocusNode;
  FocusNode _ageFocusNode;
  FocusNode _emailFocusNode;
  FocusNode _specialtyFocusNode;

  bool _isAgeValid = false;
  bool _isEmailValid = false;

  bool _canSave = false;

  @override
  void initState() {
    accountService = Provider.of<AccountService>(context, listen: false);

    _nameController =
        TextEditingController(text: accountService.account.name ?? '');
    _surnameController =
        TextEditingController(text: accountService.account.surname ?? '');
    _ageController = TextEditingController(
        text: accountService.account.age > 0
            ? accountService.account.age.toString()
            : '');
    _emailController =
        TextEditingController(text: accountService.account.email ?? '');
    _specialtyController =
        TextEditingController(text: accountService.account.specialty ?? '');

    _checkFields();
    _canSave = false;

    _nameFocusNode = FocusNode();
    _nameFocusNode.addListener(() {
      setState(() {});
    });

    _surnameFocusNode = FocusNode();
    _surnameFocusNode.addListener(() {
      setState(() {});
    });

    _ageFocusNode = FocusNode();
    _ageFocusNode.addListener(() {
      setState(() {});
    });

    _emailFocusNode = FocusNode();
    _emailFocusNode.addListener(() {
      setState(() {});
    });

    _specialtyFocusNode = FocusNode();
    _specialtyFocusNode.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _specialtyController.dispose();

    _nameFocusNode.dispose();
    _surnameFocusNode.dispose();
    _ageFocusNode.dispose();
    _emailFocusNode.dispose();
    _specialtyFocusNode.dispose();

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
              widget.title,
            ),
          ),
          body: GestureDetector(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ListView(
                  children: [
                    Center(
                      child: Text(
                        'Please fill in account info.',
                        style: TextStyle(
                            color: AppColorScheme.appbarColor, fontSize: 16),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Required fields are marked '*'",
                        style: TextStyle(
                            color: AppColorScheme.appbarColor, fontSize: 16),
                      ),
                    ),
                    _fields()
                  ],
                ),
                if (_canSave)
                  Positioned(
                      child: Align(
                    alignment: Alignment.bottomCenter,
                    child: AppButton(
                        margin: EdgeInsets.only(bottom: 10),
                        text: widget.accountRole != null ? 'NEXT' : 'SAVE',
                        textSize: 20,
                        textColor: AppColorScheme.textColor,
                        buttonColor: AppColorScheme.backgroundColor,
                        height: 60,
                        width: 220,
                        onPressed: () async {
                          if (_canSave) {
                            var user = accountService.account;
                            user.name = _nameController.text;
                            user.surname = _surnameController.text;
                            user.age = int.parse(_ageController.text);
                            user.email = _emailController.text;
                            user.specialty = _specialtyController.text;
                            if (widget.accountRole != null) {
                              user.role = widget.accountRole;
                              Navigator.of(context).pushNamed('/registration',
                                  arguments: {
                                    'accountRole': widget.accountRole
                                  });
                            } else {
                              var result = await accountService
                                  .updateAccountInfo(user: user);

                              fbAuthSuccessErrorMessage(
                                  isShouldPopIfError: true,
                                  result: result,
                                  context: context,
                                  successText:
                                      'Account info successfully saved!',
                                  onPopAction: (context) {
                                    Navigator.of(context, rootNavigator: true)
                                      ..pop()
                                      ..pop();
                                  });
                            }
                          }
                        }),
                  ))
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

  Widget _fields() {
    return Container(
      margin: EdgeInsets.only(bottom: 75),
      child: Column(children: [
        AppTextField(
          padding: EdgeInsets.all(10),
          fieldController: _nameController,
          fieldFocusNode: _nameFocusNode,
          maxLines: 1,
          cursorColor: AppColorScheme.enabledTextFieldColor,
          textColor: _nameFocusNode.hasFocus || _nameController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          labelSize: 17,
          labelText: "Name*",
          labelColor: _nameFocusNode.hasFocus || _nameController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          enabledBorderColor: AppColorScheme.enabledTextFieldColor,
          disabledBorderColor: _nameController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          onChanged: (value) {
            setState(() {
              _checkFields();
            });
          },
        ),
        AppTextField(
          padding: EdgeInsets.all(10),
          fieldController: _surnameController,
          fieldFocusNode: _surnameFocusNode,
          maxLines: 1,
          cursorColor: AppColorScheme.enabledTextFieldColor,
          textColor:
              _surnameFocusNode.hasFocus || _surnameController.text.length > 0
                  ? AppColorScheme.enabledTextFieldColor
                  : AppColorScheme.disabledTextFieldColor,
          labelSize: 17,
          labelText: "Surname*",
          labelColor:
              _surnameFocusNode.hasFocus || _surnameController.text.length > 0
                  ? AppColorScheme.enabledTextFieldColor
                  : AppColorScheme.disabledTextFieldColor,
          enabledBorderColor: AppColorScheme.enabledTextFieldColor,
          disabledBorderColor: _surnameController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          onChanged: (value) {
            setState(() {
              _checkFields();
            });
          },
        ),
        AppTextField(
          keyboardType:
              TextInputType.numberWithOptions(decimal: true, signed: false),
          padding: EdgeInsets.all(10),
          fieldController: _ageController,
          fieldFocusNode: _ageFocusNode,
          maxLines: 1,
          cursorColor: AppColorScheme.enabledTextFieldColor,
          textColor: _ageFocusNode.hasFocus || _ageController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          labelSize: 17,
          labelText: "Age*",
          labelColor: _ageFocusNode.hasFocus || _ageController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          enabledBorderColor: AppColorScheme.enabledTextFieldColor,
          disabledBorderColor: _ageController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          errorText:
              _isAgeValid || _ageController.text.isEmpty ? null : "Invalid age",
          onChanged: (value) {
            setState(() {
              _checkFields();
            });
          },
        ),
        AppTextField(
          padding: EdgeInsets.all(10),
          fieldController: _emailController,
          fieldFocusNode: _emailFocusNode,
          maxLines: 1,
          cursorColor: AppColorScheme.enabledTextFieldColor,
          textColor:
              _emailFocusNode.hasFocus || _emailController.text.length > 0
                  ? AppColorScheme.enabledTextFieldColor
                  : AppColorScheme.disabledTextFieldColor,
          labelSize: 17,
          labelText: "Email(Visible only for admins)",
          labelColor:
              _emailFocusNode.hasFocus || _emailController.text.length > 0
                  ? AppColorScheme.enabledTextFieldColor
                  : AppColorScheme.disabledTextFieldColor,
          enabledBorderColor: AppColorScheme.enabledTextFieldColor,
          disabledBorderColor: _emailController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          errorText: _isEmailValid || _emailController.text.isEmpty
              ? null
              : "Invalid email",
          onChanged: (value) {
            setState(() {
              _checkFields();
            });
          },
        ),
        AppTextField(
          padding: EdgeInsets.all(10),
          fieldController: _specialtyController,
          fieldFocusNode: _specialtyFocusNode,
          maxLines: 1,
          cursorColor: AppColorScheme.enabledTextFieldColor,
          textColor: _specialtyFocusNode.hasFocus ||
                  _specialtyController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          labelSize: 17,
          labelText: "Specialty",
          labelColor: _specialtyFocusNode.hasFocus ||
                  _specialtyController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          enabledBorderColor: AppColorScheme.enabledTextFieldColor,
          disabledBorderColor: _specialtyController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          onChanged: (value) {
            setState(() {
              _checkFields();
            });
          },
        ),
      ]),
    );
  }

  void _checkAge(String value) {
    if (ageRegExp.hasMatch(value)) {
      _isAgeValid = true;
    } else {
      _isAgeValid = false;
    }
  }

  void _checkEmail(String value) {
    if (emailRegExp.hasMatch(value)) {
      _isEmailValid = true;
    } else {
      _isEmailValid = false;
    }
  }

  void _checkFields() {
    _checkAge(_ageController.text);
    _checkEmail(_emailController.text);
    if (_nameController.text != '' &&
        _surnameController.text != '' &&
        _ageController.text != '' &&
        (_isEmailValid || _emailController.text == '') &&
        _isAgeValid) {
      _canSave = true;
    } else {
      _canSave = false;
    }
  }
}
