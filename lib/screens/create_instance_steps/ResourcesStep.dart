import 'package:app/utils/GlobalUtils.dart';
import 'package:app/widgets/ParentStepChild.dart';
import 'package:flutter/material.dart';

class ResourcesStep extends ParentStepChild {

  DataCallback? onDataAvailable;


  ResourcesStep({Key? key, this.onDataAvailable}) : super(key: key);

  _ResourcesStepState theState = _ResourcesStepState();

  @override
  ParentStepChildState<ResourcesStep> createState() => theState;

  @override
  bool canNext() {
    return theState.canNext();
  }

}

class _ResourcesStepState extends ParentStepChildState<ResourcesStep> {
  int cpuCount = 1;
  int memorySize = 1024;
  int diskSize = 5120;

  @override
  bool canNext() {
    emitData();
    return true;
  }

  dynamic emitData() {
    if(widget.onDataAvailable != null) {
      widget.onDataAvailable!({
        'cpus': cpuCount,
        'mem': memorySize * 1048576,
        'disk': diskSize * 1048576
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> bodyChildren = [];

    emitData();

    TextStyle titleTextStyle = const TextStyle(fontWeight: FontWeight.bold);
    double labelWidth = 70;

    bodyChildren.add(Text(
      'CPUs',
      style: titleTextStyle,
    ));
    bodyChildren.add(Row(
      children: [
        const Icon(
          Icons.computer,
          size: 50,
        ),
        const SizedBox(
          width: 10,
        ),
        SizedBox(width: labelWidth, child: Text(cpuCount.toString())),
        Expanded(
          child: Slider(
              value: cpuCount.toDouble(),
              min: 1,
              max: 4,
              divisions: 3,
              label: cpuCount.toString(),
              onChanged: (newVal) {
                cpuCount = newVal.toInt();
                emitData();
                setState(() {});
              }),
        )
      ],
    ));

    bodyChildren.add(const Divider());
    bodyChildren.add(Text(
      'Memory',
      style: titleTextStyle,
    ));
    bodyChildren.add(Row(
      children: [
        const Icon(
          Icons.memory,
          size: 50,
        ),
        const SizedBox(
          width: 10,
        ),
        SizedBox(
          width: labelWidth,
          child: Text(GlobalUtils.formateMBsForInstanceCreation(memorySize.toDouble())),
        ),
        Expanded(
          child: Slider(
              value: memorySize.toDouble(),
              min: 128,
              max: 8192,
              label: memorySize.toString(),
              onChanged: (newVal) {
                memorySize = newVal.toInt();
                emitData();
                setState(() {});
              }),
        )
      ],
    ));

    bodyChildren.add(const Divider());

    bodyChildren.add(Text(
      'Disk',
      style: titleTextStyle,
    ));
    bodyChildren.add(Row(
      children: [
        const Icon(
          Icons.storage,
          size: 50,
        ),
        const SizedBox(
          width: 10,
        ),
        SizedBox(
          width: labelWidth,
          child: Text(GlobalUtils.formateMBsForInstanceCreation(diskSize.toDouble())),
        ),
        Expanded(
          child: Slider(
              value: diskSize.toDouble(),
              min: 512,
              max: 102400,
              label: diskSize.toString(),
              onChanged: (newVal) {
                diskSize = newVal.toInt();
                emitData();
                setState(() {});
              }),
        )
      ],
    ));

    bodyChildren.add(const Divider());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: bodyChildren,
    );
  }
}
