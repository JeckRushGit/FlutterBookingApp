import 'package:jwt_decode/jwt_decode.dart';

import 'package:progetto_ium/modules/professor.dart';

import 'course.dart';

class Teaching{
  late final Professor _professor;
  late final Course _course;

  Teaching(this._professor, this._course);

  factory Teaching.fromJson(Map<String, dynamic> json){
    return Teaching(Professor.fromJson(json['professor']),Course.fromJson(json['course']));
  }

  Course get course => _course;

  Professor get professor => _professor;

  @override
  String toString() {
    return 'Teaching{_professor: $_professor, _course: $_course}';
  }
}