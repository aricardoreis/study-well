import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_well/models/study_record_model.dart';
import 'package:study_well/models/subject_model.dart';
import 'package:study_well/services/base_service.dart';

abstract class StudyRecordService extends BaseService<StudyRecordModel> {
  Future<List<StudyRecordModel>> retrieve(DateTime start, DateTime end);
}

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
  Future<List<StudyRecordModel>> retrieve(DateTime start, DateTime end) async {
    var collection = await _collection
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThanOrEqualTo: end)
        .snapshots()
        .first;

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

class StudyRecordServiceFake implements StudyRecordService {
  @override
  void delete(String id) {
    // TODO: implement delete
  }

  @override
  Future<List<StudyRecordModel>> retrieve(DateTime start, DateTime end) async {
    await Future.delayed(Duration(seconds: 1));
    start = DateTime(start.year, start.month, start.day);
    end = DateTime(end.year, end.month, end.day)
        .add(Duration(days: 1))
        .subtract(Duration(seconds: 1));

    var list = await getAll();
    return list
        .where((element) =>
            element.date.compareTo(start) >= 0 &&
            element.date.compareTo(end) <= 0)
        .toList();
  }

  @override
  Future<List<StudyRecordModel>> getAll() {
    List<SubjectModel> subjectList = [
      SubjectModel(name: 'Biologia'),
      SubjectModel(name: 'Física'),
      SubjectModel(name: 'Química'),
      SubjectModel(name: 'Geografia'),
      SubjectModel(name: 'História'),
    ];

    List<StudyRecordModel> list = [
      StudyRecordModel(
        id: '2',
        date: DateTime.now().subtract(Duration(days: 1)),
        duration: 60 * 5,
        subject: subjectList[1],
      ),
      StudyRecordModel(
        id: '3',
        date: DateTime.now().subtract(Duration(days: 2)),
        duration: 60 * 2,
        subject: subjectList[3],
      ),
      StudyRecordModel(
        id: '4',
        date: DateTime.now().subtract(Duration(days: 1)),
        duration: 60 * 15,
        subject: subjectList[4],
      ),
      StudyRecordModel(
        id: '4',
        date: DateTime.now().subtract(Duration(days: 1)),
        duration: 60 * 15,
        subject: subjectList[4],
      ),
      StudyRecordModel(
        id: '4',
        date: DateTime.now().subtract(Duration(days: 1)),
        duration: 60 * 15,
        subject: subjectList[4],
      ),
      StudyRecordModel(
        id: '4',
        date: DateTime.now().subtract(Duration(days: 1)),
        duration: 60 * 15,
        subject: subjectList[4],
      ),
      StudyRecordModel(
        id: '4',
        date: DateTime.now().subtract(Duration(days: 1)),
        duration: 60 * 15,
        subject: subjectList[4],
      ),
      StudyRecordModel(
        id: '1',
        date: DateTime.now(),
        duration: 60 * 10,
        subject: subjectList[0],
      ),
      StudyRecordModel(
        id: '1',
        date: DateTime.now().add(Duration(days: 1)),
        duration: 60 * 10,
        subject: subjectList[1],
      ),
      StudyRecordModel(
        id: '1',
        date: DateTime.now().add(Duration(days: 2)),
        duration: 60 * 20,
        subject: subjectList[2],
      ),
    ];

    return Future.value(list);
  }

  @override
  Future<bool> insert(StudyRecordModel name) {
    // TODO: implement insert
    throw UnimplementedError();
  }

  @override
  void update(String id, String name) {
    // TODO: implement update
  }
}
