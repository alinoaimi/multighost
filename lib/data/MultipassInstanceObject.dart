

import 'MultipassDisk.dart';
import 'MultipassMemory.dart';

class MultipassInstanceObject {

  final String name;
  String? release;
  String? state;
  List<MultipassDisk>? disks;
  MultipassMemory? memory;
  List<String>? ipv4s;

  MultipassInstanceObject({required this.name, this.release, this.state, this.disks, this.memory, this.ipv4s});

}