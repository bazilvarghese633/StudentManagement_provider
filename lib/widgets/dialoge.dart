import 'dart:io';

import 'package:flutter/material.dart';
import 'package:student_provider_try1/Model/model.dart';
import 'package:student_provider_try1/Presentation/Details/details.dart';
import 'package:student_provider_try1/core/colors.dart';
import 'package:student_provider_try1/core/constants.dart';
import 'package:student_provider_try1/widgets/delete_dialog.dart';

class StudentDialog {
  static void showStudentDialog(BuildContext context, StudentModel student) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: student.image.isNotEmpty &&
                              File(student.image).existsSync()
                          ? FileImage(File(student.image))
                          : const AssetImage('assets/defalult_avathar.png'),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ScreenUpdate(student: student)));
                        },
                        icon: const Icon(Icons.edit_note_outlined))
                  ],
                ),
                dailogeText('NAME: ${student.name}'),
                kheight10,
                dailogeText('AGE: ${student.age}'),
                kheight10,
                dailogeText('COURSE: ${student.course}'),
                kheight10,
                dailogeText('PLACE: ${student.place}'),
                kheight10,
                dailogeText('PHONE: ${student.phone}'),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      DeleteDialog.deleteDailog(context, student);
                    },
                    icon: const Icon(Icons.delete),
                    color: greyColor,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Close',
                        style: TextStyle(color: greyColor),
                      ))
                ],
              )
            ],
          );
        });
  }

  static Text dailogeText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}
