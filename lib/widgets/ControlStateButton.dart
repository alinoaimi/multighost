import 'dart:io';

import 'package:flutter/material.dart';

import '../data/MultipassList.dart';

class ControlStateButton extends StatefulWidget {
  final MultipassListElement instance;

  const ControlStateButton({Key? key, required this.instance})
      : super(key: key);

  @override
  State<ControlStateButton> createState() => _ControlStateButtonState();
}

class _ControlStateButtonState extends State<ControlStateButton> {
  bool somethingIsHappening = false;

  doAction() async {
    somethingIsHappening = true;
    setState(() {

    });
    if (widget.instance.state! == 'Running') {
      var result =
          await Process.run('multipass', ['stop', widget.instance.name]);
    } else if (widget.instance.state! == 'Stopped') {
      var result =
          await Process.run('multipass', ['start', widget.instance.name]);
    }

    somethingIsHappening = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String text = 'Start';
    Color color = Colors.black;

    if(somethingIsHappening && widget.instance.state! != 'Starting') {
      text = 'Pending';
      color = const Color.fromRGBO(80, 80, 80, 1.0);
    } else if (widget.instance.state! == 'Running') {
      text = 'Stop';
      color = Colors.black;
    } else if (widget.instance.state! == 'Starting') {
      text = 'Starting';
      color = Colors.black;
    }

    return OutlinedButton(
      onPressed: (somethingIsHappening || widget.instance.state == 'Starting')
          ? null
          : () {
              doAction();
            },
      child: Text(text),
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(color),
      ),
    );
  }
}
