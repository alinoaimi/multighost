import 'dart:convert';
import 'dart:io';

import 'package:app/always-native/widgets/NativeButton.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/MultipassInstanceObject.dart';
import '../utils/GlobalUtils.dart';
import '../widgets/ParentDialog.dart';

class CreateMount extends StatefulWidget {
  String? instanceName;
  VoidCallback? onCreated;

  CreateMount({Key? key, this.instanceName, this.onCreated}) : super(key: key);

  @override
  State<CreateMount> createState() => _CreateMountState();
}

class _CreateMountState extends State<CreateMount> {
  List<MultipassInstanceObject> list = [];
  final _formKey = GlobalKey<FormState>();
  TextEditingController _sourceController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  late String selectedInstance;

  bool isCreating = false;

  _createMount() async {
    isCreating = true;
    setState(() {});

    var result = await Process.run(GlobalUtils.multipassPath, [
      'mount',
      _sourceController.text,
      '${widget.instanceName}:${_destinationController.text}'
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

    bodyChildren.add(Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              String? selectedDirectory =
                  await FilePicker.platform.getDirectoryPath();

              if (selectedDirectory != null) {
                // User canceled the picker
                debugPrint(selectedDirectory);
                _sourceController.text = selectedDirectory;
              }
            },
            child: TextFormField(
              enabled: false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              controller: _sourceController,
              decoration: const InputDecoration(
                  labelText: 'Source',
                  helperText: 'The source folder at your host OS.'),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        OutlinedButton(
            onPressed: () async {
              String? selectedDirectory =
                  await FilePicker.platform.getDirectoryPath();

              if (selectedDirectory != null) {
                // User canceled the picker
                debugPrint(selectedDirectory);
                _sourceController.text = selectedDirectory;
              }
            },
            child: const Text('📁 Pick Directory'))
      ],
    ));

    bodyChildren.add(TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
        return null;
      },
      controller: _destinationController,
      decoration: const InputDecoration(
          labelText: 'Destination path',
          helperText: 'The path to mount it to at the VM.'),
    ));

    List<Widget> actions = [];
    actions.add(NativeButton(
        onPressed: isCreating
            ? null
            : () {
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  _createMount();
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
      title: 'Create a Mount',
      actions: actions,
      child: Material(color: Colors.transparent, child: body),
    );
  }
}
