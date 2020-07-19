import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:study_well/models/subject_model.dart';
import 'package:study_well/services/subject_service.dart';
import 'package:study_well/viewmodels/timer/timer_cubit.dart';
import 'package:study_well/viewmodels/timer/timer_state.dart';

import '../service_locator.dart';

class TimerDialog extends StatefulWidget {
  @override
  _TimerDialogState createState() => _TimerDialogState();
}

class _TimerDialogState extends State<TimerDialog> {
  String _selectedSubject;

  @override
  void initState() {
    super.initState();

    sl<TimerCubit>().start();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Adicionar estudo'),
      content: FutureBuilder(
        future: sl<SubjectService>().getAll(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var list = snapshot.data as List<SubjectModel>;
            var items = list
                .map(
                  (item) => DropdownMenuItem(
                    child: Text(item.name),
                    value: item.id,
                  ),
                )
                .toList();
            return _buildDialog(items);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
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
            Navigator.of(context).pop(true);

            sl<TimerCubit>().addInfo(_selectedSubject, DateTime.now());
          },
        ),
      ],
    );
  }

  Widget _buildDialog(List<DropdownMenuItem<String>> subjectItems) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 0.0,
              vertical: 0.0,
            ),
            leading: Icon(
              Icons.timer,
              color: Color(0xFF4C5158),
            ),
            title: CubitBuilder<TimerCubit, TimerState>(
              cubit: sl<TimerCubit>(),
              builder: (context, state) {
                if (state is Running) {
                  return Text(state.fullTimerFormat);
                } else {
                  return Text('');
                }
              },
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 0.0,
              vertical: 0.0,
            ),
            leading: Icon(
              Icons.library_books,
              color: Color(0xFF4C5158),
            ),
            title: DropdownButtonFormField<String>(
              value: _selectedSubject,
              onChanged: (value) {
                setState(() {
                  _selectedSubject = value;
                });
              },
              items: subjectItems,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Color(0xFF4C5158),
                ),
                isDense: true,
              ),
            ),
          )
        ],
      ),
    );
  }
}
