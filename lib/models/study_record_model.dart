import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_well/models/study_type_model.dart';
import 'package:study_well/models/subject_model.dart';

class StudyRecordModel {
  final String id;
  final DateTime date;
  final int duration;
  final SubjectModel subject;
  final StudyTypeModel studyType;

  StudyRecordModel({
    this.id,
    this.date,
    this.duration,
    this.subject,
    this.studyType,
  });

  Map<String, dynamic> toJson(
    DocumentReference subjectRef,
    DocumentReference typeRef,
  ) =>
      <String, dynamic>{
        'duration': this.duration,
        'date': Timestamp.fromDate(this.date),
        'subject': subjectRef,
        'type': typeRef,
      };
}
