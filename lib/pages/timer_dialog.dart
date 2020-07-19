import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:study_well/models/study_type_model.dart';
import 'package:study_well/models/subject_model.dart';
import 'package:study_well/services/study_type_service.dart';
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
  String _selectedStudyType;

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
        future: Future.wait([
          sl<SubjectService>().getAll(),
          sl<StudyTypeService>().getAll(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var subjectList = snapshot.data[0] as List<SubjectModel>;
            var studyTypeList = snapshot.data[1] as List<StudyTypeModel>;

            var subjectItems = subjectList
                .map(
                  (item) => DropdownMenuItem(
                    child: Text(item.name),
                    value: item.id,
                  ),
                )
                .toList();

            var typeItems = studyTypeList
                .map(
                  (item) => DropdownMenuItem(
                    child: Text(item.name),
                    value: item.id,
                  ),
                )
                .toList();

            return _buildDialog(subjectItems, typeItems);
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
            if (_selectedSubject != null) {
              Navigator.of(context).pop(true);

              sl<TimerCubit>().addInfo(
                _selectedSubject,
                _selectedStudyType,
                DateTime.now(),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildDialog(
    List<DropdownMenuItem<String>> subjectItems,
    List<DropdownMenuItem<String>> typeItems,
  ) {
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
          _buildDropDownItem(
            subjectItems,
            _selectedSubject,
            _onSubjectChanged,
            Icons.library_books,
          ),
          _buildDropDownItem(
            typeItems,
            _selectedStudyType,
            _onTypeChanged,
            Icons.merge_type,
          ),
        ],
      ),
    );
  }

  ListTile _buildDropDownItem(
    List<DropdownMenuItem<String>> items,
    String selectedValue,
    ValueChanged<String> onChanged,
    IconData iconData,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: 0.0,
        vertical: 0.0,
      ),
      leading: Icon(
        iconData,
        color: Color(0xFF4C5158),
      ),
      title: DropdownButtonFormField<String>(
        value: selectedValue,
        onChanged: onChanged,
        items: items,
        decoration: InputDecoration(
          labelStyle: TextStyle(
            color: Color(0xFF4C5158),
          ),
          isDense: true,
        ),
      ),
    );
  }

  _onSubjectChanged(value) {
    setState(() {
      _selectedSubject = value;
    });
  }

  _onTypeChanged(value) {
    setState(() {
      _selectedStudyType = value;
    });
  }
}
