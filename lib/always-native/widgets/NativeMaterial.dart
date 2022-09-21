import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../data/NativeData.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent_ui;

class NativeMaterial extends StatelessWidget {
  final Widget child;
  Color? color;

  NativeMaterial({Key? key, required this.child, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NativePlatform platform = NativeData.getPlatform();


    if (platform == NativePlatform.macOS) {
      return Material(
        color: Colors.transparent,
        child: Theme(
          data: ThemeData(
              brightness:
                  (MediaQuery.platformBrightnessOf(context) == Brightness.dark)
                      ? Brightness.dark
                      : Brightness.light),
          child: child,
        ),
      );
    } else if (platform == NativePlatform.Linux) {
      return Material(
        color: Colors.transparent,
        child: YaruTheme(
          // data: YaruThemeData(brightness: ( MediaQuery.platformBrightnessOf(context) == Brightness.dark) ? Brightness.dark : Brightness.light),
          child: child,
        ),
      );
    } else if (platform == NativePlatform.Windows) {
      return fluent_ui.NavigationView(
        content: Material(child: child),
      );
    }

    return Material(
      color: Colors.transparent,
      child: child,
    );
  }
}
