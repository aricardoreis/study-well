import 'package:flutter/material.dart';

import 'package:study_well/service_locator.dart';
import 'package:study_well/viewmodels/matter/matter_cubit.dart';

class MatterDialog extends StatefulWidget {
  @override
  _MatterDialogState createState() => _MatterDialogState();
}

class _MatterDialogState extends State<MatterDialog> {
  final TextEditingController _matterNameController = TextEditingController();

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
          controller: _matterNameController,
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
            String name = _matterNameController.text;
            print('-> Matter.name: $name');

            await sl<MatterCubit>().add(name);

            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
