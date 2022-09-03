import 'package:flutter/material.dart';

class ParentStepChild extends StatefulWidget {
  final Widget child;

  ParentStepChild({Key? key, required this.child}) : super(key: key);

  final _ParentStepChildState theState = _ParentStepChildState();

  @override
  State<ParentStepChild> createState() => theState;

  bool canNext(){
    return theState.canNext();
  }

}

class _ParentStepChildState extends State<ParentStepChild> {

  bool canNext() {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
