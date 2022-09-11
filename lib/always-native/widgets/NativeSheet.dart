import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';

class NativeSheet extends StatelessWidget {

  String? title;
  final Widget child;

  NativeSheet({Key? key, this.title, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String os = 'macos';

    if(os == 'macos') {
      return MacosSheet(child: child);
    } else {
      return Container(
        child: child,
      );
    }

  }
}
