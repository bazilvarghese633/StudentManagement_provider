import 'package:student_provider_try1/functions/functions.dart';

class StudentModel {
  final int? id;
  final String name;
  final int age;
  final String place;
  final String course;
  final String image;
  final String phone;

  StudentModel(
      {this.id,
      required this.name,
      required this.age,
      required this.place,
      required this.course,
      required this.image,
      required this.phone});

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columId: id,
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnAge: age,
      DatabaseHelper.columnPlace: place,
      DatabaseHelper.columnCourse: course,
      DatabaseHelper.columnImage: image,
      DatabaseHelper.columnPhone: phone
    };
  }

  StudentModel copyStudentModel({
    int? id,
    String? name,
    int? age,
    String? place,
    String? course,
    String? image,
    String? phone,
  }) {
    return StudentModel(
        id: id ?? this.id,
        name: name ?? this.name,
        age: age ?? this.age,
        place: place ?? this.place,
        course: course ?? this.course,
        image: image ?? this.image,
        phone: phone ?? this.phone);
  }
}
