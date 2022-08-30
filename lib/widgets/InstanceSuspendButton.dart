import 'dart:io';

import 'package:app/data/MultipassInstanceObject.dart';
import 'package:flutter/material.dart';

class InstanceSuspendButton extends StatefulWidget {
  final MultipassInstanceObject instance;
  bool? condensed = false;

  InstanceSuspendButton({Key? key, required this.instance, this.condensed})
      : super(key: key);

  @override
  State<InstanceSuspendButton> createState() => _InstanceSuspendButtonState();
}

class _InstanceSuspendButtonState extends State<InstanceSuspendButton> {
  bool somethingIsHappening = false;

  doAction() async {
    somethingIsHappening = true;
    setState(() {});
    if (widget.instance.state! == 'Running') {
      var result =
          await Process.run('multipass', ['suspend', widget.instance.name]);
    }

    somethingIsHappening = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String text = 'Start';
    Color color = Colors.black;
    IconData? icon = Icons.play_arrow;

    widget.condensed ??= false; // there's probably a better way to use in the constructor, will figure it out later


    text = 'Suspend';
    color = const Color.fromRGBO(80, 80, 80, 1.0);
    icon = Icons.pause;

    List<Widget> btnChildren = [];
    if (icon != null) {
      btnChildren.add(Icon(icon));
      btnChildren.add(const SizedBox(width: 5));
    }

    if(!widget.condensed!) {
      btnChildren.add(Text(text));
    }

    if(widget.condensed!) {
      return IconButton(onPressed: (somethingIsHappening || widget.instance.state == 'Starting')
          ? null
          : () {
        doAction();
      }, icon: Icon(icon));
    }

    return OutlinedButton(
      onPressed: (somethingIsHappening || widget.instance.state == 'Starting')
          ? null
          : () {
              doAction();
            },
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(color),
      ),
      child: Row(
        children: btnChildren,
      ),
    );
  }
}
