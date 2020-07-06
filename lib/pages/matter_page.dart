import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:study_well/viewmodels/matter/matter_cubit.dart';

class MatterPage extends StatefulWidget {
  @override
  _MatterPageState createState() => _MatterPageState();
}

class _MatterPageState extends State<MatterPage> {
  @override
  Widget build(BuildContext context) {
    return CubitBuilder<MatterCubit, MatterState>(
      builder: (context, state) {
        if (state is MatterInitialState) {
          return Container();
        } else if (state is MatterLoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is MatterLoadedState) {
          final items = state.list;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) => Card(
              child: ListTile(
                title: Text(items[index].name),
                // leading: CircleAvatar(
                //   backgroundImage: NetworkImage(items[index].urlImage),
                // ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
    // return Center(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: <Widget>[
    //       Text(
    //         'Não há matérias cadastradas',
    //       ),
    //     ],
    //   ),
    // );
  }
}
