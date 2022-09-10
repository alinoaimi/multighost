import 'dart:convert';
import 'dart:io';

import 'package:app/data/MultipassImage.dart';
import 'package:app/screens/ProcessWithProgressDialog.dart';
import 'package:app/screens/create_instance_steps/NameImageStep.dart';
import 'package:app/screens/create_instance_steps/NetworkStep.dart';
import 'package:app/screens/create_instance_steps/PlaceholderStep.dart';
import 'package:app/screens/create_instance_steps/ResourcesStep.dart';
import 'package:app/widgets/EmptyWidget.dart';
import 'package:app/widgets/ImageSelector.dart';
import 'package:app/widgets/ParentStepChild.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/MultipassInstanceObject.dart';
import '../utils/GlobalUtils.dart';
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
  List<dynamic> stepsData = [];

  bool isCreating = false;
  int currentStep = 0;
  String runEventText = 'loading...';

  createInstance() async {



    isCreating = true;
    setState(() {});

    String command = 'launch';

    // image
    command += ' ';
    command += stepsData[0]['image'];

    // name
    command += ' --name ';
    command += stepsData[0]['name'];

    // cpus
    command += ' --cpus ';
    command += stepsData[1]['cpus'].toString();

    // mem
    command += ' --mem ';
    command += stepsData[1]['mem'].toString();

    // disk
    command += ' --disk ';
    command += stepsData[1]['disk'].toString();

    debugPrint(stepsData[0].toString());
    debugPrint(command);

    // var process = await Process.start(GlobalUtils.multipassPath, command.split(' '));
    // // process.stdout.pipe(stdout);
    //
    // process.stdout.listen((event) {
    //   debugPrint('received event: ');
    //   debugPrint(utf8.decode(event));
    // });

    isCreating = false;
    setState(() {});
    Get.back();

    Get.dialog(
      ProcessWithProgressDialog(title: 'Creating '+stepsData[0]['name'], command: GlobalUtils.multipassPath, args: command.split(' '))
    );




  }

  @override
  void initState() {
    super.initState();
    setSteps();
  }

  StepState getStepState(stepIndex) {
    if (currentStep == stepIndex) {
      return StepState.editing;
    } else if (currentStep > stepIndex) {
      return StepState.complete;
    }

    return StepState.indexed;
  }

  final GlobalKey stepOneKey = GlobalKey();

  List<ParentStepChild> stepsWidgets = [];

  setSteps() {

    stepsWidgets.add(NameImageStep(
      onDataAvailable: (data) {
        debugPrint(data.toString());
        stepsData[0] = data;
      },
    ));
    stepsData.add({});
    stepsWidgets.add(ResourcesStep(
      onDataAvailable: (data) {
        // debugPrint('received data for step 1');
        // debugPrint(data.toString());
        stepsData[1] = data;
      },
    ));
    stepsData.add({});
    stepsWidgets.add(NetworkStep());
    stepsData.add({});


  }

  refreshStepper() {
    steps = [];
    steps.add(Step(
        title: Text('Image'),
        isActive: currentStep >= 0,
        state: getStepState(0),
        content: stepsWidgets[0]));
    steps.add(Step(
        title: Text('Resources'),
        isActive: currentStep >= 1,
        state: getStepState(1),
        content: stepsWidgets[1]));
    // steps.add(Step(
    //     title: Text('Network'),
    //     isActive: currentStep >= 2,
    //     state: getStepState(2),
    //     content: stepsWidgets[2]));
  }


  @override
  Widget build(BuildContext context) {

    refreshStepper();

    List<Widget> bodyChildren = [];


    var stepper = Stepper(
      steps: steps,
      type: StepperType.horizontal,
      currentStep: currentStep,
      elevation: 1,
      // physics: BouncingScrollPhysics(),
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
            createInstance();
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
            if(((steps[currentStep].content) as ParentStepChild).canNext()) {
              currentStep++;
              setState(() {});
            }
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
      height: 450,
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
