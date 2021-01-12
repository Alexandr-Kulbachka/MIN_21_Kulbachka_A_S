import 'package:HelpHere/style/app_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final EdgeInsets margin;
  final EdgeInsets padding;
  final String text;
  final double textSize;
  final Color buttonColor;
  final Color borderColor;
  final Color textColor;
  final double height;
  final double width;
  final dynamic Function() onPressed;

  AppButton({
    this.margin,
    this.padding,
    this.buttonColor,
    this.textColor,
    this.borderColor,
    this.text,
    this.textSize,
    this.height = 0,
    this.width = 0,
    @required this.onPressed,
  });

  bool _isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height != 0 ? height : 40,
      width: width != 0 ? width : 150,
      decoration: BoxDecoration(
          border: Border.all(
              width: 2,
              color: _isButtonPressed
                  ? Colors.grey
                  : borderColor != null
                      ? borderColor
                      : AppColorScheme.appbarColor),
          borderRadius: BorderRadius.circular(10)),
      margin: margin ?? EdgeInsets.all(0),
      padding: padding ?? EdgeInsets.all(0),
      child: RaisedButton(
        color: _isButtonPressed ? Colors.grey : buttonColor,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _isButtonPressed ? Colors.grey : textColor,
            fontSize: textSize,
          ),
        ),
        onPressed: () async {
          if (!_isButtonPressed) {
            _isButtonPressed = true;
            await onPressed();
            _isButtonPressed = false;
          }
        },
      ),
    );
  }
}
