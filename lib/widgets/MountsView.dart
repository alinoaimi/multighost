import 'dart:convert';
import 'dart:io';

import 'package:app/data/MultipassAlias.dart';
import 'package:app/screens/CreateAlias.dart';
import 'package:app/utils/GlobalUtils.dart';
import 'package:app/widgets/LoadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:get/get.dart';

import '../data/MultipassMount.dart';
import '../screens/CreateMount.dart';

class MountsView extends StatefulWidget {
  final String instanceName;

  MountsView({Key? key, required this.instanceName}) : super(key: key);

  @override
  State<MountsView> createState() => _MountsViewState();
}

class _MountsViewState extends State<MountsView> {
  bool isLoading = true;
  late List<MultipassMount> mounts;

  loadMounts() async {
    var result = await Process.run(GlobalUtils.multipassPath, ['info', widget.instanceName, '--format=json']);

    try {
      var rawMounts = jsonDecode(result.stdout)['info'][widget.instanceName]['mounts'];

      mounts = [];
      rawMounts.forEach((k, v) {
        MultipassMount multipassMount = MultipassMount(
            instanceName: widget.instanceName,
            destinationPath: k,
            sourcePath: v['source_path']);

        mounts.add(multipassMount);
        debugPrint(multipassMount.toString());

      });



      isLoading = false;
      setState(() {});
    } catch (ex) {
      debugPrint('error at loadAliases()');
      debugPrint(ex.toString());
      // TODO handle error, a nice error message maybe
    }
  }

  @override
  void initState() {
    super.initState();

    loadMounts();
  }

  deleteMount(String destinationPath) async {
    var result = await Process.run(GlobalUtils.multipassPath, ['unmount', '${widget.instanceName}:$destinationPath']);
    loadMounts();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LoadingWidget();
    }

    List<DataRow> dataRows = [];

    for (MultipassMount mount in mounts) {
      Widget deleteBtn =
      IconButton(onPressed: () {
        deleteMount(mount.destinationPath);
      }, icon: const Icon(Icons.delete));

      dataRows.add(DataRow(cells: [
        DataCell(Text(
          mount.destinationPath!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        )),
        DataCell(InkWell(
            onTap: () {
              GlobalUtils.launchPathNative(mount.sourcePath);
            },
            child: Text('📁 '+mount.sourcePath!))),
        DataCell(deleteBtn),
      ]));
    }

    List<Widget> bodyChildren = [];

    bodyChildren.add(const SizedBox(
      height: 10,
    ));
    bodyChildren.add(Row(
      children: [
        OutlinedButton.icon(
            onPressed: () {
              Get.dialog(CreateMount(
                instanceName: widget.instanceName,
                onCreated: () {
                  loadMounts();
                },
              ));
            },
            icon: const Icon(
              Icons.add,
              size: 14,
            ),
            label: const Text('Create a Mount'))
      ],
    ));

    bodyChildren.add(Expanded(
      child: DataTable2(
          columnSpacing: 12,
          horizontalMargin: 12,

          // minWidth: 600,
          columns: const [
            DataColumn2(
              label: Text('Destination'),
              size: ColumnSize.L,
            ),
            DataColumn(
              label: Text('Source'),
            ),
            DataColumn(
              label: Text('Actions'),
            )
          ],
          rows: dataRows),
    ));

    return Column(
      children: bodyChildren,
    );

    return Container(
      child: Text('aliases view'),
    );
  }
}
