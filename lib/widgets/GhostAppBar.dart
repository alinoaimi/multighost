import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GhostAppBar extends StatelessWidget {
  String? title;
  List<Widget>? actions;
  bool? canBack;

  GhostAppBar({Key? key, this.title, this.actions, this.canBack = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> headerChildren = [];

    if(canBack != null && canBack!) {
      headerChildren.add(IconButton(onPressed: () {
        Get.back();
      }, icon: const Icon(Icons.keyboard_backspace_outlined)));
    }
    
    headerChildren.add(const Text(
      'Multighost',
      style: TextStyle(fontSize: 22),
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
