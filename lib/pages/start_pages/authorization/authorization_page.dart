import 'package:HelpHere/app/services/account_service.dart';
import 'file:///C:/Users/Alexandr_Kulbachka/pet_projects/HelpHere/lib/components/dialogs/ok_dialog.dart';
import 'package:HelpHere/enums/roles_enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/firebase/firebase_auth.dart';
import '../../../components/app_text_field.dart';
import '../../../components/circled_button.dart';
import '../../../components/app_button.dart';
import '../../../components/dialogs/fb_auth_success_error_message.dart';
import '../../../style/app_color_scheme.dart';

class Authorization extends StatefulWidget {
  Authorization({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AuthorizationState();
}

class _AuthorizationState extends State<Authorization> {
  FBAuth _fbAuth;

  TextEditingController _emailController;
  TextEditingController _passwordController;

  FocusNode _emailFocusNode;
  FocusNode _passwordFocusNode;

  bool _isEmailValid = false;
  bool _isPasswordValid = true;

  bool _isPasswordObscured = true;

  RegExp _emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  bool _allFieldsFilled = false;

  @override
  void initState() {
    _fbAuth = FBAuth.getInstance();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _emailFocusNode = FocusNode();
    _emailFocusNode.addListener(() {
      setState(() {});
    });

    _passwordFocusNode = FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountService>(builder: (context, accountService, child) {
      return Scaffold(
          backgroundColor: AppColorScheme.backgroundColor,
          appBar: AppBar(
            backgroundColor: AppColorScheme.appbarColor,
            centerTitle: true,
            title: Text('Authorization'),
          ),
          body: GestureDetector(
            child: Stack(
              fit: StackFit.expand,
              children: [
                _fields(),
                if (_allFieldsFilled)
                  Positioned(
                      child: Align(
                    alignment: Alignment.bottomCenter,
                    child: AppButton(
                        margin: EdgeInsets.only(bottom: 10),
                        text: 'SIGN IN',
                        textSize: 20,
                        textColor: AppColorScheme.textColor,
                        buttonColor: AppColorScheme.backgroundColor,
                        height: 70,
                        width: 150,
                        onPressed: () async {
                          if (_allFieldsFilled) {
                            var result =
                                await _fbAuth.signInWithEmailAndPassword(
                                    _emailController.text,
                                    _passwordController.text);
                            if (result is String) {
                              await accountService.loadAccount(
                                id: result,
                              );
                              if (accountService.account == null) {
                                await _fbAuth.deleteAccount();
                                showOkDialog(
                                    context: context,
                                    message:
                                        'Your volunteering request has been declined. This account has been deleted');
                                return;
                              }
                            }

                            fbAuthSuccessErrorMessage(
                                result: result,
                                context: context,
                                successAction: () {
                                  if (accountService.account.role ==
                                      Role.admin) {
                                    Navigator.of(context).pushReplacementNamed(
                                        '/admin_navigation');
                                  } else {
                                    Navigator.of(context).pushReplacementNamed(
                                        '/volunteer_navigation');
                                  }
                                },
                                errorAction: () => _handleErrors(result.code));
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

  void _handleErrors(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        setState(() {
          _isEmailValid = false;
        });
        break;
      case 'wrong-password':
        setState(() {
          _isPasswordValid = false;
        });
        break;
    }
  }

  Widget _fields() {
    return Column(children: [
      AppTextField(
        padding: EdgeInsets.all(10),
        fieldController: _emailController,
        fieldFocusNode: _emailFocusNode,
        maxLines: 1,
        cursorColor: AppColorScheme.appbarColor,
        textColor: _emailFocusNode.hasFocus || _emailController.text.length > 0
            ? AppColorScheme.enabledTextFieldColor
            : AppColorScheme.disabledTextFieldColor,
        labelText: "Input email",
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
            cursorColor: AppColorScheme.appbarColor,
            textColor: _passwordFocusNode.hasFocus ||
                    _passwordController.text.length > 0
                ? AppColorScheme.enabledTextFieldColor
                : AppColorScheme.disabledTextFieldColor,
            labelText: "Input password",
            labelColor: _passwordFocusNode.hasFocus ||
                    _passwordController.text.length > 0
                ? AppColorScheme.enabledTextFieldColor
                : AppColorScheme.disabledTextFieldColor,
            enabledBorderColor: AppColorScheme.enabledTextFieldColor,
            disabledBorderColor: _passwordController.text.length > 0
                ? AppColorScheme.enabledTextFieldColor
                : AppColorScheme.disabledTextFieldColor,
            errorText: _isPasswordValid ? null : "Invalid password",
            onChanged: (value) {
              setState(() {
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
    ]);
  }

  void checkFields() {
    _isPasswordValid = true;
    if (_isEmailValid &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      _allFieldsFilled = true;
    } else {
      _allFieldsFilled = false;
    }
  }
}
