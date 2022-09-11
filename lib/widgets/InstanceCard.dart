import 'dart:convert';

import 'package:app/always-native/widgets/NativeListItem.dart';
import 'package:app/data/MultipassInstanceObject.dart';
import 'package:app/screens/InstanceScreen.dart';
import 'package:app/widgets/InstancePopupActionsButton.dart';
import 'package:app/widgets/InstanceShellButtton.dart';
import 'package:app/widgets/InstanceStateChip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'ControlStateButton.dart';

import 'InstanceSuspendButton.dart';

class InstanceCard extends StatefulWidget {
  final MultipassInstanceObject instance;
  bool? internal;

  InstanceCard({Key? key, required this.instance, this.internal})
      : super(key: key);

  @override
  State<InstanceCard> createState() => _InstanceCardState();
}

class _InstanceCardState extends State<InstanceCard> {
  @override
  Widget build(BuildContext context) {
    widget.internal ??= false;

    List<Widget> rowChildren = [];

    rowChildren.add(const SizedBox(
      width: 15,
    ));

    if (!widget.internal!) {
      rowChildren.add(InstanceStateChip(
        instance: widget.instance,
        condensed: true,
      ));

      rowChildren.add(const SizedBox(
        width: 15,
      ));
    }

    rowChildren.add(Image.asset(
      'assets/images/ubuntu-logo.png',
      height: 35,
    ));

    String state = widget.instance.state!;
    TextStyle nameStyle = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 17,
        // color: state == 'Deleted' ? Colors.grey : Colors.black,
        decoration: state == 'Deleted' ? TextDecoration.lineThrough : null);

    rowChildren.add(Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.instance.name,
                style: nameStyle,
              ),
              const SizedBox(
                width: 10,
              ),
              (widget.internal!
                  ? InstanceStateChip(
                      instance: widget.instance,
                      condensed: false,
                    )
                  : SizedBox())
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            widget.instance.release!.isEmpty
                ? widget.instance.state!
                : widget.instance.release!,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    ));

    rowChildren.add(const Spacer());

    if (widget.instance.state == 'Running') {
      rowChildren.add(InstanceShellButton(
        instance: widget.instance,
        condensed: true,
      ));
      rowChildren.add(const SizedBox(
        width: 10,
      ));
    }

    if (['Running', 'Stopped', 'Starting', 'Suspended']
        .contains(widget.instance.state)) {
      rowChildren.add(ControlStateButton(
          instance: widget.instance, condensed: !widget.internal!));
    }
    if (['Running'].contains(widget.instance.state)) {
      rowChildren.add(const SizedBox(
        width: 10,
      ));
      rowChildren.add(InstanceSuspendButton(
          instance: widget.instance, condensed: !widget.internal!));
    }

    rowChildren.add(InstancePopupActionsButton(
      instance: widget.instance,
    ));

    rowChildren.add(const SizedBox(
      width: 15,
    ));

    return NativeListItem(
      onTap: widget.internal!
          ? null
          : () async {
              Navigator.pushNamed(context, '/instance', arguments: {
                'instance_name': widget.instance.name,
                'instance': widget.instance
              });
            },
      child: Row(
        children: rowChildren,
      ),
    );
  }
}
