import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/main.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    super.key,
    required this.roundedButtonTitle,
    required this.roundedButtonColor,
    required this.roundedButtonOnPressed,
  });

  final Color roundedButtonColor;
  final String roundedButtonTitle;
  final Function roundedButtonOnPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: roundedButtonColor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: roundedButtonOnPressed(),
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            roundedButtonTitle,
          ),
        ),
      ),
    );
  }
}
