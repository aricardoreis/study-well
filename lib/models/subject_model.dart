import 'package:meta/meta.dart';

class SubjectModel {
  final String id;
  final String name;

  SubjectModel({this.id, @required this.name}); // : assert(name.isNotEmpty);

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
