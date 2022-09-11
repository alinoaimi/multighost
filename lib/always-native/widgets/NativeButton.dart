import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';

class NativeButton extends StatelessWidget {
  final Widget child;
  VoidCallback? onPressed;

  NativeButton({Key? key, required this.child, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String os = 'macos';

    if (os == 'macos') {
      return PushButton(
        child: child,
        buttonSize: ButtonSize.large,
        onPressed: onPressed,
      );
    } else {
      return ElevatedButton(onPressed: onPressed, child: child);
    }
  }
}
