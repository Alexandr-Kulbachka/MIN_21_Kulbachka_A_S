import "package:provider/provider.dart";
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../style/app_color_scheme.dart';
import '../../app/firebase/firebase_db.dart';
import '../../app/regexp/regexp.dart';
import '../../app/services/help_requests_service.dart';
import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../components/dialogs/fb_auth_success_error_message.dart';
import '../../models/help_request.dart';

class NewHelpRequest extends StatefulWidget {
  NewHelpRequest({Key key}) : super(key: key);

  @override
  _NewHelpRequestState createState() => _NewHelpRequestState();
}

class _NewHelpRequestState extends State<NewHelpRequest> {
  FBDataBase _fbDataBase;

  TextEditingController _candidatesNameController;
  TextEditingController _candidatesPatronymicController;
  TextEditingController _candidatesSurnameController;
  TextEditingController _candidatesAgeController;
  TextEditingController _phoneNumberController;
  TextEditingController _emailController;
  TextEditingController _addressController;
  TextEditingController _descriptionController;

  FocusNode _candidatesNameFocusNode;
  FocusNode _candidatesPatronymicFocusNode;
  FocusNode _candidatesSurnameFocusNode;
  FocusNode _candidatesAgeFocusNode;
  FocusNode _phoneNumberFocusNode;
  FocusNode _emailFocusNode;
  FocusNode _addressFocusNode;
  FocusNode _descriptionFocusNode;

  bool _isCandidatesAgeValid = false;
  bool _isPhoneNumberValid = false;
  bool _isEmailValid = false;

  bool _canSave = false;

