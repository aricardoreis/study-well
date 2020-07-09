import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:study_well/viewmodels/subject/subject_cubit.dart';

class SubjectPage extends StatefulWidget {
  @override
  _SubjectPageState createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  @override
  Widget build(BuildContext context) {
    return CubitBuilder<SubjectCubit, SubjectState>(
      builder: (context, state) {
        if (state is SubjectInitialState) {
          return Container();
        } else if (state is SubjectLoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is SubjectLoadedState) {
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
