import 'package:cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:study_well/models/study_record_model.dart';
import 'package:study_well/services/study_record_service.dart';
import 'package:study_well/viewmodels/study_record/study_record_state.dart';

class StudyRecordCubit extends Cubit<StudyRecordState> {
  final StudyRecordService service;

  StudyRecordCubit({@required this.service})
      : super(StudyRecordLoadInProgress());

  loadByRange(DateTime start, DateTime end) async {
    _tryToLoad(service.retrieve(start, end));
  }

  _tryToLoad(Future<List<StudyRecordModel>> loadCall) async {
    try {
      emit(StudyRecordLoadInProgress());
      final items = await loadCall;
      emit(StudyRecordLoadSuccess(items));
    } catch (e) {
      emit(StudyRecordFailure());
    }
  }

  @override
  void onTransition(Transition<StudyRecordState> transition) {
    super.onTransition(transition);
    print(transition);
  }
}
