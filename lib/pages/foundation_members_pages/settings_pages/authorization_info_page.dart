import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/firebase/firebase_auth.dart';
import '../../../components/app_button.dart';
import '../../../components/app_text_field.dart';
import '../../../components/circled_button.dart';
import '../../../app/services/account_service.dart';
import '../../../components/dialogs/fb_auth_success_error_message.dart';
import '../../../style/app_color_scheme.dart';

class AuthorizationInfo extends StatefulWidget {
  bool editMode;
  AuthorizationInfo({Key key, this.editMode = false}) : super(key: key);

  @override
  _AuthorizationInfoState createState() => _AuthorizationInfoState();
}

class _AuthorizationInfoState extends State<AuthorizationInfo> {
  FBAuth _fbAuth;

  String _oldEmail;

  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _newPasswordController;

  FocusNode _emailFocusNode;
  FocusNode _passwordFocusNode;
  FocusNode _newPasswordFocusNode;

  bool _isEmailValid = true;
  bool _isPasswordValid = false;
  bool _isNewPasswordValid = false;

  bool _hasUppercase;
  bool _hasDigits;
  bool _hasLowercase;
  bool _hasSpecialCharacters;
  bool _hasMinLength;

  bool _isPasswordObscured = true;
  bool _isNewPasswordObscured = true;

  bool _isEmailShouldBeeEditable = true;
  bool _isNewPasswordShouldBeeVisible = true;

  RegExp _emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  bool _canSave = false;

