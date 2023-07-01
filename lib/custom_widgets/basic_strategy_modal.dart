import 'package:flutter/material.dart';

class BasicStrategyDialog extends StatelessWidget {
  const BasicStrategyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
          width: 180,
          height: 400,
          child: Image.asset("assets/images/basic_strategy_chart.jpg")),
    );
  }
}
