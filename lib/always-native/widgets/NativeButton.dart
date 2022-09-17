import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';

class NativeButton extends StatelessWidget {
  final Widget child;
  VoidCallback? onPressed;
  IconData? icon;

  NativeButton({Key? key, required this.child, this.onPressed, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String os = 'macos';

    if (os == 'macos') {

      Widget buttonChild;
      if(icon == null) {
        buttonChild = child;
      } else {
        buttonChild = Row(
          children: [
            Icon(icon, color: Colors.white, size: 14,),
            const SizedBox(width: 3),
            child
          ],
        );
      }

      return PushButton(
        child: buttonChild,
        buttonSize: ButtonSize.large,
        onPressed: onPressed,
      );
    } else {
      return ElevatedButton(onPressed: onPressed, child: child);
    }
  }
}
