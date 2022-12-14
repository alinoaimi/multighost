import 'dart:convert';
import 'dart:io';

import 'package:app/always-native/actions/DialogsSheetsActions.dart';
import 'package:app/always-native/data/NativeColor.dart';
import 'package:app/always-native/widgets/NativeButton.dart';
import 'package:app/always-native/widgets/NativeMaterial.dart';
import 'package:app/data/MultipassAlias.dart';
import 'package:app/screens/CreateAlias.dart';
import 'package:app/widgets/LoadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:get/get.dart';

import '../utils/GlobalUtils.dart';

class AliasesView extends StatefulWidget {
  String? instanceName;

  AliasesView({Key? key, this.instanceName}) : super(key: key);

  @override
  State<AliasesView> createState() => _AliasesViewState();
}

class _AliasesViewState extends State<AliasesView> {
  bool isLoading = true;
  late List<MultipassAlias> aliases;

  loadAliases() async {
    var result = await Process.run(
        GlobalUtils.multipassPath, ['aliases', '--format=json']);

    try {
      var rawAliases = jsonDecode(result.stdout)['aliases'];

      aliases = [];
      for (var rawAlias in rawAliases) {
        MultipassAlias multipassAlias = MultipassAlias(
            alias: rawAlias['alias'],
            command: rawAlias['command'],
            instance: rawAlias['instance'],
            workingDirectory: rawAlias['working-directory']);

        aliases.add(multipassAlias);
      }

      if (widget.instanceName != null) {
        aliases = aliases
            .where((element) => element.instance == widget.instanceName)
            .toList();
      }

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

    loadAliases();
  }

  deleteAlias(String alias) async {
    var result =
        await Process.run(GlobalUtils.multipassPath, ['unalias', alias]);
    loadAliases();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LoadingWidget();
    }

    List<DataRow> dataRows = [];

    for (MultipassAlias alias in aliases) {
      Widget deleteBtn = IconButton(
          onPressed: () {
            deleteAlias(alias.alias!);
          },
          icon: const Icon(Icons.delete));

      dataRows.add(DataRow(cells: [
        DataCell(Text(
          alias.alias!,
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
        DataCell(Text(alias.instance!)),
        DataCell(Text(alias.command!)),
        DataCell(deleteBtn),
      ]));
    }

    List<Widget> bodyChildren = [];

    bodyChildren.add(const SizedBox(
      height: 10,
    ));
    bodyChildren.add(Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: NativeButton(
              onPressed: () {
                DialogsSheetsActions.nativeShowSheet(
                    child: CreateAlias(
                      instanceName: widget.instanceName,
                      onCreated: () {
                        loadAliases();
                      },
                    ),
                    context: context,
                    barrierDismissible: true);

                // Get.dialog(CreateAlias(
                //   instanceName: widget.instanceName,
                //   onCreated: () {
                //     loadAliases();
                //   },
                // ));
              },
              icon: Icons.add,
              child: const Text('Create an Alias')),
        )
      ],
    ));

    bodyChildren.add(Expanded(
      child: DataTable2(
          columnSpacing: 12,
          horizontalMargin: 12,
          minWidth: 600,
          columns: const [
            DataColumn2(
              label: Text(
                'Alias',
              ),
              size: ColumnSize.L,
            ),
            DataColumn(
              label: Text('Instance'),
            ),
            DataColumn(
              label: Text('Command'),
            ),
            DataColumn(
              label: Text('Actions'),
            )
          ],
          rows: dataRows),
    ));

    return NativeMaterial(
      color: Colors.transparent,
      child: Column(
        children: bodyChildren,
      ),
    );

    // return Container(
    //   child: Text('aliases view'),
    // );
  }
}
