import 'dart:convert';
import 'dart:io';

import 'package:app/always-native/data/NativeData.dart';
import 'package:app/always-native/widgets/NativeWindow.dart';
import 'package:app/data/MultipassInstanceObject.dart';
import 'package:app/screens/CreateInstance.dart';
import 'package:app/widgets/GhostAppBar.dart';
import 'package:app/widgets/InstanceCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/zondicons.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import '../always-native/actions/DialogsSheetsActions.dart';
import '../always-native/widgets/NativeAppBar.dart';
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
    try {
      // var result = await Process.run('which', [GlobalUtils.multipassPath]);
      // debugPrint('which output: ');
      // debugPrint(result.stdout.toString());

      List<String> pathsToTry = [
        '/usr/bin/multipass',
        '/usr/local/bin/multipass',
        '/snap/bin/multipass',
      ];

      for(String pathToTry in pathsToTry) {
        try {
            var result = await Process.run(
                pathToTry, ['list', '--format=json']);
            var rawList = json.decode(result.stdout)['list']; // replace with list

            GlobalUtils.multipassPath = pathToTry;
            isInstalled = true;
            break;
        } catch(ex) {

        }
      }


      if(GlobalUtils.multipassPath == '') {
        isInstalled = false;
      }

      if (isInstalled) {
        try {
          list = [];

          var result = await Process.run(
              GlobalUtils.multipassPath, ['list', '--format=json']);

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
          setState(() {});
        } catch (ex) {
          debugPrint(ex.toString());
        }
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
          NativeAppBar(
            title: 'MultiGhost',
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Please make sure that Multipass is installed.',
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    try {
                      launchUrl(Uri.parse('https://multipass.run/install'));
                    } catch (ex) {
                      debugPrint(ex.toString());
                    }
                  },
                  child: const Text('Install Multipass'),
                ),
                const SizedBox(
                  height: 3,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('After installing Multipass'),
                    TextButton(
                        onPressed: () {}, child: const Text('Click Here')),
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

      List<NativeAppBarAction> nativeAppBarActions = [];
      nativeAppBarActions.add(NativeAppBarAction(
          label: 'Create an Instance',
          icon: Icons.add,
          onTap: () {
            DialogsSheetsActions.nativeShowSheet(
                context: context,
                child: CreateInstance(
                  onCreated: () {
                    // loadAliases();
                  },
                ),
                barrierDismissible: false);
          }));

      theBody = Column(
        children: [
          NativeAppBar(
            title: 'MultiGhost',
            actions: nativeAppBarActions,
          ),
          Flexible(
            fit: FlexFit.loose,
            flex: 9,
            child: Column(
              children: [Expanded(child: listView)],
            ),
          ),
        ],
      );
    }

    return NativeWindow(
      windowTitle: 'MultiGhost',
      child: Column(
        children: [
          Expanded(child: theBody),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Spacer(),
                TextButton(
                    onPressed: () async {
                      PackageInfo packageInfo =
                          await PackageInfo.fromPlatform();

                      showAboutDialog(
                          context: context,
                          applicationVersion: packageInfo.version,
                          applicationIcon: SizedBox(
                            height: 48,
                            child:
                                Image.asset('assets/images/rounded-icon.png'),
                          ),
                          children: [
                            const Text(
                                'A GUI for Multipass, created using Flutter.'),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                const Text('by Ali Alnoaimi'),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                    onPressed: () {
                                      try {
                                        launchUrl(Uri.parse(
                                            'https://twitter.com/ghost013li'));
                                      } catch (ex) {
                                        debugPrint(ex.toString());
                                      }
                                    },
                                    icon: const Iconify(Mdi.twitter)),
                                IconButton(
                                    onPressed: () {
                                      try {
                                        launchUrl(Uri.parse(
                                            'https://github.com/alinoaimi'));
                                      } catch (ex) {
                                        debugPrint(ex.toString());
                                      }
                                    },
                                    icon: const Iconify(Mdi.github)),
                              ],
                            )
                          ]);
                    },
                    child: const Text('About Multighost'))
              ],
            ),
          )
        ],
      ),
    );
  }
}
