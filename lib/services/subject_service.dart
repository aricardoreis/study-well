import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_well/models/subject_model.dart';

abstract class SubjectService {
  Future<List<SubjectModel>> getAll();
  Future<bool> insert(String name);
  void update(String id, String name);
  void delete(String id);
}

// Implementation of SubjectService using Firebase Firestore
class SubjectServiceFirebaseImpl extends SubjectService {
  CollectionReference _collection = Firestore.instance.collection('subject');

  @override
  Future<List<SubjectModel>> getAll() async {
    var collection = await _collection.snapshots().first;
    var list = collection.documents
        .map((item) =>
            SubjectModel(id: item.documentID, name: item.data['name']))
        .toList();

    return list;
  }

  @override
  Future<bool> insert(String name) async {
    if (!_isValid(name)) {
      throw Exception('O nome da matéria é obrigatório.');
    }

    bool exists = await _exists(name);
    if (exists) {
      throw Exception('Já existe uma matéria cadastrada com o nome informado.');
    }
    await _collection.add({'name': name});

    return Future.value(true);
  }

  @override
  void update(String id, String name) {
    _collection.document(id).updateData({'name': name});
  }

  Future<bool> _exists(String name) async {
    var list = await getAll();
    return list.any((element) => element.name == name);
  }

  @override
  void delete(String id) {
    _collection.document(id).delete();
  }

  bool _isValid(String name) {
    return name.isNotEmpty;
  }
}

// Implementation of SubjectService using Shared Preferences
const SUBJECT_LIST = 'SUBJECT_LIST';

class SubjectServiceSharedPrefImpl extends SubjectService {
  final SharedPreferences sharedPreferences;

  SubjectServiceSharedPrefImpl({@required this.sharedPreferences});

  @override
  Future<List<SubjectModel>> getAll() async {
    await Future.delayed(Duration(seconds: 1));

    var list = List<SubjectModel>();

    final jsonString = sharedPreferences.getString(SUBJECT_LIST);
    if (jsonString != null) {
      list = (json.decode(jsonString) as Iterable)
          .map((item) => SubjectModel.fromJson(item))
          .toList();
    }

    return Future.value(list);
  }

  @override
  Future<bool> insert(String name) async {
    var list = await getAll();
    if (list.any((element) => element.name == name)) {
      throw Exception("Já existe uma matéria com o nome informado.");
    }

    list.add(SubjectModel(id: 0.toString(), name: name));

    sharedPreferences.setString(SUBJECT_LIST, json.encode(list));

    return Future.value(true);
  }

  @override
  void update(String id, String name) async {
    var list = await getAll();
    var item = list.firstWhere((element) => element.name == name);

    list.remove(item);
    insert(name);
  }

  @override
  void delete(String id) {
    // TODO: implement delete
  }
}
