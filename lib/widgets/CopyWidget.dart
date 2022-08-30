import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CopyWidget extends StatefulWidget {

  String? label;
  final String value;

  CopyWidget({Key? key, this.label, required this.value}) : super(key: key);

  @override
  State<CopyWidget> createState() => _CopyWidgetState();
}

class _CopyWidgetState extends State<CopyWidget> {
  @override
  Widget build(BuildContext context) {

    List<Widget> children = [];

    if(widget.label != null) {
      children.add(Text('${widget.label!}: '));
    }
    children.add(SelectableText(widget.value));

    children.add(IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: () {
          Clipboard.setData(ClipboardData(text: widget.value));
      // do copy
    }, icon: const Icon(Icons.copy, size: 13.5,)));

    return Card(
      margin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: children,
        ),
      ),
    );
  }
}
