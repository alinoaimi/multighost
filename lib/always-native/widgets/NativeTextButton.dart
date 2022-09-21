import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';
import 'dart:io' show Platform;

import '../data/NativeData.dart';

class NativeTextButton extends StatelessWidget {
  final Widget child;
  VoidCallback? onPressed;
  IconData? icon;

  NativeTextButton({Key? key, required this.child, this.onPressed, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    NativePlatform platform = NativeData.getPlatform();

    if (platform == NativePlatform.macOS) {
      Widget buttonChild;
      if (icon == null) {
        buttonChild = child;
      } else {
        buttonChild = Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 14,
            ),
            const SizedBox(width: 3),
            child
          ],
        );
      }

      return PushButton(
        buttonSize: ButtonSize.large,
        onPressed: onPressed,
        child: buttonChild,
      );
    } else {
      return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(shape: const BeveledRectangleBorder()),
        child: child,
      );
    }
  }
}
