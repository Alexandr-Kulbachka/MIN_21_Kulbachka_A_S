import 'package:HelpHere/components/app_button.dart';
import 'package:HelpHere/components/app_card.dart';
import 'file:///C:/Users/Alexandr_Kulbachka/pet_projects/HelpHere/lib/components/dialogs/ok_dialog.dart';
import 'package:HelpHere/models/admin_account_code.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../components/circled_button.dart';
import '../../../../style/app_color_scheme.dart';
import '../../../../app/services/account_service.dart';
import '../../../../app/services/admin_account_code_service.dart';

class GenerateAdminCodePage extends StatefulWidget {
  GenerateAdminCodePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GenerateAdminCodePageState();
}

class _GenerateAdminCodePageState extends State<GenerateAdminCodePage> {
  FocusNode _adminAccountCodeFocusNode;

  AccountService _accountService;
  Uuid _uuid;

  @override
  void initState() {
    _uuid = Uuid();
    _accountService = Provider.of<AccountService>(context, listen: false);

    Provider.of<AdminAccountCodeService>(context, listen: false)
        .loadCodes(authorId: _accountService.account.id);

    _adminAccountCodeFocusNode = FocusNode();
    _adminAccountCodeFocusNode.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AccountService, AdminAccountCodeService>(
        builder: (context, accountService, adminAccountCodeService, child) {
      var codes = adminAccountCodeService.generatedCodes;
      return Scaffold(
          backgroundColor: AppColorScheme.backgroundColor,
          appBar: AppBar(
            backgroundColor: AppColorScheme.appbarColor,
            title: Text(
              'Generate code for registering an admin account',
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
          body: GestureDetector(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppButton(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    text: 'GENERATE NEW CODE',
                    textSize: 20,
                    textColor: AppColorScheme.textColor,
                    buttonColor: AppColorScheme.backgroundColor,
                    height: 60,
                    width: 300,
                    onPressed: () async {
                      if (codes.length < 10) {
                        await adminAccountCodeService.addNewCode(
                            adminAccountCode: AdminAccountCode(
                                authorId: accountService.account.id,
                                accountCode: _uuid.v1()));
                      } else {
                        showOkDialog(
                            context: context,
                            message:
                                'The number of simultaneously created new codes for registering administrator accounts is limited to ten');
                      }
                    }),
                Divider(
                  height: 1,
                  color: AppColorScheme.appbarColor,
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    'Tap on code to copy',
                    style: TextStyle(
                        color: AppColorScheme.appbarColor, fontSize: 15),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: codes.length,
                    itemBuilder: (context, index) {
                      return AppCard(Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: GestureDetector(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 15),
                                  child: Text(
                                    '${index + 1}.',
                                    style: TextStyle(
                                        color: AppColorScheme.barTextColor,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                              Text(
                                '${codes[index].accountCode}',
                                style: TextStyle(
                                    color: AppColorScheme.barTextColor,
                                    fontSize: 15),
                              ),
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: CircledButton(
                                      size: 30,
                                      iconColor: AppColorScheme.barTextColor,
                                      icon: Icons.delete_outline,
                                      onPressed: () async {
                                        showDialog(
                                            context: context,
                                            builder: (cxt) {
                                              return AlertDialog(
                                                backgroundColor: AppColorScheme
                                                    .backgroundColor,
                                                title: Text(
                                                  'Are you sure you want to delete the code?',
                                                  style: TextStyle(
                                                    color: AppColorScheme
                                                        .textColor,
                                                  ),
                                                ),
                                                actions: [
                                                  AppButton(
                                                      text: 'YES',
                                                      buttonColor:
                                                          AppColorScheme
                                                              .appbarColor,
                                                      textColor: AppColorScheme
                                                          .barTextColor,
                                                      onPressed: () async {
                                                        await adminAccountCodeService
                                                            .deleteCode(
                                                                codeDocumentId:
                                                                    codes[index]
                                                                        .documentId);
                                                        Navigator.of(context)
                                                            .pop();
                                                      }),
                                                  AppButton(
                                                      text: 'NO',
                                                      buttonColor:
                                                          AppColorScheme
                                                              .appbarColor,
                                                      textColor: AppColorScheme
                                                          .barTextColor,
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      })
                                                ],
                                              );
                                            });
                                      })),
                            ],
                          ),
                          onTap: () async {
                            await Clipboard.setData(
                                ClipboardData(text: codes[index].accountCode));
                            Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text('Admins account code copied')));
                          },
                        ),
                      ));
                    },
                  ),
                )
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
}
