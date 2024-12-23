import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:student_provider_try1/Model/model.dart';
import 'package:student_provider_try1/Provider/addscreenprovider.dart';
import 'package:student_provider_try1/core/colors.dart';
import 'package:student_provider_try1/core/constants.dart';
import 'package:student_provider_try1/functions/functions.dart';
import 'package:student_provider_try1/widgets/textformfield.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({super.key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final nameEditingController = TextEditingController();
  final ageEditingController = TextEditingController();
  final placeController = TextEditingController();
  final courseController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: greyColor,
        centerTitle: true,
        title: const Text(
          'Add Student',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Consumer<AddPageProvider>(
                  builder: (context, addpageProvider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: InkWell(
                        onTap: () async {
                          final image = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            addpageProvider.setImage(image);
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: greyColor,
                          radius: 70,
                          backgroundImage:
                              addpageProvider.profileImagepath != null
                                  ? FileImage(
                                      File(addpageProvider.profileImagepath!))
                                  : null,
                          child: addpageProvider.profileImagepath != null &&
                                  addpageProvider.profileImagepath!.isEmpty
                              ? const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: whiteColor,
                                )
                              : null,
                        ),
                      ),
                    ),
                    kheight20,
                    CustomTextformField(
                        controller: nameEditingController,
                        labelText: 'Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name is required';
                          }
                          if (RegExp(r'\d').hasMatch(value)) {
                            return 'Numbers are not allowed';
                          }
                          if (RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                              .hasMatch(value)) {
                            return 'Special characters are not allowed';
                          }
                          return null;
                        }),
                    kheight10,
                    CustomTextformField(
                        controller: ageEditingController,
                        labelText: 'Age',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Age is required';
                          }
                          if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                            return 'Only numbers are allowed';
                          }
                          if (value.length >= 3 || value.length <= 1) {
                            return 'Enter valid age';
                          }
                          return null;
                        }),
                    kheight10,
                    CustomTextformField(
                        controller: courseController,
                        labelText: 'Course',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Course is required';
                          }
                          if (RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                              .hasMatch(value)) {
                            return 'Special characters are not allowed';
                          }
                          return null;
                        }),
                    kheight10,
                    CustomTextformField(
                        controller: phoneController,
                        labelText: 'Phone',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone is required';
                          }
                          if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                            return 'Only numbers are allowed';
                          }
                          if (value.length < 10 || value.length > 10) {
                            return 'Enter valid phone number';
                          }
                          return null;
                        }),
                    kheight10,
                    CustomTextformField(
                        controller: placeController,
                        labelText: 'Place',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Place is required';
                          }
                          if (RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                              .hasMatch(value)) {
                            return 'Special characters are not allowed';
                          }
                          return null;
                        }),
                    kheight10,
                    ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            if (addpageProvider.profileImagepath!.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Please select an image'),
                                duration: Duration(seconds: 2),
                              ));
                            } else {
                              addStudentButtonClicked();
                              Navigator.of(context);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: greyColor),
                        child: const Text(
                          'Submit',
                          style: TextStyle(fontSize: 17, color: whiteColor),
                        ))
                  ],
                );
              }),
            )),
      ),
    );
  }

  Future<void> addStudentButtonClicked() async {
    try {
      final name = nameEditingController.text.trim();
      final age = ageEditingController.text.trim();
      final place = placeController.text.trim();
      final course = courseController.text.trim();
      final phone = phoneController.text.trim();
      final profileImgPath =
          Provider.of<AddPageProvider>(context, listen: false)
              .profileImagepath!;

      if (name.isEmpty ||
          age.isEmpty ||
          place.isEmpty ||
          course.isEmpty ||
          phone.isEmpty) {
        return;
      }

      final student = StudentModel(
        id: null,
        name: name,
        age: int.parse(age),
        place: place,
        course: course,
        image: profileImgPath,
        phone: phone,
      );

      // Insert the student
      await databaseHelper.insertStudent(student);

      // Clear all fields
      nameEditingController.clear();
      ageEditingController.clear();
      placeController.clear();
      courseController.clear();
      phoneController.clear();

      // Clear the selected image from provider
      Provider.of<AddPageProvider>(context, listen: false).clearImage();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Student  added successfully'),
        duration: Duration(seconds: 2),
      ));

      // Go back to the home screen (assuming it's the previous screen)
      Navigator.pop(
          context); // This pops the current screen (AddStudent) from the stack and goes back

      if (kDebugMode) {
        print('Student details added successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding student details: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to add student details'),
        duration: Duration(seconds: 2),
      ));
    }
  }
}
