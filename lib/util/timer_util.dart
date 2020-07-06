import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Ticker {
  Stream<int> tick({int start = 0}) {
    return Stream.periodic(Duration(seconds: 1), (x) => start + x + 1);
  }
}

const START_TIMER_KEY = 'StartTimer';
const DATETIME_FORMAT = 'MM/dd/yyyy HH:mm:ss';

abstract class TimerService {
  Future<void> save();
  Future<DateTime> load();
  Future<void> clear();
}

class TimerServiceSharedPrefsImpl extends TimerService {
  final SharedPreferences sharedPreferences;

  TimerServiceSharedPrefsImpl({@required this.sharedPreferences});

  Future<void> save() async {
    final DateTime now = DateTime.now();
    String dateAsString = DateFormat(DATETIME_FORMAT).format(now);
    print(dateAsString);
    sharedPreferences.setString(START_TIMER_KEY, dateAsString);
  }

  Future<DateTime> load() {
    DateTime time;
    if (sharedPreferences.containsKey(START_TIMER_KEY)) {
      var date = sharedPreferences.getString(START_TIMER_KEY);
      print(date);
      time = DateFormat(DATETIME_FORMAT).parse(date);
    }
    return Future.value(time);
  }

  @override
  Future<void> clear() async {
    sharedPreferences.setString(START_TIMER_KEY, null);
  }
}
