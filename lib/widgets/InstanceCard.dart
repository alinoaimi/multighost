import 'package:app/widgets/InstanceStateChip.dart';
import 'package:flutter/material.dart';

import '../data/MultipassList.dart';

class InstanceCard extends StatefulWidget {
  final MultipassListElement instance;

  const InstanceCard({Key? key, required this.instance}) : super(key: key);

  @override
  State<InstanceCard> createState() => _InstanceCardState();
}

class _InstanceCardState extends State<InstanceCard> {
  @override
  Widget build(BuildContext context) {
    List<Widget> rowChildren = [];

    rowChildren.add(const SizedBox(
      width: 15,
    ));

    rowChildren.add(InstanceStateChip(instance: widget.instance, condensed: true,));

    rowChildren.add(const SizedBox(
      width: 15,
    ));

    rowChildren.add(Image.asset(
      'assets/images/ubuntu-logo.png',
      height: 35,
    ));

    rowChildren.add(Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.instance.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            widget.instance.release!,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    ));

    rowChildren.add(const Spacer());

    return Card(
      child: Row(
        children: rowChildren,
      ),
    );
  }
}
