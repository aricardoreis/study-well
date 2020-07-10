import 'package:intl/intl.dart';

class TimerUtil {
  static String durationToString(int duration) {
    final String hours =
        ((duration / 3600) % 3600).floor().toString().padLeft(2, '0');
    final String minutes =
        (((duration % 3600) / 60) % 60).floor().toString().padLeft(2, '0');
    final String seconds =
        ((duration % 3600) % 60).floor().toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  static String dateToString(DateTime date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }
}
