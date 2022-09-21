import 'package:app/always-native/widgets/NativeButton.dart';
import 'package:app/always-native/widgets/NativeTextButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:macos_ui/macos_ui.dart';
import 'dart:io' show Platform;
import 'package:fluent_ui/fluent_ui.dart' as fluent_ui;

import '../data/NativeData.dart';

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
    NativePlatform platform = NativeData.getPlatform();

    if (platform == NativePlatform.macOS) {
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
      return SizedBox(
        height: kToolbarHeight,
        child: ToolBar(
          height: kToolbarHeight,
          title: title == null ? null : Text(title!),
          actions: macosuiActions,
        ),
      );
    } else if(platform == NativePlatform.Windows) {

      List<Widget> fluentActions = [];
      if (actions != null) {
        fluentActions.add(fluent_ui.Spacer());
        int index = -1;
        for (NativeAppBarAction action in actions!) {
          index++;
          fluentActions.add(NativeTextButton(
            icon: action.icon,
            onPressed: action.onTap,
            child: Text(action.label),
          ));
        }
      }


      return SizedBox(
        height: kToolbarHeight,
        child: fluent_ui.NavigationView(
            appBar: fluent_ui.NavigationAppBar(
              title:  title == null ? null : Text(title!),
              actions: Row(children: fluentActions),
              /// If automaticallyImplyLeading is true, a 'back button' will be added to
              /// app bar. This property can be overritten by [leading]
              automaticallyImplyLeading: true,
            ),
        ),
      );
    } else {
      List<Widget> materialActions = [];
      if (actions != null) {
        int index = -1;
        for (NativeAppBarAction action in actions!) {
          index++;
          materialActions.add(NativeTextButton(
            icon: action.icon,
            onPressed: action.onTap,
            child: Text(action.label),
          ));
        }
      }

      return AppBar(
        toolbarHeight: kToolbarHeight,
        title: title == null ? null : Text(title!),
        actions: materialActions,
      );

      return const Text('NativeAppBar placeholder');
    }
  }
}
