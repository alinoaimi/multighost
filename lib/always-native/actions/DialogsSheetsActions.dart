import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';

import '../data/NativeData.dart';

class DialogsSheetsActions {

  static void nativeShowSheet({required BuildContext context, required Widget child, bool? barrierDismissible = false}) {

    NativePlatform platform = NativeData.getPlatform();

    if (platform == NativePlatform.macOS) {
      showMacosSheet(
        context: context,
        builder: (_) => child,
        barrierDismissible: barrierDismissible ?? false
      );
    } else {
      showDialog(context: context, builder: (context) {
        return child;
      });
    }

  }

}