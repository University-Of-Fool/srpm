///
/// SRPM - the Simple Reverse Proxy Manager
/// (c) 2023 the University of Fool
///
/// This file is used to store and parse json data
///

import 'package:json_annotation/json_annotation.dart';

part 'data_process.g.dart';

@JsonSerializable()
class Target {
  Target(this.name, this.id, this.targetAddress, this.sourceDomain,
      this.sslCert, this.sslCertKey);

  String name;

  String id;

  String targetAddress;

  String sourceDomain;

  String sslCert;

  String sslCertKey;

  factory Target.fromJson(Map<String, dynamic> json) => _$TargetFromJson(json);

  Map<String, dynamic> toJson() => _$TargetToJson(this);
}

@JsonSerializable()
class TargetList {
  TargetList(this.idList, this.nameList);

  List<String> idList;
  List<String> nameList;

  factory TargetList.fromJson(Map<String, dynamic> json) =>
      _$TargetListFromJson(json);

  Map<String, dynamic> toJson() => _$TargetListToJson(this);
}
