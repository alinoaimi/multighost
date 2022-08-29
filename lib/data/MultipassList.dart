// To parse this JSON data, do
//
//     final MultipassList = MultipassListFromJson(jsonString);

import 'dart:convert';

// MultipassList MultipassListFromJson(String str) => MultipassList.fromJson(json.decode(str));
//
// String MultipassListToJson(MultipassList data) => json.encode(data.toJson());

class MultipassList {
  MultipassList({
    required this.list,
  });

  List<MultipassListElement> list;

  factory MultipassList.fromJson(Map<String, dynamic> json) => MultipassList(
    list: List<MultipassListElement>.from(json["list"].map((x) => MultipassListElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "list": List<dynamic>.from(list.map((x) => x.toJson())),
  };
}

class MultipassListElement {
  MultipassListElement({
    this.ipv4,
    required this.name,
    this.release,
    this.state,
  });

  List<dynamic>? ipv4;
  String name;
  String? release;
  String? state;

  factory MultipassListElement.fromJson(Map<String, dynamic> json) => MultipassListElement(
    ipv4: List<dynamic>.from(json["ipv4"].map((x) => x)),
    name: json["name"],
    release: json["release"],
    state: json["state"],
  );

  Map<String, dynamic> toJson() => {
    "ipv4": List<dynamic>.from(ipv4!.map((x) => x)),
    "name": name,
    "release": release,
    "state": state,
  };
}
