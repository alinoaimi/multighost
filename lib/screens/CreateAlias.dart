import 'dart:convert';
import 'dart:io';

import 'package:app/always-native/data/NativeColor.dart';
import 'package:app/always-native/widgets/NativeButton.dart';
import 'package:app/always-native/widgets/NativeMaterial.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/MultipassInstanceObject.dart';
import '../utils/GlobalUtils.dart';
import '../widgets/ParentDialog.dart';

class CreateAlias extends StatefulWidget {
  String? instanceName;
  VoidCallback? onCreated;

  CreateAlias({Key? key, this.instanceName, this.onCreated}) : super(key: key);

  @override
  State<CreateAlias> createState() => _CreateAliasState();
}

class _CreateAliasState extends State<CreateAlias> {
  List<MultipassInstanceObject> list = [];
  final _formKey = GlobalKey<FormState>();
  TextEditingController _aliasController = TextEditingController();
  TextEditingController _commandController = TextEditingController();
  late String selectedInstance;

  bool isCreating = false;

  createAlias() async {
    isCreating = true;
    setState(() {});

    var result = await Process.run(GlobalUtils.multipassPath, [
      'alias',
      '${selectedInstance}:${_commandController.text}',
      _aliasController.text
    ]);
    debugPrint(result.stdout);

    isCreating = false;
    setState(() {});

    if (widget.onCreated != null) {
      widget.onCreated!();
      Navigator.pop(context);
    }
  }

  loadInstancesList() async {
    var result =
        await Process.run(GlobalUtils.multipassPath, ['list', '--format=json']);
    try {
      list = [];
      var rawList = json.decode(result.stdout)['list'];
      for (var rawInstance in rawList) {
        MultipassInstanceObject multipassInstanceObject =
            MultipassInstanceObject(
                name: rawInstance['name'],
                release: rawInstance['release'],
                state: rawInstance['state']);
        list.add(multipassInstanceObject);
      }
    } catch (ex) {
      // TODO handle the exception
      debugPrint('error at loadList');
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    if (widget.instanceName != null) {
      selectedInstance = widget.instanceName!;
    }

    loadInstancesList();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> bodyChildren = [];

    bodyChildren.add(SizedBox(height: GlobalUtils.standardPaddingOne));
    bodyChildren.add(SizedBox(height: GlobalUtils.standardPaddingOne));

    List<DropdownMenuItem<String>> instanceItems = [];

    int index = -1;
    for (MultipassInstanceObject multipassInstanceObject in list) {
      index++;
      instanceItems.add(DropdownMenuItem(
          value: multipassInstanceObject.name,
          child: Text(multipassInstanceObject.name)));
    }

    bodyChildren.add(DropdownButtonFormField(
        validator: (value) {
          if (value == null) {
            return 'Required';
          }
          return null;
        },
        decoration: const InputDecoration(labelText: 'Instance'),
        items: instanceItems,
        value: widget.instanceName,
        onChanged: (newVal) {
          selectedInstance = newVal.toString();
        }));



    bodyChildren.add(SizedBox(height: GlobalUtils.standardPaddingOne));
    bodyChildren.add(SizedBox(height: GlobalUtils.standardPaddingOne));
    bodyChildren.add(TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
        return null;
      },
      controller: _aliasController,
      decoration: const InputDecoration(
          labelText: 'Alias',
          helperText:
              'A command on your host OS, acts as shortcut to command on the VM.'),
    ));


    bodyChildren.add(SizedBox(height: GlobalUtils.standardPaddingOne));
    bodyChildren.add(SizedBox(height: GlobalUtils.standardPaddingOne));
    bodyChildren.add(TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
        return null;
      },
      controller: _commandController,
      decoration: const InputDecoration(
          labelText: 'Command',
          helperText: 'The corresponding command on the VM.'),
    ));

    List<Widget> actions = [];

    actions.add(NativeButton(
        onPressed: isCreating
            ? null
            : () {
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  createAlias();
                }
              },
        child: isCreating
            ? const SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('Create')));

    var body = Form(
      key: _formKey,
      child: Column(
        children: bodyChildren,
      ),
    );



    return ParentDialog(
      title: 'Create an Alias',
      actions: actions,
      child: body,
    );
  }
}
