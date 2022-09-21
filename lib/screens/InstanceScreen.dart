import 'dart:convert';
import 'dart:io';

import 'package:app/always-native/widgets/NativeAppBar.dart';
import 'package:app/always-native/widgets/NativeTabs.dart';
import 'package:app/data/MultipassDisk.dart';
import 'package:app/data/MultipassInstanceObject.dart';
import 'package:app/data/MultipassMemory.dart';
import 'package:app/utils/GlobalUtils.dart';
import 'package:app/widgets/AliasesView.dart';
import 'package:app/widgets/CopyWidget.dart';
import 'package:app/widgets/DiskWidget.dart';
import 'package:app/widgets/GhostAppBar.dart';
import 'package:app/widgets/InstanceCard.dart';
import 'package:app/widgets/LoadingWidget.dart';
import 'package:app/widgets/MemoryWidget.dart';
import 'package:app/widgets/MountsView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:macos_ui/macos_ui.dart';

import '../always-native/widgets/NativeWindow.dart';

class InstanceScreen extends StatefulWidget {
  const InstanceScreen({Key? key}) : super(key: key);

  @override
  State<InstanceScreen> createState() => _InstanceScreenState();
}

class InstanceTab {
  final int index;
  final String id;
  String? label;

  InstanceTab({this.label, required this.id, required this.index});
}

class _InstanceScreenState extends State<InstanceScreen> {
  bool isLoading = true;
  bool isLoadingDone = false;
  bool isActive = true;
  String? instanceName;
  MultipassInstanceObject? instance;
  String selectedTab = 'details';
  final PageController _pageController =
      PageController(initialPage: 0, viewportFraction: 1);

  loadInstanceInfo() async {
    var result = await Process.run(
        GlobalUtils.multipassPath, ['info', instanceName!, '-v', '--format=json']);

    try {
      var resultDecode = jsonDecode(result.stdout);
      var rawInstance = resultDecode['info'][instanceName];

      instance = MultipassInstanceObject(
          name: instanceName!,
          release: rawInstance['release'] ?? rawInstance['image_release'],
          state: rawInstance['state']);

      instance?.disks = [];

      // the parson to be moved to fromJson inside the class, but not now and I'm not sure if I should do it, since multipass is not returning the data in a regular format

      if (rawInstance['state'] == 'Running') {
        instance?.memory = MultipassMemory(
            total: double.parse(rawInstance['memory']['total'].toString()),
            used: double.parse(rawInstance['memory']['used'].toString()));

        Map<String, dynamic> diskLayerOneRaw = rawInstance['disks'];

        diskLayerOneRaw.forEach((k, v) {
          MultipassDisk multipassDisk = MultipassDisk(
              name: k,
              total: double.parse(v['total']!),
              used: double.parse(v['used']!));
          instance?.disks!.add(multipassDisk);
        });

        // Network
        instance?.ipv4s = [];
        for (var ipv4 in rawInstance['ipv4']) {
          instance?.ipv4s!.add(ipv4.toString());
        }
      }
    } catch (ex) {
      // TODO handle exception
      debugPrint('error at loadInstanceInfo()');
      debugPrint(ex.toString());
    }

    isLoading = false;
    Future.delayed(const Duration(milliseconds: 10), () {
      isLoadingDone = true;
      setState(() {

      });
    });
    setState(() {});

    Future.delayed(const Duration(milliseconds: 200), () {
      if (isActive) {
        loadInstanceInfo();
      }
    });
  }

  @override
  void dispose() {
    isActive = false;
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    // debugPrint('the args: ');
    // debugPrint(arguments.toString());

    // instanceName = Get.arguments['instance_name'];
    // instance = Get.arguments['instance'];
    //
    //
    //
    // loadInstanceInfo();
  }

  @override
  Widget build(BuildContext context) {

    if(instanceName == null) {
      final args = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;

      instanceName = args['instance_name'];
      instance = args['instance'];

      loadInstanceInfo();

    }

    List<Widget> bodyChildren = [];

    bodyChildren.add(SizedBox(
     height: 50,
      child: NativeAppBar(
        title: instanceName,
        canBack: true,
      ),
    ));



    if (isLoading)
    {
      if (instance != null) {
        bodyChildren.add(SizedBox(
          height: 100,
          child: Container(
            // padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: InstanceCard(
              instance: instance!,
              internal: true,
            ),
          ),
        ));
      }
      bodyChildren.add(const Flexible(flex: 9, child: LoadingWidget()));
    } else
    {
      bodyChildren.add(SizedBox(
        child: Container(
          // padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: InstanceCard(instance: instance!, internal: true),
        ),
      ));


      Widget tabsView;
      tabsView = const Text('wait');

      List<Widget> detailsTabChildren = [];
      if (instance != null) {
        if (instance?.state == 'Running') {
          detailsTabChildren.add(const SizedBox(
            height: 5,
          ));

          List<Widget> rowOneChildren = [];

          List<Widget> disksWidgets = [];
          if (instance!.disks != null) {
            for (MultipassDisk disk in instance!.disks!) {
              disksWidgets.add(DiskWidget(disk: disk));
            }
          }

          var disksListView = Row(
            children: disksWidgets,
          );

          rowOneChildren.add(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Memory'),
              SizedBox(
                height: 6,
              ),
              MemoryWidget(memory: instance!.memory!)
            ],
          ));

          rowOneChildren.add(SizedBox(
            width: 10,
          ));

          rowOneChildren.add(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Disks'),
              const SizedBox(
                height: 6,
              ),
              disksListView
            ],
          ));

          detailsTabChildren.add(Row(
            children: rowOneChildren,
          ));

          detailsTabChildren.add(SizedBox(
            height: GlobalUtils.standardPaddingOne,
          ));

          List<Widget> networkChildren = [];
          for (String ip in instance!.ipv4s!) {
            networkChildren.add(CopyWidget(
              value: ip,
              label: 'IP',
            ));
          }

          detailsTabChildren.add(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Network'),
              const SizedBox(
                height: 6,
              ),
              Row(
                children: networkChildren,
              )
            ],
          ));
        } else {
          detailsTabChildren.add(Spacer());
          detailsTabChildren.add(Center(
            child: Text('Start the instance to view its details.'),
          ));
          detailsTabChildren.add(Spacer());
        }
      }

      var detailsTab = Theme(
        data: ThemeData(brightness: ( MediaQuery.platformBrightnessOf(context) == Brightness.dark) ? Brightness.dark : Brightness.light),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: detailsTabChildren,
          ),
        ),
      );



      List<NativeTabsTab> tabs = [
        NativeTabsTab(id: 'details', title: 'Details', content: detailsTab),
        NativeTabsTab( id: 'mounts', title: 'Mounts', content: MountsView(instanceName: instanceName!,)),
        NativeTabsTab( id: 'aliases', title: 'Aliases', content: AliasesView(instanceName: instanceName,)),
      ];

      bodyChildren.add(Flexible(
        flex: 9,
        child: AnimatedOpacity(
          opacity: isLoadingDone ? 1 : 0.0,
          duration: const Duration(milliseconds: 200),
          // padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: NativeTabs(tabs: tabs,),
        ),
      ));
    }

    return NativeWindow(
      windowTitle: 'MultiGhost',
        child: Column(
      children: bodyChildren,
    ));
  }
}
