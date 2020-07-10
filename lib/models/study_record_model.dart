import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_well/models/subject_model.dart';

class StudyRecordModel {
  final String id;
  final DateTime date;
  final int duration;
  final SubjectModel subject;

  StudyRecordModel({this.id, this.date, this.duration, this.subject});

  Map<String, dynamic> toJson(DocumentReference subjectRef) => <String, dynamic>{
        'duration': this.duration,
        'date': Timestamp.fromDate(this.date),
        'subject': subjectRef,
      };
}
