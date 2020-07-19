import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:study_well/util/timer/timer.dart';
import 'package:study_well/util/timer/timer_info.dart';

@immutable
abstract class TimerState extends Equatable {
  TimerState();

  @override
  List<Object> get props => [];
}

class Ready extends TimerState {
  Ready() : super();
}

class Working extends TimerState {
  final TimerInfo info;

  Working(this.info);

  String get hourMinuteFormat => fullTimerFormat.split(':').take(2).join(':');
  String get fullTimerFormat => TimerUtil.durationToString(info.duration);

  @override
  List<Object> get props => [info];

  factory Working.fromJson(Map<String, dynamic> json) {
    TimerStateEnum timerStateEnum = TimerStateEnum.values[json['timerState']];
    TimerInfo timerInfo = TimerInfo(
      json['duration'] as int,
      start: json['start'] == null
          ? null
          : DateTime.parse(json['start'] as String),
      subjectId: json['subjectId'] as String,
      lastUpdateTime: json['lastUpdateTime'] == null
          ? null
          : DateTime.parse(json['lastUpdateTime'] as String),
    );
    return timerStateEnum == TimerStateEnum.Running ? Running(timerInfo) : Paused(timerInfo);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'duration': info.duration,
        'subjectId': info.subjectId,
        'start': info.start?.toIso8601String(),
        'lastUpdateTime': info.lastUpdateTime?.toIso8601String(),
        'timerState':
            this is Running ? TimerStateEnum.Running.index : TimerStateEnum.Paused.index,
      };
}

class Finished extends Working {
  Finished(TimerInfo info) : super(info);
}

class Paused extends Working {
  Paused(TimerInfo info) : super(info);
}

class Running extends Working {
  Running(TimerInfo info) : super(info);
}

enum TimerStateEnum { Running, Paused }
