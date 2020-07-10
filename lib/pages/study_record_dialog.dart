import 'package:flutter/material.dart';
import 'package:study_well/models/study_record_model.dart';
import 'package:study_well/models/subject_model.dart';
import 'package:study_well/services/study_record_service.dart';
import 'package:study_well/util/timer/timer.dart';
import 'package:study_well/util/timer/timer_info.dart';
import 'package:study_well/viewmodels/timer/timer_cubit.dart';

import '../service_locator.dart';

class StudyRecordDialog extends StatefulWidget {
  final String subject;
  final int duration;

  const StudyRecordDialog({Key key, this.subject, this.duration})
      : super(key: key);

  @override
  _StudyRecordDialogState createState() => _StudyRecordDialogState();
}

class _StudyRecordDialogState extends State<StudyRecordDialog> {
  TimerInfo info;

  @override
  void initState() {
    var timerState = sl<TimerCubit>().state as Finished;
    info = timerState.info;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Salvar estudo"),
      content: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.library_books),
            title: Text(widget.subject),
          ),
          ListTile(
            leading: Icon(Icons.timer),
            title: Text(TimerUtil.durationToString(widget.duration)),
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Cancelar"),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        FlatButton(
          child: Text("Salvar"),
          onPressed: () async {
            await sl<StudyRecordService>().insert(
              StudyRecordModel(
                date: info.start,
                duration: info.duration,
                subject: SubjectModel(id: info.subjectId, name: ''),
              ),
            );
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
