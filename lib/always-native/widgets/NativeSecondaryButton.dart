import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';

import '../data/NativeData.dart';

class NativeSecondaryButton extends StatelessWidget {
  final Widget child;
  VoidCallback? onPressed;

  NativeSecondaryButton({Key? key, required this.child, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    NativePlatform platform = NativeData.getPlatform();

    if (platform == NativePlatform.macOS) {

      return PushButton(
        buttonSize: ButtonSize.large,
        onPressed: onPressed,
        isSecondary: true,
        child: child,
      );
    } else {
      return TextButton(onPressed: onPressed, child: child);
    }
  }
}
