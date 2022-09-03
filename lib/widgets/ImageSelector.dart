import 'dart:convert';
import 'dart:io';

import 'package:app/utils/GlobalUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';

import '../data/MultipassImage.dart';

class ImageSelector extends StatefulWidget {
  const ImageSelector({Key? key}) : super(key: key);

  @override
  State<ImageSelector> createState() => _ImageSelectorState();
}

class BoxSelectorItem {
  final String id;
  final String label;
  final String assetImage;
  Color? color;

  BoxSelectorItem(
      {required this.id,
      required this.label,
      required this.assetImage,
      this.color});
}

class _ImageSelectorState extends State<ImageSelector> {
  MultipassImage? selectedImage = null;
  String? selectedImageGroup = 'ubuntu';

  List<MultipassImage> imagesList = [];
  List<BoxSelectorItem> boxItems = [];

  loadImagesList() async {
    var result = await Process.run('multipass', ['find', '--format=json']);
    try {
      imagesList = [];
      var rawList = json.decode(result.stdout)['images'];
      rawList.forEach((final String imageName, final rawImage) {
        List<String> aliases = [];
        for (dynamic alias in rawImage['aliases']) {
          aliases.add(alias.toString());
        }

        MultipassImage multipassImage = MultipassImage(
          name: imageName,
          os: rawImage['os'],
          release: rawImage['release'],
          remote: rawImage['remote'],
          version: rawImage['version'],
          aliases: aliases,
        );
        imagesList.add(multipassImage);
      });
    } catch (ex) {
      // TODO handle the exception
      debugPrint('error at loadImagesList');
      debugPrint(ex.toString());
    }

    generateBoxItems();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    loadImagesList();
  }

  generateBoxItems() {
    boxItems = [];
    // boxes selector
    // add ubuntu
    if (imagesList
        .where((element) => element.os?.toLowerCase() == 'ubuntu')
        .isNotEmpty) {
      boxItems.add(BoxSelectorItem(
          id: 'ubuntu',
          label: 'Ubuntu',
          assetImage: 'assets/images/ubuntu-logo.png',
          color: const Color.fromRGBO(253, 63, 0, 1)));
    }
    // add docker
    if (imagesList
        .where((element) => element.name.toLowerCase().contains('docker'))
        .isNotEmpty) {
      boxItems.add(BoxSelectorItem(
          id: 'docker',
          label: 'Docker',
          assetImage: 'assets/images/docker-logo.png',
          color: const Color.fromRGBO(0, 153, 244, 1)));
    }
    // add minikube
    if (imagesList
        .where((element) => element.name.toLowerCase().contains('minikube'))
        .isNotEmpty) {
      boxItems.add(BoxSelectorItem(
          id: 'minikube',
          label: 'Minikube',
          assetImage: 'assets/images/minikube-logo.png',
          color: const Color.fromRGBO(0, 194, 210, 1)));
    }
    // add jellyfin
    if (imagesList
        .where((element) => element.name.toLowerCase().contains('jellyfin'))
        .isNotEmpty) {
      boxItems.add(BoxSelectorItem(
          id: 'jellyfin',
          label: 'Jellyfin',
          assetImage: 'assets/images/jellyfin-logo.png',
          color: const Color.fromRGBO(111, 116, 209, 1)));
    }
    // add others
    if (true) {
      boxItems.add(BoxSelectorItem(
          id: 'others',
          label: 'Others',
          assetImage: 'assets/images/vm-icon.png',
          color: Colors.black));
    }
  }

  generateList(group) {
    List<MultipassImage> list = [];

    if (group == 'others') {
      list = imagesList.where((imageElement) {
        if (boxItems
            .where((boxElement) =>
                imageElement.name.toLowerCase().contains(boxElement.id))
            .toList()
            .isNotEmpty) {
          return false;
        }

        if (boxItems
            .where(
                (boxElement) => boxElement.id == imageElement.os!.toLowerCase())
            .toList()
            .isNotEmpty) {
          return false;
        }

        return true;
      }).toList();
    } else {
      list = imagesList
          .where((element) =>
              element.name == selectedImageGroup ||
              element.os!.toLowerCase() == selectedImageGroup)
          .toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> bodyChildren = [];

    // // add anbox
    // if (imagesList
    //     .where((element) => element.name.toLowerCase().contains('anbox'))
    //     .isNotEmpty) {
    //   boxItems.add(BoxSelectorItem(
    //       id: 'anbox-cloud-appliance',
    //       label: 'Anbox',
    //       assetImage: 'assets/images/jellyfin-logo.png'));
    // }

    // Selector grid
    List<Widget> wrapChildren = [];

    for (BoxSelectorItem boxSelectorItem in boxItems) {
      bool isSelected = selectedImageGroup == boxSelectorItem.id;

      var boxWidget = Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 10, 10),
        decoration: BoxDecoration(
            color: isSelected ? boxSelectorItem.color?.withOpacity(0.1) : null,
            border: Border.all(
              color: isSelected
                  ? boxSelectorItem.color!
                  : const Color.fromRGBO(168, 168, 168, 1.0),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        // duration: const Duration(milliseconds: 100),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          onTap: () async {
            // await FlutterPlatformAlert.playAlertSound();
            selectedImageGroup = boxSelectorItem.id;
            selectedImage = generateList(selectedImageGroup).last;
            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  boxSelectorItem.assetImage,
                  height: 70,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(boxSelectorItem.label)
              ],
            ),
          ),
        ),
      );

      wrapChildren.add(boxWidget);
      // wrapChildren.add(SizedBox(width: GlobalUtils.standardPaddingOne,));
    }

    Wrap wrapBox = Wrap(
      children: wrapChildren,
    );

    bodyChildren.add(const Text('Type'));
    bodyChildren.add(SizedBox(
      height: GlobalUtils.standardPaddingOne,
    ));
    bodyChildren.add(wrapBox);

    List<DropdownMenuItem<String>> imageItems = [];

    if (selectedImageGroup != 'others' &&
        selectedImage != null &&
        selectedImage?.release != null) {
      BoxSelectorItem selectedBoxItem =
          boxItems.singleWhere((element) => element.id == selectedImageGroup);
      bodyChildren.add(Container(
          // duration: const Duration(milliseconds: 150),
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: selectedBoxItem.color?.withOpacity(0.1),
              border: Border.all(
                color: selectedBoxItem.color!,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Text('${selectedImage?.release}')));
      bodyChildren.add(SizedBox(height: GlobalUtils.standardPaddingOne,));
    }

    int index = -1;
    for (MultipassImage multipassImage in generateList(selectedImageGroup)) {
      index++;
      imageItems.add(DropdownMenuItem(
          value: multipassImage.name, child: Text(multipassImage.name)));
    }

    bodyChildren.add(DropdownButtonFormField(
        validator: (value) {
          if (value == null) {
            return 'Required';
          }
          return null;
        },
        decoration: const InputDecoration(labelText: 'Image'),
        items: imageItems,
        value: selectedImage?.name,
        onChanged: (newVal) {
          selectedImage = imagesList
              .singleWhere((element) => element.name == newVal.toString());
          setState(() {});
        }));

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: bodyChildren,
    );
  }
}
