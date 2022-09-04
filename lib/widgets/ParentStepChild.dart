import 'package:flutter/material.dart';


class ParentStepChild extends StatefulWidget {

  // Constructor
  ParentStepChild({Key? key}) : super(key: key);


  ParentStepChildState _theState = ParentStepChildState();

  @override
  ParentStepChildState createState() => _theState;

  bool canNext() {
    return _theState.canNext();
  }

}

// FooState
class ParentStepChildState<T extends ParentStepChild> extends State<T> {

  bool canNext() {
    return true;
  }
  // Override build
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}