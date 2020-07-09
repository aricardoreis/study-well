import 'package:cubit/cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:study_well/models/subject_model.dart';
import 'package:study_well/services/subject_service.dart';

class SubjectCubit extends Cubit<SubjectState> {
  final SubjectService service;

  SubjectCubit({@required this.service}) : super(SubjectInitialState()) {
    _getSubjectList();
  }

  Future<void> loadList() async {
    await _getSubjectList();
  }

  Future<void> add(String name) async {
    await service.insert(name);
  }

  Future<void> _getSubjectList() async {
    try {
      emit(SubjectLoadingState());
      final items = await service.getAll();
      emit(SubjectLoadedState(items));
    } catch (e) {
      emit(SubjectErrorState(e.toString()));
    }
  }

  @override
  void onTransition(Transition<SubjectState> transition) {
    print(transition);
    super.onTransition(transition);
  }
}

@immutable
abstract class SubjectState extends Equatable {}

class SubjectInitialState extends SubjectState {
  @override
  List<Object> get props => [];
}

class SubjectLoadingState extends SubjectState {
  @override
  List<Object> get props => [];
}

class SubjectLoadedState extends SubjectState {
  SubjectLoadedState(this.list);

  final List<SubjectModel> list;

  @override
  List<Object> get props => [list];
}

class SubjectErrorState extends SubjectState {
  final String message;

  SubjectErrorState(this.message);

  @override
  List<Object> get props => [];
}
