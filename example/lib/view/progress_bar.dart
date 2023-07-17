import 'package:flutter/material.dart';

class ProgressBarIndicator extends StatelessWidget {
  const ProgressBarIndicator({
    Key? key,
    required this.progress,
  }) : super(key: key);

  final double progress;

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: progress,
      valueColor: const AlwaysStoppedAnimation<Color>(
        Colors.white,
      ),
      backgroundColor: Colors.grey,
    );
  }
}
