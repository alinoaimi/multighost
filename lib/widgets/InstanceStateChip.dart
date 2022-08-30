import 'package:app/data/MultipassInstanceObject.dart';
import 'package:flutter/material.dart';


class InstanceStateChip extends StatelessWidget {
  final MultipassInstanceObject instance;
  bool? condensed = false;

  InstanceStateChip({Key? key, required this.instance, this.condensed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (condensed == null) {
      condensed = false;
    }
    Color stateColor = Colors.black;
    if (instance.state! == 'Stopped') {
      stateColor = Colors.grey;
    } else if (instance.state! == 'Starting') {
      stateColor = Colors.yellow;
    } else if (instance.state! == 'Running') {
      stateColor = Colors.green;
    }
    Widget stateAvatar;

    if (instance.state! == 'Starting') {
      stateAvatar = const CircularProgressIndicator(strokeWidth: 2.5);
    } else {
      stateAvatar = CircleAvatar(
        backgroundColor: stateColor,
      );
    }

    List<Widget> children = [];
    children.add(Tooltip(
      message: instance.state!,
      child: SizedBox(
        height: 15,
        width: 15,
        child: stateAvatar,
      ),
    ));

    if (!condensed!) {
      children.add(const SizedBox(width: 5,));
      children.add(Text(instance.state!, style: const TextStyle(fontSize: 13),));
      children.add(const SizedBox(width: 5,));

    }
    return Container(
      decoration: const BoxDecoration(
          color:  Color.fromRGBO(217, 217, 217, 1.0),
          borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      padding: const EdgeInsets.all(5),
      child: Row(
        children: children,
      ),
    );
  }
}
