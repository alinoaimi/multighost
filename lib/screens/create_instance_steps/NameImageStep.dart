import 'package:app/utils/GlobalUtils.dart';
import 'package:app/widgets/ImageSelector.dart';
import 'package:app/widgets/ParentStepChild.dart';
import 'package:flutter/material.dart';



class NameImageStep extends ParentStepChild {

  DataCallback? onDataAvailable;

  NameImageStep({Key? key, this.onDataAvailable}) : super(key: key);

  final NameImageStepState theState = NameImageStepState();

  @override
  ParentStepChildState<NameImageStep> createState() => theState;

  @override
  bool canNext() {
    return theState.canNext();
  }

}

class NameImageStepState extends ParentStepChildState<NameImageStep> with AutomaticKeepAliveClientMixin<NameImageStep> {
  final TextEditingController _nameController = TextEditingController();
  String selectedImage = '';


  final formKey = GlobalKey<FormState>();


  @override
  bool canNext() {
    setState(() {

    });

    if(widget.onDataAvailable != null) {
      widget.onDataAvailable!({
        'name': _nameController.text,
        'image': selectedImage,
      });
    }

    if (formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      return true;
    }
    return false;
  }


  @override
  Widget build(BuildContext context) {


    return SizedBox(
      height: 370,
      child: Form(
        key: formKey,
        child: Column(
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
            ImageSelector(
              onDataAvailable: (data) {
                debugPrint('received from image selector: ');
                debugPrint(data.toString());
                selectedImage = data['image'];
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
