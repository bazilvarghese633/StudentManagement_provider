import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_provider_try1/Model/model.dart';
import 'package:student_provider_try1/functions/functions.dart';

class HomePageProvider extends ChangeNotifier {
  late DatabaseHelper databaseHelper;
  List<StudentModel> students = [];
  List<StudentModel> filteredStudents = [];
  bool noResult = false;
  String? profileImagepath;
  XFile? image;
  StudentModel? currentStudent;

  HomePageProvider() {
    databaseHelper = DatabaseHelper();
  }

  Future<void> updateStudent(StudentModel updatedstudent) async {
    await databaseHelper.updateStudent(updatedstudent);
    await refreshStudentList();
  }

  void filterStudents(String query) {
    final lowerCaseQuery = query.toLowerCase();
    if (lowerCaseQuery.isEmpty) {
      filteredStudents = List.from(students);
      noResult = false;
    } else {
      filteredStudents = students.where((student) {
        return student.name.toLowerCase().contains(lowerCaseQuery);
      }).toList();
      noResult = filteredStudents.isEmpty;
    }

    notifyListeners();
  }

  Future<void> refreshStudentList() async {
    final studentList = await databaseHelper.getAllStudents();
    students = studentList;
    filteredStudents = students;
    noResult = false;
    notifyListeners();
  }

  void setImage(XFile? img) {
    image = img;
    profileImagepath = img?.path;
    notifyListeners();
  }

  void clearImage() {
    image = null;
    profileImagepath = null;
    notifyListeners();
  }
}
