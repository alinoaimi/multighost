import 'dart:convert';
import 'dart:io';

import 'package:app/widgets/InstanceCard.dart';
import 'package:flutter/material.dart';

import '../data/MultipassList.dart';
import '../widgets/LoadingWidget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  MultipassList? multipassList;
  bool isActive = true;

  loadList() async {
    var result = await Process.run('multipass', ['list', '--format=json']);
    multipassList = MultipassList.fromJson(json.decode(result.stdout));
    setState(() {});

    Future.delayed(const Duration(milliseconds: 200), () {
      if (isActive) {
        loadList();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    loadList();
  }

  @override
  void dispose() {
    isActive = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget theBody;

    if (multipassList == null) {
      theBody = const LoadingWidget();
    } else {
      theBody = const Text('hello world');

      ListView listView = ListView.builder(
          itemCount: multipassList?.list.length,
          itemBuilder: (BuildContext context, int index) {
            return InstanceCard(instance: multipassList!.list[index]);
            // return ListTile(
            //     leading: const Icon(Icons.list),
            //     trailing: Text(
            //       multipassList!.list[index].release!,
            //       style: TextStyle(color: Colors.green, fontSize: 15),
            //     ),
            //     title: Text(multipassList!.list[index].name));
          });

      List<Widget> headerChildren = [];

      headerChildren.add(const Text('Virtualghost', style: TextStyle(fontSize: 22),));
      headerChildren.add(const Spacer());
      headerChildren.add(OutlinedButton(
          onPressed: () {},
          style: ButtonStyle(
            // backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
          ),
          child: SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(
                  Icons.add,
                  size: 15,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('Create an Instance')
              ],
            ),
          )));

      var header = Row(
        children: headerChildren,
      );
      theBody = Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            header,
            const SizedBox(
              height: 8,
            ),
            Expanded(child: listView)
          ],
        ),
      );
    }

    return Scaffold(
      body: theBody,
    );
  }
}
