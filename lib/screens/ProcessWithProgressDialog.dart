import 'dart:convert';
import 'dart:io';

import 'package:app/widgets/ParentDialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProcessWithProgressDialog extends StatefulWidget {
  final String command;
  List<String> args;
  String title;

  ProcessWithProgressDialog(
      {Key? key,
      required this.title,
      required this.command,
      required this.args})
      : super(key: key);

  @override
  State<ProcessWithProgressDialog> createState() =>
      _ProcessWithProgressDialogState();
}

class _ProcessWithProgressDialogState extends State<ProcessWithProgressDialog> {
  String progressText = 'initializing...';
  String status = 'running';

  late Process process;

  runCommand() async {
    process = await Process.start(widget.command, widget.args);
    // process.stdout.pipe(stdout);

    process.stdout.listen((event) {
      // debugPrint('received event: ');

      if (event.contains(8)) {
        if(progressText.isNotEmpty) {
          progressText = progressText.substring(0, progressText.length - 1);
        }
      }

      // debugPrint(utf8.decode(event));
      // debugPrint(event.toString());

      String decoded = utf8.decode(event.where((element) => element != 8).toList());

      progressText += decoded;

      progressText = progressText.replaceAll('Launched: ', "\n"
          "Launched: "
          "");

      if(progressText.contains('Launched:')) {
        status = 'complete';
      }
      setState(() {});
    }, onDone: () {
      status = 'complete';
      setState(() {

      });
    });

    process.stderr.listen((event) {
      // debugPrint('received event: ');

      if (event.contains(8)) {
        if(progressText.isNotEmpty) {
          progressText = progressText.substring(0, progressText.length - 1);
        }
      }

      // debugPrint(utf8.decode(event));
      // debugPrint(event.toString());

      String decoded = utf8.decode(event.where((element) => element != 8).toList());

      progressText += decoded;

      progressText = progressText.replaceAll('Launched: ', "\n"
          "Launched: "
          "");

      if(progressText.contains('Launched:')) {
        status = 'complete';
      }
      setState(() {});
    }, onDone: () {
      status = 'complete';
      setState(() {

      });
    });


  }

  @override
  void initState() {
    super.initState();
    runCommand();
  }

  @override
  Widget build(BuildContext context) {
    var body;

    body = SelectableText(progressText);

    List<Widget> actions = [];
    if(status == 'complete') {
      actions.add(ElevatedButton(onPressed: () {
        Navigator.pop(context);
      }, child: const Text('Back to list')));
    }

    return ParentDialog(
      title: widget.title,
      child: body,
      hideActions: false,
      customCancelAction: status == 'complete' ? null : () async {
        if(process.kill()) {
          Navigator.pop(context);
        }
      },
      actions: actions
    );
  }
}
