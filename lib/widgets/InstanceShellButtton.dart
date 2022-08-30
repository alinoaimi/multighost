import 'dart:io';

import 'package:app/data/MultipassInstanceObject.dart';
import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';
import 'package:process_run/which.dart';

class InstanceShellButton extends StatefulWidget {
  final MultipassInstanceObject instance;
  bool? condensed = false;

  InstanceShellButton({Key? key, required this.instance, this.condensed})
      : super(key: key);

  @override
  State<InstanceShellButton> createState() => _InstanceShellButtonState();
}

class _InstanceShellButtonState extends State<InstanceShellButton> {
  openShell() async {
    var shell = Shell();
    debugPrint('opening shell');
    if (Platform.isMacOS) {
      debugPrint('opening shell macos');

      await shell.run('''

osascript -e 'tell app "Terminal"' -e 'do script "multipass shell ${widget.instance.name}"' -e 'end tell'

''');
    } else if (Platform.isLinux) {
      // TODO add command for linux
    } else if (Platform.isWindows) {
      // TODO add command for windows
    } else {
      // TODO show not supported on this platform toast, and send anonymous stats if added in the future
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.condensed ??= false;

    List<Widget> children = [];

    children.add(const Icon(
      Icons.terminal,
      color: Colors.black,
    ));

    if (!widget.condensed!) {
      children.add(const SizedBox(width: 10));
      children.add(Text('Shell'));
    }

    if (widget.condensed!) {
      return IconButton(
          onPressed: () {
            openShell();
          },
          icon: const Icon(Icons.terminal));
    }

    return SizedBox(
      child: OutlinedButton(
        onPressed: widget.instance.state != 'Running'
            ? null
            : () {
                openShell();
              },
        style: ButtonStyle(
          // backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        ),
        child: Row(
          children: children,
        ),
      ),
    );
  }
}
