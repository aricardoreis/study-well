import 'package:meta/meta.dart';

class MatterModel {
  final String id;
  final String name;

  MatterModel({this.id, @required this.name}); // : assert(name.isNotEmpty);

  factory MatterModel.fromJson(Map<String, dynamic> json) {
    return MatterModel(
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
