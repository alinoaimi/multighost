import 'package:app/data/MultipassDisk.dart';
import 'package:app/utils/GlobalUtils.dart';
import 'package:flutter/material.dart';

class DiskWidget extends StatelessWidget {
  final MultipassDisk disk;

  const DiskWidget({Key? key, required this.disk}) : super(key: key);

  @override
  Widget build(BuildContext context) {



    var chart = Container(
      height: 4,
      color: Colors.green,
      width:100 * 2,
      child: Row(
        children: [
          Container(
            height: 4,
            color: Colors.yellow,
            width: ((disk.used / disk.total) * 100) * 2,
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
                  children: [
                    const Icon(Icons.storage),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(disk.name)
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  '${GlobalUtils.formatBytes(disk.used, 0)} / ${GlobalUtils.formatBytes(disk.total, 0)}',
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
