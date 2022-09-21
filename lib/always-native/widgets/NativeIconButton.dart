import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';
import 'dart:io' show Platform;

import '../data/NativeData.dart';

class NativeIconButton extends StatelessWidget {
  VoidCallback? onPressed;
  final Icon icon;

  NativeIconButton({Key? key, this.onPressed, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    NativePlatform platform = NativeData.getPlatform();

    if (platform == NativePlatform.macOS) {
      return MacosIconButton(
          icon: icon,
          onPressed: onPressed,
          boxConstraints: const BoxConstraints(maxHeight: 100, maxWidth: 100));
    } else {
      return IconButton(onPressed: onPressed, icon: icon);
    }
  }
}
