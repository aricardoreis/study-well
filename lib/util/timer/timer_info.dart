import 'package:json_annotation/json_annotation.dart';

part 'timer_info.g.dart';

@JsonSerializable()
class TimerInfo {
  final int duration;
  final String subjectId;
  final String type;

  // This value is necessary only to know on which day the timer has started.
  final DateTime start;

  // Persists last update time to try to resume appropriately in case the app closes in running state.
  final DateTime lastUpdateTime;

  TimerInfo(
    this.duration, {
    this.start,
    this.subjectId,
    this.type,
    this.lastUpdateTime,
  });

  factory TimerInfo.fromJson(Map<String, dynamic> json) =>
      _$TimerInfoFromJson(json);
  Map<String, dynamic> toJson() => _$TimerInfoToJson(this);

  TimerInfo copyWith({
    int duration,
    String subjectId,
    String type,
    DateTime start,
    DateTime lastUpdateTime,
  }) {
    return TimerInfo(
      duration ?? this.duration,
      subjectId: subjectId ?? this.subjectId,
      type: type ?? this.type,
      start: start ?? this.start,
      lastUpdateTime: lastUpdateTime ?? this.lastUpdateTime,
    );
  }
}
