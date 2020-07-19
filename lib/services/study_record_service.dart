import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_well/models/study_record_model.dart';
import 'package:study_well/models/subject_model.dart';
import 'package:study_well/services/base_service.dart';

abstract class StudyRecordService extends BaseService<StudyRecordModel> {}

class StudyRecordServiceFirebaseImpl implements StudyRecordService {
  CollectionReference _collection =
      Firestore.instance.collection('study-record');

  @override
  Future<List<StudyRecordModel>> getAll() async {
    var collection = await _collection.snapshots().first;
    var list = List<StudyRecordModel>();
    for (var snapshot in collection.documents) {
      var item = await _mapToModel(snapshot);
      list.add(item);
    }
    return list;
  }

  @override
  Future<bool> insert(StudyRecordModel item) async {
    var subjectRef =
        Firestore.instance.collection('subject').document(item.subject.id);
    var typeRef =
        Firestore.instance.collection('study-type').document(item.studyType.id);

    await _collection.add(item.toJson(subjectRef, typeRef));

    return Future.value(true);
  }

  @override
  void delete(String id) {
    // TODO: implement delete
  }

  @override
  void update(String id, String name) {
    // TODO: implement update
  }

  Future<StudyRecordModel> _mapToModel(DocumentSnapshot snapshot) async {
    var subjectData = await _getSubjectData(snapshot.data['subject']);
    return StudyRecordModel(
      id: snapshot.documentID,
      date: snapshot.data['date'].toDate(),
      duration: snapshot.data['duration'],
      subject: SubjectModel(
        id: subjectData.documentID,
        name: subjectData.data['name'],
      ),
    );
  }

  Future<DocumentSnapshot> _getSubjectData(DocumentReference subject) async {
    return await subject.get();
  }
}
