import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';

class NativeMenuButtonItem {
  String? id;
  String? title;
  IconData? icon;
  VoidCallback? action;

  NativeMenuButtonItem({this.id, this.title, this.icon, this.action});
}

class NativeMenuButton extends StatefulWidget {
  String? title;
  final IconData icon;
  final List<NativeMenuButtonItem> items;

  NativeMenuButton(
      {Key? key, this.title, required this.icon, required this.items})
      : super(key: key);

  @override
  State<NativeMenuButton> createState() => _NativeMenuButtonState();
}

class _NativeMenuButtonState extends State<NativeMenuButton> {
  @override
  Widget build(BuildContext context) {
    String os = 'macos';

    if (os == 'macos') {
      List<MacosPulldownMenuItem> macosItems = [];

      for (NativeMenuButtonItem item in widget.items) {
        macosItems.add(MacosPulldownMenuItem(
          title: Text(item.title ?? ''),
          onTap: item.action,
        ));
      }

      return MacosPulldownButton(
        items: macosItems,
        icon: widget.icon,
      );
    } else {
      List<PopupMenuEntry<int>> popupItems = [];

      int index = -1;
      for (NativeMenuButtonItem action in widget.items) {
        index++;
        popupItems.add(
            // popupmenu item 2
            PopupMenuItem(
          value: index,
          // row has two child icon and text
          onTap: action.action,
          child: Row(
            children: [
              Icon(action.icon),
              SizedBox(
                // sized box with width 10
                width: 10,
              ),
              Text(action.title!)
            ],
          ),
        ));
      }

      return PopupMenuButton<int>(
        icon: Icon(Icons.more_vert),
        itemBuilder: (context) => popupItems,
        offset: Offset(0, 40),
        elevation: 2,
      );
    }
  }
}
