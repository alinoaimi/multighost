import 'package:app/utils/GlobalUtils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:macos_ui/macos_ui.dart';

import '../always-native/widgets/NativeSecondaryButton.dart';

class ParentDialog extends StatelessWidget {
  final String title;
  final Widget child;
  List<Widget>? actions;
  bool? wide = true;
  bool? hideActions = false;
  double? childPadding = 8;
  VoidCallback? customCancelAction;
  bool actionsSet = false;

  ParentDialog(
      {Key? key,
      required this.title,
      required this.child,
      this.actions,
      this.wide = true,
      this.hideActions = false,
      this.childPadding = 8,
      this.customCancelAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {


    if(!actionsSet) {
      actions ??= [];

      actions?.add(NativeSecondaryButton(
          onPressed: customCancelAction ?? () {
            Navigator.pop(context);
          },
          child: const Text('Cancel')));

      if (actions!.length > 1) {
        actions = actions?.reversed.toList();
      }
      actionsSet = true;
    }

    List<Widget> bodyChildren = [];

    double paddingToTake = (childPadding ?? 8);

    bodyChildren.add(Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Text(
          title,
          style: const TextStyle(fontSize: 17),
        )));
    bodyChildren.add(SizedBox(
      height: GlobalUtils.standardPaddingOne,
    ));
    bodyChildren.add(Container(
      height: 1,
      color: Colors.grey.withOpacity(0.5),
    ));
    bodyChildren.add(Expanded(
      child: Padding(
        padding:
            EdgeInsets.fromLTRB(paddingToTake, 0, paddingToTake, paddingToTake),
        child: child,
      ),
    ));

    if (!hideActions! && actions != null) {
      List<Widget> spacedActions = [];
      for (var action in actions!) {
        spacedActions.add(const SizedBox(
          width: 5,
        ));
        spacedActions.add(action);
      }
      bodyChildren.add(Row(
        children: [
          const Spacer(),
          Padding(
            padding: EdgeInsets.all(GlobalUtils.standardPaddingOne),
            child: Row(
              children: spacedActions,
            ),
          ),
        ],
      ));
    }


    return MacosSheet(
      child: SizedBox(
        width: wide! ? 700 : 500,
        child: Theme(
          data: ThemeData(brightness: ( MediaQuery.platformBrightnessOf(context) == Brightness.dark) ? Brightness.dark : Brightness.light),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: bodyChildren,
          ),
        ),
      ),
    );
  }
}
