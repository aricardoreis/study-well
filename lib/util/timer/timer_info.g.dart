// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimerInfo _$TimerInfoFromJson(Map<String, dynamic> json) {
  return TimerInfo(
    json['duration'] as int,
    start:
        json['start'] == null ? null : DateTime.parse(json['start'] as String),
    subjectId: json['subjectId'] as String,
    lastUpdateTime: json['lastUpdateTime'] == null
        ? null
        : DateTime.parse(json['lastUpdateTime'] as String),
  );
}

Map<String, dynamic> _$TimerInfoToJson(TimerInfo instance) => <String, dynamic>{
      'duration': instance.duration,
      'subjectId': instance.subjectId,
      'start': instance.start?.toIso8601String(),
      'lastUpdateTime': instance.lastUpdateTime?.toIso8601String(),
    };
