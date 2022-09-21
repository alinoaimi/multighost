import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';

import '../data/NativeData.dart';

class NativeSheet extends StatelessWidget {

  String? title;
  final Widget child;

  NativeSheet({Key? key, this.title, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    NativePlatform platform = NativeData.getPlatform();

    if (platform == NativePlatform.macOS) {
      return MacosSheet(child: child);
    } else {
      return Dialog(
        child: child,
      );
    }

  }
}
