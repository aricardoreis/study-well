import 'package:flutter/material.dart';

import 'package:study_well/service_locator.dart';
import 'package:study_well/viewmodels/subject/subject_cubit.dart';

class SubjectDialog extends StatefulWidget {
  @override
  _SubjectDialogState createState() => _SubjectDialogState();
}

class _SubjectDialogState extends State<SubjectDialog> {
  final TextEditingController _subjectNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Adicionar matéria"),
      content: Container(
        child: TextField(
          controller: _subjectNameController,
          autofocus: true,
          maxLength: 20,
          decoration: InputDecoration(
            hintText: 'Digite o nome',
          ),
        ),
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
            String name = _subjectNameController.text;
            print('-> Subject.name: $name');

            await sl<SubjectCubit>().add(name);

            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
