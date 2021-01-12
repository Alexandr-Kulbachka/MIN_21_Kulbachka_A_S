import 'dart:async';

import 'file:///C:/Users/Alexandr_Kulbachka/pet_projects/HelpHere/lib/components/dialogs/ok_dialog.dart';
import 'package:HelpHere/style/app_color_scheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

Future<void> fbAuthSuccessErrorMessage(
    {dynamic result,
    bool isShouldPopIfError = false,
    BuildContext context,
    String successText,
    Function successAction,
    Function errorAction,
    Function(BuildContext context) onPopAction}) async {
  if (!(result is FirebaseAuthException) && !(result is bool && !result)) {
    if (successText != null) {
      showDialog(
          context: context,
          builder: (cxt) {
            if (successAction != null) {
              successAction();
            }
            SchedulerBinding.instance.addPostFrameCallback(
                (_) => Future.delayed(Duration(seconds: 1), () {
                      if (onPopAction != null) {
                        onPopAction(context);
                      } else {
                        Navigator.of(cxt).pop();
                      }
                    }));
            return (AlertDialog(
              backgroundColor: AppColorScheme.backgroundColor,
              title: Text(
                successText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColorScheme.textColor,
                ),
              ),
            ));
          });
    } else {
      successAction();
    }
  } else if (result is FirebaseAuthException) {
    if (errorAction != null) {
      errorAction();
    }
    showOkDialog(context: context, message: result.message, isShouldPop: isShouldPopIfError);
  }
}
