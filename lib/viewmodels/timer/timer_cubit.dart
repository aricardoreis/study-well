import 'dart:async';

import 'package:cubit/cubit.dart';
import 'package:hydrated_cubit/hydrated_cubit.dart';
import 'package:study_well/util/timer/ticker.dart';
import 'package:study_well/util/timer/timer_info.dart';
import 'package:study_well/viewmodels/timer/timer_state.dart';

class TimerCubit extends HydratedCubit<TimerState> {
  bool _hasAlreadyLoadFromStorage = false;

  final Ticker _ticker = Ticker();

  StreamSubscription<int> _tickerSubscription;

  TimerCubit() : super(Ready());

  @override
  TimerState fromJson(Map<String, dynamic> json) {
    try {
      final state = Working.fromJson(json);
      var info = state.info;
      if (info.start != null) {
        var now = DateTime.now();

        int duration = info.duration;
        if (!_hasAlreadyLoadFromStorage && state is Running) {
          _hasAlreadyLoadFromStorage = true;
          duration =
              info.duration + now.difference(info.lastUpdateTime).inSeconds;

          _resetTicker(start: duration);
        }

        return state;
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson(TimerState state) {
    if (state is Working) {
      return state.toJson();
    } else {
      return null;
      // return Working(null).toJson();
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
    if (state is Paused) {
      var currentState = state as Working;
      emit(Running(currentState.info.copyWith()));
      _resetTicker(start: currentState.info.duration);
    }
  }

  pause() {
    if (state is Running) {
      var runningState = state as Running;
      _tickerSubscription?.pause();
      emit(Paused(runningState.info));
    }
  }

  stop() async {
    if (state is Running || state is Paused) {
      var info =
          state is Running ? (state as Running).info : (state as Paused).info;
      _tickerSubscription?.cancel();
      emit(Finished(info));
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
