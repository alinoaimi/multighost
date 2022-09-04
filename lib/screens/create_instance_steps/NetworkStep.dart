import 'package:app/widgets/ParentStepChild.dart';
import 'package:flutter/material.dart';

class NetworkStep extends ParentStepChild {
  NetworkStep({Key? key}) : super(key: key);

  @override
  ParentStepChildState<NetworkStep> createState() => _NetworkStepState();
}

class _NetworkStepState extends ParentStepChildState<NetworkStep> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('coming soon'),
      ),
    );
  }
}
