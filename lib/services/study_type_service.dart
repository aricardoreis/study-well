import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_well/models/study_type_model.dart';
import 'package:study_well/services/base_service.dart';

abstract class StudyTypeService extends BaseService<StudyTypeModel> {}

class StudyTypeServiceFirebaseImpl implements StudyTypeService {
  CollectionReference _collection = Firestore.instance.collection('study-type');

  @override
  void delete(String id) {}

  @override
  Future<List<StudyTypeModel>> getAll() async {
    var collection = await _collection.snapshots().first;
    return collection.documents
        .map(
          (item) => StudyTypeModel(
            id: item.documentID,
            name: item.data['name'],
          ),
        )
        .toList();
  }

  @override
  Future<bool> insert(StudyTypeModel name) {
    throw UnimplementedError();
  }

  @override
  void update(String id, String name) {}
}
