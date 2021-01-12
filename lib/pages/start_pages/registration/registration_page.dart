import 'package:HelpHere/app/firebase/firebase_db.dart';
import 'package:HelpHere/app/regexp/regexp.dart';
import 'package:HelpHere/app/services/account_service.dart';
import 'file:///C:/Users/Alexandr_Kulbachka/pet_projects/HelpHere/lib/components/dialogs/ok_dialog.dart';
import 'package:HelpHere/models/admin_account_code.dart';
import 'package:HelpHere/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/firebase/firebase_auth.dart';
import '../../../components/circled_button.dart';
import '../../../components/app_button.dart';
import '../../../components/app_text_field.dart';
import '../../../components/dialogs/fb_auth_success_error_message.dart';
import '../../../style/app_color_scheme.dart';
import '../../../enums/roles_enum.dart';

class Registration extends StatefulWidget {
  final Role accountRole;

  Registration({Key key, @required this.accountRole}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  FBAuth _fbAuth;
  FBDataBase _fbDataBase;

  TextEditingController _adminAccountCodeController;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _confirmPasswordController;

  FocusNode _adminAccountCodeFocusNode;
  FocusNode _emailFocusNode;
  FocusNode _passwordFocusNode;
  FocusNode _confirmPasswordFocusNode;

  bool _isAccountCodeValid = false;
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  bool _isConfirmPasswordValid = false;

  bool _hasUppercase;
  bool _hasDigits;
  bool _hasLowercase;
  bool _hasSpecialCharacters;
  bool _hasMinLength;

  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  bool _canSave = false;

  @override
  void initState() {
    _fbAuth = FBAuth.getInstance();
    _fbDataBase = FBDataBase.getInstance();

    _adminAccountCodeController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    _adminAccountCodeFocusNode = FocusNode();
    _adminAccountCodeFocusNode.addListener(() {
      setState(() {});
    });

    _emailFocusNode = FocusNode();
    _emailFocusNode.addListener(() {
      setState(() {});
    });

    _passwordFocusNode = FocusNode();
    _passwordFocusNode.addListener(() {
      setState(() {});
    });

    _confirmPasswordFocusNode = FocusNode();
    _confirmPasswordFocusNode.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _adminAccountCodeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _adminAccountCodeFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
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
            title: Text('Registration'),
          ),
          body: GestureDetector(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ListView(
                  children: [_fields(), _passwordRequirements()],
                ),
                if (_canSave)
                  Positioned(
                      child: Align(
                    alignment: Alignment.bottomCenter,
                    child: AppButton(
                        margin: EdgeInsets.only(bottom: 10),
                        text: 'CREATE ACCOUNT',
                        textSize: 20,
                        textColor: AppColorScheme.textColor,
                        buttonColor: AppColorScheme.backgroundColor,
                        height: 60,
                        width: 220,
                        onPressed: () async {
                          if (_canSave) {
                            if (widget.accountRole == Role.admin) {
                              var code = await _fbDataBase.loadItemsByAttribute(
                                  itemName: AdminAccountCode.nameInBase,
                                  fieldName: 'accountCode',
                                  fieldValue: _adminAccountCodeController.text);
                              if (code == null || code.isEmpty) {
                                showOkDialog(
                                    context: context,
                                    message:
                                        "Invalid code entered. It may have already been used to create another account. Contact one of the fund's administrators to create a new code for you");
                                _adminAccountCodeController.clear();
                                return;
                              } else {
                                await _fbDataBase.deleteItemById(
                                    itemName: AdminAccountCode.nameInBase,
                                    itemId: code.entries.first.key);
                              }
                            }

                            var id = await _fbAuth.register(
                                _emailController.text,
                                _passwordController.text);
                            if (id is String) {
                              accountService.account.id = id;
                              accountService.account.isRegistered =
                                  widget.accountRole == Role.admin
                                      ? null
                                      : false;
                              await accountService.createAccount();
                            }

                            fbAuthSuccessErrorMessage(
                                result: id,
                                context: context,
                                successText: 'Account successfully created!',
                                onPopAction: (BuildContext context) {
                                  if (accountService.account.role ==
                                      Role.admin) {
                                    Navigator.of(context).pushReplacementNamed(
                                        '/admin_navigation');
                                  } else {
                                    Navigator.of(context).pushReplacementNamed(
                                        '/volunteer_navigation');
                                  }
                                });
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
    return Column(children: [
      if (widget.accountRole == Role.admin)
        AppTextField(
          padding: EdgeInsets.all(10),
          fieldController: _adminAccountCodeController,
          fieldFocusNode: _adminAccountCodeFocusNode,
          maxLines: 1,
          cursorColor: AppColorScheme.enabledTextFieldColor,
          textColor: _adminAccountCodeFocusNode.hasFocus ||
                  _adminAccountCodeController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          labelText: "Code for registering an admins account",
          labelSize: 19,
          labelColor: _adminAccountCodeFocusNode.hasFocus ||
                  _adminAccountCodeController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          enabledBorderColor: AppColorScheme.enabledTextFieldColor,
          disabledBorderColor: _adminAccountCodeController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          errorText:
              _isAccountCodeValid || _adminAccountCodeController.text.isEmpty
                  ? null
                  : "Invalid code for registering an account",
          onChanged: (value) {
            setState(() {
              if (accountCodeRegExp.hasMatch(value)) {
                _isAccountCodeValid = true;
              } else {
                _isAccountCodeValid = false;
              }
              checkFields();
            });
          },
        ),
      AppTextField(
        padding: EdgeInsets.all(10),
        fieldController: _emailController,
        fieldFocusNode: _emailFocusNode,
        maxLines: 1,
        cursorColor: AppColorScheme.enabledTextFieldColor,
        textColor: _emailFocusNode.hasFocus || _emailController.text.length > 0
            ? AppColorScheme.enabledTextFieldColor
            : AppColorScheme.disabledTextFieldColor,
        labelText: "Input email",
        labelSize: 19,
        labelColor: _emailFocusNode.hasFocus || _emailController.text.length > 0
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
            if (emailRegExp.hasMatch(value)) {
              _isEmailValid = true;
            } else {
              _isEmailValid = false;
            }
            checkFields();
          });
        },
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
              child: AppTextField(
            obscureText: _isPasswordObscured,
            autocorrect: false,
            enableSuggestions: false,
            padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
            fieldController: _passwordController,
            fieldFocusNode: _passwordFocusNode,
            maxLines: 1,
            cursorColor: AppColorScheme.enabledTextFieldColor,
            textColor: _passwordFocusNode.hasFocus ||
                    _passwordController.text.length > 0
                ? AppColorScheme.enabledTextFieldColor
                : AppColorScheme.disabledTextFieldColor,
            labelText: "Input password",
            labelSize: 19,
            labelColor: _passwordFocusNode.hasFocus ||
                    _passwordController.text.length > 0
                ? AppColorScheme.enabledTextFieldColor
                : AppColorScheme.disabledTextFieldColor,
            enabledBorderColor: AppColorScheme.enabledTextFieldColor,
            disabledBorderColor: _passwordController.text.length > 0
                ? AppColorScheme.enabledTextFieldColor
                : AppColorScheme.disabledTextFieldColor,
            errorText: _isPasswordValid || _passwordController.text.isEmpty
                ? null
                : "Invalid password",
            onChanged: (value) {
              setState(() {
                _isPasswordValid = _isPasswordCompliant(value);
                _isPasswordsMatched();
                checkFields();
              });
            },
          )),
          CircledButton(
              size: 40,
              icon: _isPasswordObscured
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              iconColor: _passwordFocusNode.hasFocus ||
                      _passwordController.text.length > 0
                  ? AppColorScheme.enabledTextFieldColor
                  : AppColorScheme.disabledTextFieldColor,
              onPressed: () {
                setState(() {
                  _isPasswordObscured = !_isPasswordObscured;
                });
              })
        ],
      ),
      Row(
        children: [
          Flexible(
              child: AppTextField(
            obscureText: _isConfirmPasswordObscured,
            autocorrect: false,
            enableSuggestions: false,
            padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
            fieldController: _confirmPasswordController,
            fieldFocusNode: _confirmPasswordFocusNode,
            maxLines: 1,
            cursorColor: AppColorScheme.enabledTextFieldColor,
            textColor: _confirmPasswordFocusNode.hasFocus ||
                    _confirmPasswordController.text.length > 0
                ? AppColorScheme.enabledTextFieldColor
                : AppColorScheme.disabledTextFieldColor,
            labelText: "Confirm password",
            labelSize: 19,
            labelColor: _confirmPasswordFocusNode.hasFocus ||
                    _confirmPasswordController.text.length > 0
                ? AppColorScheme.enabledTextFieldColor
                : AppColorScheme.disabledTextFieldColor,
            enabledBorderColor: AppColorScheme.enabledTextFieldColor,
            disabledBorderColor: _confirmPasswordController.text.length > 0
                ? AppColorScheme.enabledTextFieldColor
                : AppColorScheme.disabledTextFieldColor,
            errorText: _isConfirmPasswordValid ||
                    _confirmPasswordController.text.isEmpty
                ? null
                : "Invalid password",
            onChanged: (value) {
              setState(() {
                _isPasswordsMatched();
                checkFields();
              });
            },
          )),
          CircledButton(
              size: 40,
              icon: _isConfirmPasswordObscured
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              iconColor: _confirmPasswordFocusNode.hasFocus ||
                      _confirmPasswordController.text.length > 0
                  ? AppColorScheme.enabledTextFieldColor
                  : AppColorScheme.disabledTextFieldColor,
              onPressed: () {
                setState(() {
                  _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
                });
              }),
        ],
      )
    ]);
  }

  Widget _passwordRequirements() {
    return Container(
      margin: EdgeInsets.only(bottom: 75),
      child: Column(children: [
        _passwordRequirement(
            text: 'Password Requirements:',
            color: _passwordController.text.isEmpty
                ? AppColorScheme.disabledTextFieldColor
                : AppColorScheme.appbarColor,
            size: 20),
        _passwordRequirement(
            text: 'Uppercase letter(s)',
            color: _passwordController.text.isEmpty
                ? AppColorScheme.disabledTextFieldColor
                : _hasUppercase
                    ? AppColorScheme.appbarColor
                    : Colors.red),
        _passwordRequirement(
            text: 'Lowercase letter(s)',
            color: _passwordController.text.isEmpty
                ? AppColorScheme.disabledTextFieldColor
                : _hasLowercase
                    ? AppColorScheme.appbarColor
                    : Colors.red),
        _passwordRequirement(
            text: 'Numeric character(s)',
            color: _passwordController.text.isEmpty
                ? AppColorScheme.disabledTextFieldColor
                : _hasDigits
                    ? AppColorScheme.appbarColor
                    : Colors.red),
        _passwordRequirement(
            text: 'Special character(s)',
            color: _passwordController.text.isEmpty
                ? AppColorScheme.disabledTextFieldColor
                : _hasSpecialCharacters
                    ? AppColorScheme.appbarColor
                    : Colors.red),
        _passwordRequirement(
            text: 'Longer than 8 characters',
            color: _passwordController.text.isEmpty
                ? AppColorScheme.disabledTextFieldColor
                : _hasMinLength
                    ? AppColorScheme.appbarColor
                    : Colors.red),
      ]),
    );
  }

  Widget _passwordRequirement({String text, Color color, double size}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: size ?? 18,
        ),
      ),
    );
  }

  bool _isPasswordCompliant(String password, [int minLength = 8]) {
    if (password == null || password.isEmpty) {
      return false;
    }

    _hasUppercase = password.contains(new RegExp(r'[A-Z]'));
    _hasDigits = password.contains(new RegExp(r'[0-9]'));
    _hasLowercase = password.contains(new RegExp(r'[a-z]'));
    _hasSpecialCharacters =
        password.contains(new RegExp(r'[!@#$%^&*(),.?"_:{}|<>+-]'));
    _hasMinLength = password.length > minLength;

    return _hasDigits &
        _hasUppercase &
        _hasLowercase &
        _hasSpecialCharacters &
        _hasMinLength;
  }

  void _isPasswordsMatched() {
    _isConfirmPasswordValid = _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _passwordController.text == _confirmPasswordController.text;
  }

  void checkFields() {
    if (_isEmailValid &&
        _isPasswordValid &&
        _isConfirmPasswordValid &&
        _passwordController.text == _confirmPasswordController.text &&
        !((widget.accountRole == Role.admin) ^ _isAccountCodeValid)) {
      _canSave = true;
    } else {
      _canSave = false;
    }
  }
}
