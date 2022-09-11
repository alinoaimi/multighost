import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';

class NativeStepperStep {
  final String id;
  final String title;
  final Widget content;

  NativeStepperStep(
      {required this.id, required this.title, required this.content});
}

class NativeStepper extends StatefulWidget {
  final List<NativeStepperStep> steps;

  const NativeStepper({Key? key, required this.steps}) : super(key: key);

  @override
  State<NativeStepper> createState() => _NativeStepperState();
}

class _NativeStepperState extends State<NativeStepper> {

  int activeStep = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> stepsWidgets = [];

    int index = -1;
    for (NativeStepperStep step in widget.steps) {
      index++;

      var circle = Container(
        decoration: const BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle
        ),
        height: 30,
        width: 30,
        child: Center(
          child: Text((index+1).toString()),
        ),
      );

      stepsWidgets.add(Column(
        children: [circle, Text(step.title)],
      ));

      if (index != (widget.steps.length - 1)) {
        stepsWidgets.add(Expanded(
          child: Center(
            child: Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              color: MacosTheme.brightnessOf(context).resolve(
                const Color.fromRGBO(0, 0, 0, 0.25),
                const Color.fromRGBO(255, 255, 255, 0.25),
              ),
              height: 1,
              width: double.infinity,
            ),
          ),
        ));
      }
    }

    var stepsContainer = Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: stepsWidgets,
      ),
    );

    var activeStepContent = Material(
      child: widget.steps[activeStep].content,
    );

    return Column(
      children: [stepsContainer, activeStepContent],
    );
  }
}
