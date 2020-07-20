import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:study_well/models/study_record_model.dart';
import 'package:study_well/util/timer/timer.dart';
import 'package:study_well/viewmodels/study_record/study_record_cubit.dart';
import 'package:study_well/viewmodels/study_record/study_record_state.dart';
import 'package:table_calendar/table_calendar.dart';

import '../service_locator.dart';
import 'calendar_page.dart';

class StudyRecordPage extends StatefulWidget {
  @override
  _StudyRecordPageState createState() => _StudyRecordPageState();
}

class _StudyRecordPageState extends State<StudyRecordPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CalendarPage(
          onCalendarCreated: (start, end, _) {
            sl<StudyRecordCubit>().loadByRange(start, end);
          },
          onVisibleDaysChanged: _onVisibleDaysChanged,
          onDaySelected: _onDaySelected,
        ),
        Expanded(
          child: CubitBuilder<StudyRecordCubit, StudyRecordState>(
            cubit: sl<StudyRecordCubit>(),
            builder: (context, state) {
              if (state is StudyRecordLoadInProgress) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is StudyRecordLoadSuccess) {
                final List<StudyRecordModel> items = state.list;
                if (items.length == 0) {
                  return Center(
                    child: Text(
                      'Não há estudos para o período selecionado.',
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) => Card(
                      child: ListTile(
                        leading: Text(
                          TimerUtil.dateToString(items[index].date),
                        ),
                        title: Row(
                          children: <Widget>[
                            Icon(
                              Icons.timer,
                              size: 16,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              TimerUtil.durationToString(items[index].duration),
                            ),
                          ],
                        ),
                        trailing: Text(items[index].subject.name),
                      ),
                    ),
                  );
                }
              }
              return Container();
            },
          ),
        ),
      ],
    );
  }

  _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat calendarFormat) {
    sl<StudyRecordCubit>().loadByRange(first, last);
  }

  _onDaySelected(DateTime day, List events) {
    
  }
}
