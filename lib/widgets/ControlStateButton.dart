import 'dart:io';

import 'package:app/data/MultipassInstanceObject.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ControlStateButton extends StatefulWidget {
  final MultipassInstanceObject instance;
  bool? condensed = false;

  ControlStateButton({Key? key, required this.instance, this.condensed})
      : super(key: key);

  @override
  State<ControlStateButton> createState() => _ControlStateButtonState();
}

class _ControlStateButtonState extends State<ControlStateButton> {
  bool somethingIsHappening = false;


  doAction() async {
    somethingIsHappening = true;
    setState(() {});
    if (widget.instance.state! == 'Running') {
      var result =
          await Process.run('multipass', ['stop', widget.instance.name]);
    } else if (widget.instance.state! == 'Stopped' || widget.instance.state! == 'Suspended') {
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
    IconData? icon = Icons.play_arrow;

    widget.condensed ??= false; // there's probably a better way to use in the constructor, will figure it out later

    if (somethingIsHappening && widget.instance.state! != 'Starting') {
      text = 'Pending';
      color = const Color.fromRGBO(80, 80, 80, 1.0);
      if(!widget.condensed!) {
        icon = null;
      } else {
        icon = Icons.circle_outlined;
      }
    } else if (widget.instance.state! == 'Running') {
      text = 'Stop';
      color = Colors.black;
      icon = Icons.stop;
    } else if (widget.instance.state! == 'Starting') {
      text = 'Starting';
      color = Colors.black;
      if(!widget.condensed!) {
        icon = null;
      } else {
        icon = Icons.circle_outlined;
      }
    }

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
