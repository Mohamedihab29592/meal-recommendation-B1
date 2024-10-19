import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CustomPinCodeTextField extends StatelessWidget {
  final BuildContext context;
  final int length;
  final PinCodeFieldShape shape;
  final BorderRadius borderRadius;
  final double fieldHeight;
  final double fieldWidth;
  final Color activeFillColor;
  final Function(String) onChanged;

  const CustomPinCodeTextField({
    super.key,
    required this.context,
    this.length = 4,
    this.shape = PinCodeFieldShape.box,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.fieldHeight = 50.0,
    this.fieldWidth = 40.0,
    this.activeFillColor = Colors.white,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: length,
      onChanged: onChanged,
      pinTheme: PinTheme(
        shape: shape,
        borderRadius: borderRadius,
        fieldHeight: fieldHeight,
        fieldWidth: fieldWidth,
        activeFillColor: activeFillColor,
      ),
    );
  }
}