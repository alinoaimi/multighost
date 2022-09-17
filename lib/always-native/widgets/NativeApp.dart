import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';

class NativeApp extends StatefulWidget {

  final String title;
  final bool debugShowCheckedModeBanner;
  final Map<String, WidgetBuilder>? routes;
  Map<String, dynamic>? macosui;
  ThemeMode? themeMode;

  NativeApp({Key? key, this.title = '', this.debugShowCheckedModeBanner = true, this.routes, this.macosui, this.themeMode}) : super(key: key);


  @override
  State<NativeApp> createState() => _NativeAppState();
}

class _NativeAppState extends State<NativeApp> {
  @override
  Widget build(BuildContext context) {



    return MacosApp(
      title: widget.title,
      debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
      routes: widget.routes!,
      theme: widget.macosui?['theme'],
      darkTheme: widget.macosui?['darkTheme'],
      themeMode: widget.themeMode,
    );
  }
}
