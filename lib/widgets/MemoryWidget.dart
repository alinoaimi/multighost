import 'package:app/data/MultipassDisk.dart';
import 'package:app/data/MultipassMemory.dart';
import 'package:app/utils/GlobalUtils.dart';
import 'package:flutter/material.dart';

class MemoryWidget extends StatelessWidget {
  final MultipassMemory memory;

  MemoryWidget({Key? key, required this.memory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var chart = Container(
      height: 4,
      color: Colors.green,
      width: 100 * 2 ,
      child: Row(
        children: [
          Container(
            height: 4,
            color: Colors.yellow,
            width: ((memory.used / memory.total) * 100) * 2,
          )
        ],
      ),
    );

    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.memory),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Memory')
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  '${GlobalUtils.formatBytes(memory.used, 0)} / ${GlobalUtils.formatBytes(memory.total, 0)}',
                  style: const TextStyle(fontSize: 12),
                )
              ],
            ),
          ),
          chart
        ],
      ),
    );
  }
}
