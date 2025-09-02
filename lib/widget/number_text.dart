import 'package:flutter/material.dart';

import '../../common/color_standard.dart';

class NumberText extends StatelessWidget {
  final String number;
  final double integerFontSize;
  final double decimalFontSize;

  const NumberText({
    super.key,
    required this.number,
    required this.integerFontSize,
    required this.decimalFontSize,
  });

  @override
  Widget build(BuildContext context) {
    final parts = number.split('.');
    final integerPart = parts[0];
    final decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: integerPart,
            style: TextStyle(
              fontSize: integerFontSize,
              fontWeight: FontWeight.w600,
              color: ColorStandard.color232529,
            ),
          ),
          TextSpan(
            text: decimalPart,
            style: TextStyle(
                fontSize: decimalFontSize,
                color: ColorStandard.color232529,
                fontWeight: FontWeight.w600
            ),
          ),
        ],
      ),
    );
  }
}