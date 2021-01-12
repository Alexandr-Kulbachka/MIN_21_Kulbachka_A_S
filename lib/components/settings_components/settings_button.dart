import 'package:HelpHere/style/app_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_card.dart';

class SettingsButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onTap;

  SettingsButton({this.title, this.icon, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AppCard(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                margin: EdgeInsets.all(15),
                child: Icon(
                  icon,
                  color: AppColorScheme.barTextColor,
                  size: 40,
                )),
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: AppColorScheme.barTextColor, fontSize: 20),
              ),
            ),
            Container(
                margin: EdgeInsets.all(15),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: AppColorScheme.barTextColor,
                  size: 25,
                ))
          ],
        ),
        color: AppColorScheme.appbarColor,
      ),
      onTap: onTap,
    );
  }
}
