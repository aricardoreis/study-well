import 'package:equatable/equatable.dart';
import 'package:study_well/models/study_record_model.dart';

abstract class StudyRecordState extends Equatable {
  const StudyRecordState();

  @override
  List<Object> get props => [];
}

class StudyRecordLoadInProgress extends StudyRecordState {}

class StudyRecordLoadSuccess extends StudyRecordState {
  final List<StudyRecordModel> list;

  const StudyRecordLoadSuccess([this.list = const []]);

  @override
  List<Object> get props => [list];

  @override
  String toString() => 'StudyRecordLoadSuccess { items: $list }';
}

class StudyRecordFailure extends StudyRecordState {}