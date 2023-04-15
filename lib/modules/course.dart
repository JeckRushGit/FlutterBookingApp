


import '../calendarpage/dropdown/dropdownitem.dart';

class Course implements DropDownItem{
  final String _course_titol;

  @override
  String get label =>  _course_titol;

  Course(this._course_titol);

  factory Course.fromJson(Map<String,dynamic> json){
    return Course(json['course_titol']);
  }


  String get course_titol => _course_titol;

  @override
  String toString() {
    return 'Course{course_titol: $_course_titol}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Course &&
          runtimeType == other.runtimeType &&
          _course_titol == other._course_titol;

  @override
  int get hashCode => _course_titol.hashCode;

  int compareTo(Course other){
    return this._course_titol.compareTo(other.course_titol);
  }
}