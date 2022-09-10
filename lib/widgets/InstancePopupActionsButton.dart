import 'dart:io';

import 'package:app/data/MultipassInstanceObject.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';

import '../utils/GlobalUtils.dart';


class InstancePopupActionsButton extends StatefulWidget {
  final MultipassInstanceObject instance;

  const InstancePopupActionsButton({Key? key, required this.instance})
      : super(key: key);

  @override
  State<InstancePopupActionsButton> createState() =>
      _InstancePopupActionsButtonState();
}

class MenuAction {
  String? id;
  String? title;
  IconData? icon;
  VoidCallback? action;

  MenuAction({this.id, this.title, this.icon, this.action});
}

class _InstancePopupActionsButtonState
    extends State<InstancePopupActionsButton> {
  @override
  Widget build(BuildContext context) {
    List<MenuAction> menuActions = [];

    if (widget.instance.state == 'Deleted') {
      menuActions.add(MenuAction(
          id: 'recover',
          title: 'Recover',
          icon: Icons.monitor_heart_outlined,
          action: () async {
            await FlutterPlatformAlert.playAlertSound();

            var result = await Process.run(
                GlobalUtils.multipassPath, ['recover', widget.instance.name]);
          }));
      menuActions.add(MenuAction(
          id: 'purge',
          title: 'Purge',
          icon: Icons.delete,
          action: () async {
            await FlutterPlatformAlert.playAlertSound();
            final clickedButton = await FlutterPlatformAlert.showAlert(
              windowTitle: 'Purge ' + widget.instance.name + '?',
              text: 'This action is irreversible',
              alertStyle: AlertButtonStyle.yesNo,
              iconStyle: IconStyle.information,
            );

            if (clickedButton == AlertButton.yesButton) {
              var result = await Process.run(
                  GlobalUtils.multipassPath, ['delete', '--purge', widget.instance.name]);
            }
          }));
    } else {
      menuActions.add(MenuAction(
          id: 'delete',
          title: 'Delete',
          icon: Icons.delete,
          action: () async {
            await FlutterPlatformAlert.playAlertSound();
            var result = await Process.run(
                GlobalUtils.multipassPath, ['delete', widget.instance.name]);
          }));
    }

    List<PopupMenuEntry<int>> popupItems = [];

    int index = -1;
    for (MenuAction action in menuActions) {
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
