import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';

class NativeIconButton extends StatelessWidget {
  VoidCallback? onPressed;
  final Icon icon;

  NativeIconButton({Key? key, this.onPressed, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MacosIconButton(
        icon: icon,
        onPressed: onPressed,
        boxConstraints: const BoxConstraints(maxHeight: 100, maxWidth: 100));
  }
}
