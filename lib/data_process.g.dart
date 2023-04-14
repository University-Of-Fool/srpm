// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_process.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Target _$TargetFromJson(Map<String, dynamic> json) => Target(
      json['name'] as String,
      json['id'] as String,
      json['targetAddress'] as String,
      json['sourceDomain'] as String,
      json['sslCert'] as String,
      json['sslCertKey'] as String,
    );

Map<String, dynamic> _$TargetToJson(Target instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'targetAddress': instance.targetAddress,
      'sourceDomain': instance.sourceDomain,
      'sslCert': instance.sslCert,
      'sslCertKey': instance.sslCertKey,
    };

TargetList _$TargetListFromJson(Map<String, dynamic> json) => TargetList(
      (json['idList'] as List<dynamic>).map((e) => e as String).toList(),
      (json['nameList'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$TargetListToJson(TargetList instance) =>
    <String, dynamic>{
      'idList': instance.idList,
      'nameList': instance.nameList,
    };
