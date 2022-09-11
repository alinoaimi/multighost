import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';

class NativeWindow extends StatefulWidget {

  final Widget child;
  String? windowTitle;

  NativeWindow({Key? key, required this.child, this.windowTitle}) : super(key: key);

  @override
  State<NativeWindow> createState() => _NativeWindowState();
}

class _NativeWindowState extends State<NativeWindow> {
  @override
  Widget build(BuildContext context) {
    return MacosWindow(
      titleBar: widget.windowTitle == null ? null : const TitleBar(
        title: Text('MultiGhost'),
      ),
      child: widget.child,

    );
  }
}
