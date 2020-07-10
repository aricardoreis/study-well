import 'package:flutter/material.dart';
import 'package:study_well/models/study_record_model.dart';
import 'package:study_well/services/study_record_service.dart';
import 'package:study_well/util/timer/timer.dart';

import '../service_locator.dart';

class StudyRecordPage extends StatefulWidget {
  @override
  _StudyRecordPageState createState() => _StudyRecordPageState();
}

class _StudyRecordPageState extends State<StudyRecordPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: sl<StudyRecordService>().getAll(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<StudyRecordModel> items = snapshot.data;
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
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
    // return CubitBuilder<SubjectCubit, SubjectState>(
    //   builder: (context, state) {
    //     if (state is SubjectInitialState) {
    //       return Container();
    //     } else if (state is SubjectLoadingState) {
    //       return Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     } else if (state is SubjectLoadedState) {
    //       final items = state.list;
    //       return ListView.builder(
    //         itemCount: items.length,
    //         itemBuilder: (context, index) => Card(
    //           child: ListTile(
    //             title: Text(items[index].name),
    //           ),
    //         ),
    //       );
    //     } else {
    //       return Container();
    //     }
    //   },
    // );
  }
}
