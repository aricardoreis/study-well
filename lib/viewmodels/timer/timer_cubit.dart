import 'package:cubit/cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

import 'package:study_well/service_locator.dart';
import 'package:study_well/util/timer_util.dart';

class TimerCubit extends Cubit<TimerState> {
  final Ticker _ticker = Ticker();

  StreamSubscription<int> _tickerSubscription;

  TimerCubit() : super(Ready(0)) {
    tryToResume().listen(
      (duration) {
        if (duration != 0 && state is Ready) {
          resume(duration);
        }
      },
    );
  }

  addInfo(String matterId){
    emit(Running(state.duration, matterId: matterId));
  }

  start() async {
    await sl<TimerService>().save();
    emit(Running(0));
    _resetTicker();
  }

  resume(int duration) {
    emit(Running(duration));
    _resetTicker(start: duration);
  }

  pause() {
    // TODO: implement pause timer
  }

  stop() async {
    await sl<TimerService>().clear();
    if (state is Running) {
      _tickerSubscription?.pause();
      emit(Finished(state.duration));
    }
  }

  cancel() async {
    await sl<TimerService>().clear();
    if (state is Running || state is Finished) {
      _tickerSubscription?.cancel();
      emit(Ready(0));
    }
  }

  _resetTicker({int start = 0}) {
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker.tick(start: start).listen(
      (duration) {
        emit(Running(duration));
      },
    );
  }

  Stream<int> tryToResume() async* {
    DateTime startTimer = await sl<TimerService>().load();
    yield startTimer != null
        ? DateTime.now().difference(startTimer).inSeconds
        : 0;
  }

  @override
  void onTransition(Transition<TimerState> transition) {
    print('TimerCubit: $transition ${transition.nextState.duration}');
    super.onTransition(transition);
  }
}

@immutable
abstract class TimerState extends Equatable {
  final int duration;
  final String matterId;

  TimerState(this.duration, {this.matterId});

  String get hourMinuteFormat => fullTimerFormat.split(':').take(2).join(':');

  String get fullTimerFormat {
    final String hours =
        ((duration / 3600) % 3600).floor().toString().padLeft(2, '0');
    final String minutes =
        (((duration % 3600) / 60) % 60).floor().toString().padLeft(2, '0');
    final String seconds =
        ((duration % 3600) % 60).floor().toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  List<Object> get props => [duration, matterId];
}

class Ready extends TimerState {
  Ready(int duration) : super(duration);
}

class Running extends TimerState {
  Running(int duration, {String matterId})
      : super(duration, matterId: matterId);
}

class Finished extends TimerState {
  Finished(int duration, {String matterId})
      : super(duration, matterId: matterId);
}
