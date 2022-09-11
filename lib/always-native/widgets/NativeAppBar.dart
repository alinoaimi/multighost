import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:macos_ui/macos_ui.dart';

class NativeAppBarAction {
  final String label;
  IconData? icon;
  VoidCallback? onTap;

  NativeAppBarAction({required this.label, this.icon, this.onTap});
}

class NativeAppBar extends StatelessWidget {
  String? title;
  bool? canBack;
  List<NativeAppBarAction>? actions;

  NativeAppBar({Key? key, this.title, this.actions, this.canBack = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // macos
    List<ToolbarItem> macosuiActions = [];
    if (actions != null) {
      for (NativeAppBarAction action in actions!) {
        macosuiActions.add(ToolBarIconButton(
            label: action.label,
            icon: MacosIcon(action.icon),
            showLabel: true,
            onPressed: action.onTap));
      }
    }
    return ToolBar(
      title: title == null ? null : Text(title!),
      actions: macosuiActions,
    );
  }
}
