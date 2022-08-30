import 'dart:convert';
import 'dart:io';

import 'package:app/data/MultipassInstanceObject.dart';
import 'package:app/widgets/GhostAppBar.dart';
import 'package:app/widgets/InstanceCard.dart';
import 'package:flutter/material.dart';

import '../widgets/LoadingWidget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<MultipassInstanceObject>? list;
  bool isActive = true;

  loadList() async {
    var result = await Process.run('multipass', ['list', '--format=json']);
    try {
      list = [];
      var rawList = json.decode(result.stdout)['list'];
      for (var rawInstance in rawList) {
        MultipassInstanceObject multipassInstanceObject =
            MultipassInstanceObject(
                name: rawInstance['name'],
                release: rawInstance['release'],
                state: rawInstance['state']);
        list?.add(multipassInstanceObject);
      }
    } catch (ex) {
      // TODO handle the exception
      debugPrint('error at loadList');
    }
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

    if (list == null) {
      theBody = const LoadingWidget();
    } else {
      theBody = const Text('hello world');

      ListView listView = ListView.builder(
          itemCount: list?.length,
          itemBuilder: (BuildContext context, int index) {
            return InstanceCard(instance: list![index]);
            // return ListTile(
            //     leading: const Icon(Icons.list),
            //     trailing: Text(
            //       multipassList!.list[index].release!,
            //       style: TextStyle(color: Colors.green, fontSize: 15),
            //     ),
            //     title: Text(multipassList!.list[index].name));
          });

      List<Widget> headerActions = [];
      headerActions.add(OutlinedButton(
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

      theBody = Column(
        children: [
          GhostAppBar(
            actions: headerActions,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [Expanded(child: listView)],
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      body: theBody,
    );
  }
}
