import 'package:cubit/cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_cubit/hydrated_cubit.dart';
import 'dart:async';

import 'package:study_well/util/timer/ticker.dart';
import 'package:study_well/util/timer/timer.dart';
import 'package:study_well/util/timer/timer_info.dart';

class TimerCubit extends HydratedCubit<TimerState> {
  bool _hasAlreadyLoadFromStorage = false;

  final Ticker _ticker = Ticker();

  StreamSubscription<int> _tickerSubscription;

  TimerCubit() : super(Ready());

  @override
  TimerState fromJson(Map<String, dynamic> json) {
    try {
      final info = TimerInfo.fromJson(json);
      if (info.start != null) {
        var now = DateTime.now();

        int duration = info.duration;
        if (!_hasAlreadyLoadFromStorage) {
          _hasAlreadyLoadFromStorage = true;
          duration =
              info.duration + now.difference(info.lastUpdateTime).inSeconds;

          _resetTicker(start: duration);
        }

        return Running(info.copyWith(duration: duration));
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson(TimerState state) {
    if (state is Running) {
      return state.info.toJson();
    } else {
      return TimerInfo(0).toJson();
    }
  }

  addInfo(String subjectId, DateTime start) {
    if (state is Running) {
      var currentState = state as Running;
      emit(Running(
          currentState.info.copyWith(subjectId: subjectId, start: start)));
    }
  }

  start() async {
    emit(Running(TimerInfo(0)));
    _resetTicker();
  }

  resume() {
    if (state is Running) {
      var currentState = state as Running;
      emit(Running(currentState.info.copyWith()));
      _resetTicker(start: currentState.info.duration);
    }
  }

  pause() {
    if (state is Running) {
      _tickerSubscription?.pause();
    }
  }

  stop() async {
    if (state is Running) {
      var runningState = state as Running;
      _tickerSubscription?.cancel();
      emit(Finished(runningState.info));
    }
  }

  cancel() async {
    if (state is Running || state is Finished) {
      _tickerSubscription?.cancel();
      emit(Ready());
    }
  }

  _resetTicker({int start = 0}) {
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker.tick(start: start).listen(
      (duration) {
        Running currentState = state as Running;
        emit(Running(currentState.info.copyWith(
          duration: duration,
          lastUpdateTime: DateTime.now(),
        )));
      },
    );
  }

  @override
  void onTransition(Transition<TimerState> transition) {
    print('TimerCubit: $transition');
    if (transition.nextState is Running) {
      var runningState = transition.nextState as Running;
      print(
          '[${runningState.info.start}] Duration: ${runningState.info.duration} subjectId: ${runningState.info.subjectId} [${runningState.info.lastUpdateTime}]');
    }
    super.onTransition(transition);
  }
}

@immutable
abstract class TimerState extends Equatable {
  @override
  List<Object> get props => [];
}

class Ready extends TimerState {
  Ready() : super();
}

class Finished extends TimerState {
  final TimerInfo info;
  Finished(this.info) : super();
}

class Running extends TimerState {
  final TimerInfo info;

  Running(this.info) : super();

  String get hourMinuteFormat => fullTimerFormat.split(':').take(2).join(':');
  String get fullTimerFormat => TimerUtil.durationToString(info.duration);

  @override
  List<Object> get props => [info];
}
