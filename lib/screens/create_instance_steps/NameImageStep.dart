import 'package:app/utils/GlobalUtils.dart';
import 'package:app/widgets/ImageSelector.dart';
import 'package:flutter/material.dart';

class NameImageStep extends StatefulWidget {
  const NameImageStep({Key? key}) : super(key: key);

  @override
  State<NameImageStep> createState() => _NameImageStepState();
}

class _NameImageStepState extends State<NameImageStep> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _nameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Required';
            }
            return null;
          },
          decoration: const InputDecoration(
            labelText: 'Instance name',
          ),
        ),
        SizedBox(height: GlobalUtils.standardPaddingOne,),
        ImageSelector()
      ],
    );
  }
}
