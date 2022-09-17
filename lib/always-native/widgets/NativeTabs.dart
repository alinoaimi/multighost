import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';

class NativeTabsTab {
  final String id;
  final String title;
  final Widget content;

  NativeTabsTab({required this.id, required this.title, required this.content});
}

class NativeTabs extends StatefulWidget {
  final List<NativeTabsTab> tabs;

  const NativeTabs({Key? key, required this.tabs}) : super(key: key);

  @override
  State<NativeTabs> createState() => _NativeTabsState();
}

class _NativeTabsState extends State<NativeTabs> {
  int activeStep = 0;

  final _macosController = MacosTabController(
    initialIndex: 0,
    length: 3,
  );

  @override
  Widget build(BuildContext context) {
    List<MacosTab> macosTabs = [];
    List<Widget> macosTabsChildren = [];

    for (NativeTabsTab tab in widget.tabs) {
      macosTabs.add(MacosTab(label: tab.title));
      macosTabsChildren.add(Padding(
        padding: const EdgeInsets.fromLTRB(0, 17, 0, 0),
        child: tab.content,
      ));
    }

    return MacosTabView(
      controller: _macosController,
      tabs: macosTabs,
      children: macosTabsChildren,
    );

    return const Text('still working on it');
  }
}
