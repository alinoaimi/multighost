import 'dart:io';

import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  loadList() async {
    var result = await Process.run('multipass', ['list', '--format=json']);
    print(result.stdout);
  }

  @override
  void initState() {
    super.initState();

    loadList();

  }
  @override
  Widget build(BuildContext context) {



    Widget theBody;

    theBody = const Text('hello world');

    return Scaffold(
      body: theBody,
    );
  }
}
