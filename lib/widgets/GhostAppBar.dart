import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:macos_ui/macos_ui.dart';

class GhostAppBar extends StatelessWidget {
  String? title;
  List<Widget>? actions;
  bool? canBack;

  GhostAppBar({Key? key, this.title, this.actions, this.canBack = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 100,
      child: ToolBar(
        title: const Text('Untitled Docussment'),
      ),
    );

    List<Widget> headerChildren = [];

    if (canBack != null && canBack!) {
      headerChildren.add(Container(
        child: IconButton(
            padding: const EdgeInsets.fromLTRB(0, 13, 0, 0),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.keyboard_backspace_outlined)),
      ));
    }

    headerChildren.add(const Padding(
      padding: const EdgeInsets.fromLTRB(0, 13, 0, 0),
      child: Text(
        'Multighost',
        style: TextStyle(fontSize: 22),
      ),
    ));
    headerChildren.add(const Spacer());

    if (actions != null) {
      for (var action in actions!) {
        headerChildren.add(action);
      }
    }

    var header = Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        children: headerChildren,
      ),
    );



    return header;
  }
}
