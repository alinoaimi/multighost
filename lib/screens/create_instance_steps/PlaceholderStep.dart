import 'package:flutter/material.dart';

import '../../widgets/ParentStepChild.dart';

class PlaceholderStep extends ParentStepChild {
  PlaceholderStep({Key? key}) : super(key: key);

  @override
  ParentStepChildState<PlaceholderStep> createState() => _PlaceholderStepState();
}

class _PlaceholderStepState extends ParentStepChildState<PlaceholderStep> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('this step is empty'),
    );
  }
}