  @override
  void initState() {
    _fbDataBase = FBDataBase.getInstance();

    _candidatesNameController = TextEditingController();
    _candidatesPatronymicController = TextEditingController();
    _candidatesSurnameController = TextEditingController();
    _candidatesAgeController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _descriptionController = TextEditingController();

    _candidatesNameFocusNode = FocusNode();
    _candidatesNameFocusNode.addListener(() {
      setState(() {});
    });

    _candidatesPatronymicFocusNode = FocusNode();
    _candidatesPatronymicFocusNode.addListener(() {
      setState(() {});
    });

    _candidatesSurnameFocusNode = FocusNode();
    _candidatesSurnameFocusNode.addListener(() {
      setState(() {});
    });

    _candidatesAgeFocusNode = FocusNode();
    _candidatesAgeFocusNode.addListener(() {
      setState(() {});
    });

    _phoneNumberFocusNode = FocusNode();
    _phoneNumberFocusNode.addListener(() {
      setState(() {});
    });

    _emailFocusNode = FocusNode();
    _emailFocusNode.addListener(() {
      setState(() {});
    });

    _addressFocusNode = FocusNode();
    _addressFocusNode.addListener(() {
      setState(() {});
    });

    _descriptionFocusNode = FocusNode();
    _descriptionFocusNode.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _candidatesNameController.dispose();
    _candidatesPatronymicController.dispose();
    _candidatesSurnameController.dispose();
    _candidatesAgeController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();

    _candidatesNameFocusNode.dispose();
    _candidatesPatronymicFocusNode.dispose();
    _candidatesSurnameFocusNode.dispose();
    _candidatesAgeFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _emailFocusNode.dispose();
    _addressFocusNode.dispose();
    _descriptionFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HelpRequestsService>(
        builder: (context, helpRequestsService, child) {
      return Scaffold(
          backgroundColor: AppColorScheme.backgroundColor,
          appBar: AppBar(
            backgroundColor: AppColorScheme.appbarColor,
            centerTitle: true,
            title: Text('New Help Request'),
          ),
          body: GestureDetector(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ListView(
                  children: [
                    Center(
                      child: Text(
                        'Please enter the details of someone who needs help.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColorScheme.appbarColor, fontSize: 16),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Required fields are marked '*'",
                        textAlign: TextAlign.center,
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
                        text: 'CREATE REQUEST',
                        textSize: 20,
                        textColor: AppColorScheme.textColor,
                        buttonColor: AppColorScheme.backgroundColor,
                        height: 60,
                        width: 220,
                        onPressed: () async {
                          if (_canSave) {
                            var helpRequest = HelpRequest(
                                candidatesName: _candidatesNameController.text,
                                candidatesPatronymic:
                                    _candidatesPatronymicController.text,
                                candidatesSurname:
                                    _candidatesSurnameController.text,
                                candidatesAge:
                                    int.parse(_candidatesAgeController.text),
                                phoneNumber: _phoneNumberController.text,
                                email: _emailController.text,
                                address: _addressController.text,
                                description: _descriptionController.text);
                            var result = await _fbDataBase.addItem(
                                itemName: HelpRequest.nameInBase,
                                itemFields: helpRequest.getMap());
                            fbAuthSuccessErrorMessage(
                                result: result,
                                context: context,
                                successText:
                                    'Hew help request successfully created!',
                                onPopAction: (context) {
                                  Navigator.of(context, rootNavigator: true)
                                    ..pop()
                                    ..pop();
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
    return Container(
      margin: EdgeInsets.only(bottom: 75),
      child: Column(children: [
        AppTextField(
          padding: EdgeInsets.all(10),
          fieldController: _candidatesNameController,
          fieldFocusNode: _candidatesNameFocusNode,
          maxLines: 1,
          cursorColor: AppColorScheme.enabledTextFieldColor,
          textColor: _candidatesNameFocusNode.hasFocus ||
                  _candidatesNameController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          labelSize: 17,
          labelText: "Name*",
          labelColor: _candidatesNameFocusNode.hasFocus ||
                  _candidatesNameController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          enabledBorderColor: AppColorScheme.enabledTextFieldColor,
          disabledBorderColor: _candidatesNameController.text.length > 0
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
          fieldController: _candidatesPatronymicController,
          fieldFocusNode: _candidatesPatronymicFocusNode,
          maxLines: 1,
          cursorColor: AppColorScheme.enabledTextFieldColor,
          textColor: _candidatesPatronymicFocusNode.hasFocus ||
                  _candidatesPatronymicController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          labelSize: 17,
          labelText: "Patronymic*",
          labelColor: _candidatesPatronymicFocusNode.hasFocus ||
                  _candidatesPatronymicController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          enabledBorderColor: AppColorScheme.enabledTextFieldColor,
          disabledBorderColor: _candidatesPatronymicController.text.length > 0
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
          fieldController: _candidatesSurnameController,
          fieldFocusNode: _candidatesSurnameFocusNode,
          maxLines: 1,
          cursorColor: AppColorScheme.enabledTextFieldColor,
          textColor: _candidatesSurnameFocusNode.hasFocus ||
                  _candidatesSurnameController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          labelSize: 17,
          labelText: "Surname*",
          labelColor: _candidatesSurnameFocusNode.hasFocus ||
                  _candidatesSurnameController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          enabledBorderColor: AppColorScheme.enabledTextFieldColor,
          disabledBorderColor: _candidatesSurnameController.text.length > 0
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
          fieldController: _candidatesAgeController,
          fieldFocusNode: _candidatesAgeFocusNode,
          maxLines: 1,
          cursorColor: AppColorScheme.enabledTextFieldColor,
          textColor: _candidatesAgeFocusNode.hasFocus ||
                  _candidatesAgeController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          labelSize: 17,
          labelText: "Age*",
          labelColor: _candidatesAgeFocusNode.hasFocus ||
                  _candidatesAgeController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          enabledBorderColor: AppColorScheme.enabledTextFieldColor,
          disabledBorderColor: _candidatesAgeController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          errorText:
              _isCandidatesAgeValid || _candidatesAgeController.text.isEmpty
                  ? null
                  : "Invalid age",
          onChanged: (value) {
            setState(() {
              if (ageRegExp.hasMatch(value)) {
                _isCandidatesAgeValid = true;
              } else {
                _isCandidatesAgeValid = false;
              }
              _checkFields();
            });
          },
        ),
        AppTextField(
          keyboardType: TextInputType.phone,
          padding: EdgeInsets.all(10),
          fieldController: _phoneNumberController,
          fieldFocusNode: _phoneNumberFocusNode,
          maxLines: 1,
          cursorColor: AppColorScheme.enabledTextFieldColor,
          textColor: _phoneNumberFocusNode.hasFocus ||
                  _phoneNumberController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          labelSize: 17,
          labelText: "Phone number*(Visible only for admins)",
          labelColor: _phoneNumberFocusNode.hasFocus ||
                  _phoneNumberController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          enabledBorderColor: AppColorScheme.enabledTextFieldColor,
          disabledBorderColor: _phoneNumberController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          errorText: _isPhoneNumberValid || _phoneNumberController.text.isEmpty
              ? null
              : "Invalid phone number",
          onChanged: (value) {
            setState(() {
              if (phoneRegExp.hasMatch(value)) {
                _isPhoneNumberValid = true;
              } else {
                _isPhoneNumberValid = false;
              }
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
              if (emailRegExp.hasMatch(value)) {
                _isEmailValid = true;
              } else {
                _isEmailValid = false;
              }
              _checkFields();
            });
          },
        ),
        AppTextField(
          padding: EdgeInsets.all(10),
          fieldController: _addressController,
          fieldFocusNode: _addressFocusNode,
          maxLines: 1,
          cursorColor: AppColorScheme.enabledTextFieldColor,
          textColor:
              _addressFocusNode.hasFocus || _addressController.text.length > 0
                  ? AppColorScheme.enabledTextFieldColor
                  : AppColorScheme.disabledTextFieldColor,
          labelSize: 17,
          labelText: "Address(Visible only for admins)",
          labelColor:
              _addressFocusNode.hasFocus || _addressController.text.length > 0
                  ? AppColorScheme.enabledTextFieldColor
                  : AppColorScheme.disabledTextFieldColor,
          enabledBorderColor: AppColorScheme.enabledTextFieldColor,
          disabledBorderColor: _addressController.text.length > 0
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
          fieldController: _descriptionController,
          fieldFocusNode: _descriptionFocusNode,
          maxLines: null,
          cursorColor: AppColorScheme.enabledTextFieldColor,
          textColor: _descriptionFocusNode.hasFocus ||
                  _descriptionController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          labelSize: 17,
          labelText: "Description*",
          labelColor: _descriptionFocusNode.hasFocus ||
                  _descriptionController.text.length > 0
              ? AppColorScheme.enabledTextFieldColor
              : AppColorScheme.disabledTextFieldColor,
          enabledBorderColor: AppColorScheme.enabledTextFieldColor,
          disabledBorderColor: _descriptionController.text.length > 0
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

  void _checkFields() {
    if (_candidatesNameController.text != '' &&
        _candidatesPatronymicController.text != '' &&
        _candidatesSurnameController.text != '' &&
        _candidatesAgeController.text != '' &&
        _phoneNumberController.text != '' &&
        _descriptionController.text != '' &&
        (_isEmailValid || _emailController.text == '') &&
        _isPhoneNumberValid &&
        _isCandidatesAgeValid) {
      _canSave = true;
    } else {
      _canSave = false;
    }
  }
}
