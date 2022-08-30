import 'package:flutter/material.dart';

class AliasesView extends StatefulWidget {
  String? instanceName;
  AliasesView({Key? key, this.instanceName}) : super(key: key);

  @override
  State<AliasesView> createState() => _AliasesViewState();
}

class _AliasesViewState extends State<AliasesView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('aliases view'),
    );
  }
}
