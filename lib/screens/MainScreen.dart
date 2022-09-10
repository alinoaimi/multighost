import 'dart:convert';
import 'dart:io';

import 'package:app/data/MultipassInstanceObject.dart';
import 'package:app/screens/CreateInstance.dart';
import 'package:app/widgets/GhostAppBar.dart';
import 'package:app/widgets/InstanceCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/zondicons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/GlobalUtils.dart';
import '../widgets/LoadingWidget.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<MultipassInstanceObject>? list;
  bool isActive = true;
  bool isInstalled = true;

  loadList() async {

    list = [];

    try {

      // var result = await Process.run('which', [GlobalUtils.multipassPath]);
      // debugPrint('which output: ');
      // debugPrint(result.stdout.toString());


      var result = await Process.run(GlobalUtils.multipassPath, ['list', '--format=json']);

      isInstalled = true;
      list = [];
      var rawList = json.decode(result.stdout)['list']; // replace with list
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
      debugPrint(ex.toString());
      isInstalled = false;
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

    if (!isInstalled) {
      theBody = Column(
        children: [
          GhostAppBar(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Please make sure that Multipass is installed.',),
                const SizedBox(height: 10,),
                ElevatedButton(onPressed: () {
                  
                  try {
                    launchUrl(Uri.parse('https://multipass.run/install'));
                  } catch(ex) {
                    debugPrint(ex.toString());
                  }

                }, child: const Text('Install Multipass'),),
                const SizedBox(height: 3,),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('After installing Multipass'),
                    TextButton(onPressed: () {}, child: const Text('Click Here')),
                    const Text('to reload.')
                  ],
                )
              ],
            ),
          )
        ],
      );
    } else if (list == null) {
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
          onPressed: () {
            Get.dialog(CreateInstance(
              onCreated: () {
                // loadAliases();
              },
            ));
          },
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
      body: Column(
        children: [
          Expanded(child: theBody),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Spacer(),
                TextButton(onPressed: () async {
                  PackageInfo packageInfo = await PackageInfo.fromPlatform();

                  showAboutDialog(context: context,
                      applicationVersion: packageInfo.version,
                      children: [
                        const Text('A GUI for Multipass, created using Flutter.'),
                        const SizedBox(height: 20,),
                        Row(
                          children: [
                            const Text('by Ali Alnoaimi'),
                            const SizedBox(width: 10,),
                            IconButton(onPressed: () {
                              try {
                                launchUrl(Uri.parse('https://twitter.com/ghost013li'));
                              } catch(ex) {
                                debugPrint(ex.toString());
                              }
                            }, icon: const Iconify(Mdi.twitter)),
                            IconButton(onPressed: () {
                              try {
                                launchUrl(Uri.parse('https://github.com/alinoaimi'));
                              } catch(ex) {
                                debugPrint(ex.toString());
                              }
                            }, icon: const Iconify(Mdi.github)),
                          ],
                        )
                      ]
                  );
                }, child: const Text('About Multighost'))
              ],
            ),
          )
        ],
      ),
    );
  }
}
