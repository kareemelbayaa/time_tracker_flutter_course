import 'dart:ffi';

import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  final Color color;
  final VoidCallback onPressed;
  final Widget child;
  final double borderRadius;
  final double buttonHeight;

  CustomRaisedButton(
      {this.color,
      this.onPressed,
      this.child,
      this.borderRadius: 2.0,
      this.buttonHeight: 50.0})
      : assert(borderRadius != null);

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return SizedBox(
      height: buttonHeight,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              borderRadius,
            ),
          ),
        ),
        onPressed: onPressed,
        child: child,
        color: color,
        disabledColor: color,
      ),
    );
  }
}
