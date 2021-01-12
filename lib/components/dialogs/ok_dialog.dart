import 'package:HelpHere/style/app_color_scheme.dart';
import 'package:flutter/material.dart';

import '../app_button.dart';

void showOkDialog(
    {@required BuildContext context,
    @required String message,
    bool isShouldPop = false}) {
  showDialog(
      context: context,
      builder: (cxt) {
        return AlertDialog(
          backgroundColor: AppColorScheme.backgroundColor,
          title: Text(
            message,
            style: TextStyle(
              color: AppColorScheme.textColor,
            ),
          ),
          actions: [
            AppButton(
                text: 'OK',
                buttonColor: AppColorScheme.appbarColor,
                textColor: AppColorScheme.barTextColor,
                onPressed: () {
                  Navigator.of(cxt).pop();
                  if (isShouldPop) {
                    Navigator.of(context).pop();
                  }
                })
          ],
        );
      });
}
