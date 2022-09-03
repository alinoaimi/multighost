import 'dart:convert';
import 'dart:io';

import 'package:app/data/MultipassAlias.dart';
import 'package:app/screens/CreateAlias.dart';
import 'package:app/widgets/LoadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:get/get.dart';

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
    var result = await Process.run('multipass', ['aliases', '--format=json']);

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
    var result = await Process.run('multipass', ['unalias', alias]);
    loadAliases();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LoadingWidget();
    }

    List<DataRow> dataRows = [];

    for (MultipassAlias alias in aliases) {
      Widget deleteBtn =
          IconButton(onPressed: () {
            deleteAlias(alias.alias!);
          }, icon: const Icon(Icons.delete));

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
        OutlinedButton.icon(
            onPressed: () {
              Get.dialog(CreateAlias(
                instanceName: widget.instanceName,
                onCreated: () {
                  loadAliases();
                },
              ));
            },
            icon: const Icon(
              Icons.add,
              size: 14,
            ),
            label: const Text('Create an Alias'))
      ],
    ));

    bodyChildren.add(Expanded(
      child: DataTable2(
          columnSpacing: 12,
          horizontalMargin: 12,
          minWidth: 600,
          columns: const [
            DataColumn2(
              label: Text('Alias'),
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

    return Column(
      children: bodyChildren,
    );

    return Container(
      child: Text('aliases view'),
    );
  }
}