  @override
  void initState() {
    _fbAuth = FBAuth.getInstance();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _newPasswordController = TextEditingController();

    _emailController.text = _fbAuth.currentUser.email;
    _oldEmail = _fbAuth.currentUser.email;

    _emailFocusNode = FocusNode();
    _emailFocusNode.addListener(() {
      setState(() {});
    });

    _passwordFocusNode = FocusNode();
    _passwordFocusNode.addListener(() {
      setState(() {});
    });

    _newPasswordFocusNode = FocusNode();
    _newPasswordFocusNode.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _newPasswordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _newPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColorScheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColorScheme.appbarColor,
          centerTitle: true,
          title: Text(
            'Authorization Info',
            style: TextStyle(color: AppColorScheme.barTextColor),
          ),
          actions: [
            CircledButton(
                size: 30,
                margin: EdgeInsets.symmetric(horizontal: 4),
                iconColor: AppColorScheme.barTextColor,
                icon: widget.editMode ? Icons.edit_off : Icons.edit,
                onPressed: () => setState(() {
                      _switchEditMode();
                    }))
          ],
        ),
        body: GestureDetector(
          child: Stack(
            fit: StackFit.expand,
            children: [
              ListView(
                children: [
                  _fields(),
                  if (widget.editMode && _isNewPasswordShouldBeeVisible)
                    _passwordRequirements(),
                ],
              ),
              if (widget.editMode)
                Positioned(
                    child: Align(
                  alignment: Alignment.bottomCenter,
                  child: AppButton(
                      margin: EdgeInsets.only(bottom: 10),
                      text: 'SAVE',
                      textSize: 20,
                      textColor: _canSave
                          ? AppColorScheme.appbarColor
                          : AppColorScheme.disabledTextFieldColor,
                      buttonColor: AppColorScheme.backgroundColor,
                      borderColor: _canSave
                          ? AppColorScheme.appbarColor
                          : AppColorScheme.disabledTextFieldColor,
                      height: 70,
                      width: 150,
                      onPressed: () async {
                        if (_canSave) {
                          _saveChanges();
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
  }

  Widget _fields() {
    return Column(children: [
      AppTextField(
        readOnly: !widget.editMode || !_isEmailShouldBeeEditable,
        padding: EdgeInsets.all(10),
        fieldController: _emailController,
        fieldFocusNode: _emailFocusNode,
        maxLines: 1,
        cursorColor: AppColorScheme.enabledTextFieldColor,
        textColor: _emailFocusNode.hasFocus || _emailController.text.length > 0
            ? AppColorScheme.enabledTextFieldColor
            : AppColorScheme.disabledTextFieldColor,
        labelText: "Email",
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
            if (_emailRegExp.hasMatch(value)) {
              _isEmailValid = true;
            } else {
              _isEmailValid = false;
            }
            checkFields();
          });
        },
      ),
      if (!widget.editMode)
        Center(
          child: Text(
            'Please switch to edit mode to change your password',
            style: TextStyle(color: AppColorScheme.appbarColor),
          ),
        ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
              child: AppTextField(
            readOnly: !widget.editMode,
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
            labelText: "Password",
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
      if (_isNewPasswordShouldBeeVisible)
        Row(
          children: [
            Flexible(
                child: AppTextField(
              readOnly: !widget.editMode,
              obscureText: _isNewPasswordObscured,
              autocorrect: false,
              enableSuggestions: false,
              padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
              fieldController: _newPasswordController,
              fieldFocusNode: _newPasswordFocusNode,
              maxLines: 1,
              cursorColor: AppColorScheme.enabledTextFieldColor,
              textColor: _newPasswordFocusNode.hasFocus ||
                      _newPasswordController.text.length > 0
                  ? AppColorScheme.enabledTextFieldColor
                  : AppColorScheme.disabledTextFieldColor,
              labelText: "New password",
              labelColor: _newPasswordFocusNode.hasFocus ||
                      _newPasswordController.text.length > 0
                  ? AppColorScheme.enabledTextFieldColor
                  : AppColorScheme.disabledTextFieldColor,
              enabledBorderColor: AppColorScheme.enabledTextFieldColor,
              disabledBorderColor: _newPasswordController.text.length > 0
                  ? AppColorScheme.enabledTextFieldColor
                  : AppColorScheme.disabledTextFieldColor,
              errorText:
                  _isNewPasswordValid || _newPasswordController.text.isEmpty
                      ? null
                      : "Invalid password",
              onChanged: (value) {
                setState(() {
                  _isNewPasswordValid = _isPasswordCompliant(value);
                  checkFields();
                });
              },
            )),
            CircledButton(
                size: 40,
                icon: _isNewPasswordObscured
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                iconColor: _newPasswordFocusNode.hasFocus ||
                        _newPasswordController.text.length > 0
                    ? AppColorScheme.enabledTextFieldColor
                    : AppColorScheme.disabledTextFieldColor,
                onPressed: () {
                  setState(() {
                    _isNewPasswordObscured = !_isNewPasswordObscured;
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

  void checkFields() {
    if (_passwordController.text.isNotEmpty &&
        (_isEmailValid && _emailController.text != _oldEmail ||
            _passwordController.text != _newPasswordController.text &&
                _newPasswordController.text.isNotEmpty &&
                _isNewPasswordValid)) {
      _canSave = true;
    } else {
      _canSave = false;
    }
    if (_emailController.text != _oldEmail) {
      _isNewPasswordShouldBeeVisible = false;
    } else {
      _isNewPasswordShouldBeeVisible = true;
    }
    if (_newPasswordController.text.isNotEmpty) {
      _isEmailShouldBeeEditable = false;
    } else {
      _isEmailShouldBeeEditable = true;
    }
  }

  void _saveChanges() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: AppColorScheme.backgroundColor,
            title: Text(
              _isEmailShouldBeeEditable
                  ? 'Are you sure you want to change your email address?'
                  : _isNewPasswordShouldBeeVisible
                      ? 'Are you sure you want to change your password?'
                      : '',
              style: TextStyle(
                color: AppColorScheme.appbarColor,
              ),
            ),
            actions: [
              AppButton(
                  text: 'YES',
                  buttonColor: AppColorScheme.appbarColor,
                  textColor: AppColorScheme.barTextColor,
                  onPressed: () async {
                    if (_isEmailShouldBeeEditable) {
                      await _fbAuth
                          .changeEmail(_oldEmail, _passwordController.text,
                              _emailController.text)
                          .then((result) {
                        Navigator.of(context).pop();
                        fbAuthSuccessErrorMessage(
                            result: result,
                            context: context,
                            successText: 'Email changed successfully!',
                            successAction: () {
                              _oldEmail = _emailController.text;
                              _switchEditMode();
                            });
                      });
                    } else if (_isNewPasswordShouldBeeVisible) {
                      await _fbAuth
                          .changePassword(_oldEmail, _passwordController.text,
                              _newPasswordController.text)
                          .then((result) {
                        fbAuthSuccessErrorMessage(
                            result: result,
                            context: context,
                            successText: 'Password changed successfully!',
                            successAction: () {
                              _switchEditMode();
                            },
                            onPopAction: (context) {
                              Navigator.of(context, rootNavigator: true)
                                ..pop()
                                ..pop();
                            });
                      });
                    }
                  }),
              AppButton(
                  text: 'NO',
                  buttonColor: AppColorScheme.appbarColor,
                  textColor: AppColorScheme.barTextColor,
                  onPressed: () => Navigator.of(context).pop())
            ],
          );
        });
  }

  void _switchEditMode() {
    if (widget.editMode) {
      _isEmailShouldBeeEditable = true;
      _isNewPasswordShouldBeeVisible = true;
      _emailController.text = _oldEmail;
      _passwordController.text = '';
      _newPasswordController.text = '';
    }
    widget.editMode = !widget.editMode;
  }
}
