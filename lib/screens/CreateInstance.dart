import 'dart:convert';
import 'dart:io';

import 'package:app/data/MultipassImage.dart';
import 'package:app/screens/create_instance_steps/NameImageStep.dart';
import 'package:app/widgets/EmptyWidget.dart';
import 'package:app/widgets/ImageSelector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/MultipassInstanceObject.dart';
import '../widgets/ParentDialog.dart';

class CreateInstance extends StatefulWidget {
  String? instanceName;
  VoidCallback? onCreated;

  CreateInstance({Key? key, this.instanceName, this.onCreated})
      : super(key: key);

  @override
  State<CreateInstance> createState() => _CreateInstanceState();
}

class _CreateInstanceState extends State<CreateInstance> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _aliasController = TextEditingController();
  TextEditingController _commandController = TextEditingController();

  List<Step> steps = [];

  bool isCreating = false;
  int currentStep = 0;

  CreateInstance() async {
    isCreating = true;
    setState(() {});

    // var result = await Process.run('multipass', [
    //   'alias',
    //   '${selectedImage}:${_commandController.text}',
    //   _aliasController.text
    // ]);
    // debugPrint(result.stdout);

    isCreating = false;
    setState(() {});

    if (widget.onCreated != null) {
      widget.onCreated!();
      Get.back();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  StepState getStepState(stepIndex) {
    if (currentStep == stepIndex) {
      return StepState.editing;
    } else if (currentStep > stepIndex) {
      return StepState.complete;
    }

    return StepState.indexed;
  }

  setSteps() {
    steps = [];
    steps.add(Step(
        title: Text('Image'),
        isActive: currentStep >= 0,
        state: getStepState(0),
        content: Expanded(
          height: 500,
          child: NameImageStep(),
        )));
    steps.add(Step(
        title: Text('Resources'),
        isActive: currentStep >= 1,
        state: getStepState(1),
        content: Text('resources step')));
    steps.add(Step(
        title: Text('Network'),
        isActive: currentStep >= 2,
        state: getStepState(2),
        content: Text('network')));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> bodyChildren = [];

    setSteps();

    var stepper = Stepper(
      steps: steps,
      type: StepperType.horizontal,
      currentStep: currentStep,
      elevation: 1,
      controlsBuilder: (context, details) {
        return const EmptyWidget();
      },
      onStepContinue: currentStep >= (steps.length - 1)
          ? null
          : () {
              currentStep++;
              setState(() {});
            },
      onStepCancel: () {
        Get.back();
      },
    );

    List<Widget> actions = [];

    if (currentStep == steps.length-1) {
      actions.add(ElevatedButton(
          onPressed: isCreating
              ? null
              : () {
            if (_formKey.currentState!.validate()) {
              // If the form is valid, display a snackbar. In the real world,
              // you'd often call a server or save the information in a database.
              CreateInstance();
            }
          },
          child: isCreating
              ? const SizedBox(
            height: 15,
            width: 15,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : const Text('Create')));
    }

    if (currentStep < steps.length-1) {
      actions.add(ElevatedButton(
          onPressed: () {
            currentStep++;
            setState(() {});
          },
          child: const Text('Next')));
    }

    if (currentStep > 0) {
      actions.add(TextButton(
          onPressed: () {
            currentStep--;
            setState(() {});
          },
          child: const Text('Back')));
    }


    var body = SizedBox(
      height: 500,
      child: stepper,
    );

    return ParentDialog(
        title: 'Create an Instance',
        childPadding: 0,
        // hideActions: true,
        actions: actions,
        child: body);
  }
}
