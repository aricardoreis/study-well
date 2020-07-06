import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_well/models/matter_model.dart';

abstract class MatterService {
  Future<List<MatterModel>> getAll();
  Future<bool> insert(String name);
  void update(String id, String name);
  void delete(String id);
}

// Implementation of MatterService using Firebase Firestore
class MatterServiceFirebaseImpl extends MatterService {
  CollectionReference _collection = Firestore.instance.collection('matter');

  @override
  Future<List<MatterModel>> getAll() async {
    var collection = await _collection.snapshots().first;
    var list = collection.documents
        .map(
            (item) => MatterModel(id: item.documentID, name: item.data['name']))
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

// Implementation of MatterService using Shared Preferences
const MATTER_LIST = 'MATTER_LIST';

class MatterServiceSharedPrefImpl extends MatterService {
  final SharedPreferences sharedPreferences;

  MatterServiceSharedPrefImpl({@required this.sharedPreferences});

  @override
  Future<List<MatterModel>> getAll() async {
    await Future.delayed(Duration(seconds: 1));

    var list = List<MatterModel>();

    final jsonString = sharedPreferences.getString(MATTER_LIST);
    if (jsonString != null) {
      list = (json.decode(jsonString) as Iterable)
          .map((item) => MatterModel.fromJson(item))
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

    list.add(MatterModel(id: 0.toString(), name: name));

    sharedPreferences.setString(MATTER_LIST, json.encode(list));

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
