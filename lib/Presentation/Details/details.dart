import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:student_provider_try1/Model/model.dart';
import 'package:student_provider_try1/Presentation/Home/home.dart';
import 'package:student_provider_try1/Provider/home_provider.dart';
import 'package:student_provider_try1/core/colors.dart';
import 'package:student_provider_try1/core/constants.dart';
import 'package:student_provider_try1/widgets/textformfield.dart';

class ScreenUpdate extends StatefulWidget {
  const ScreenUpdate({super.key, required this.student});
  final StudentModel student;

  @override
  State<ScreenUpdate> createState() => _ScreenUpdateState();
}

class _ScreenUpdateState extends State<ScreenUpdate> {
  late TextEditingController nameController =
      TextEditingController(text: widget.student.name);
  late TextEditingController ageController =
      TextEditingController(text: widget.student.age.toString());
  late TextEditingController courseController =
      TextEditingController(text: widget.student.course);
  late TextEditingController placeController =
      TextEditingController(text: widget.student.place);
  late TextEditingController phoneController =
      TextEditingController(text: widget.student.phone.toString());

  late String pickedImage = widget.student.image;

  bool photoRequiredError = false;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomePageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: greyColor,
        centerTitle: true,
        title: const Text(
          'Update Student',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: InkWell(
                      onTap: () async {
                        final pickedFile = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          setState(() {
                            pickedImage = pickedFile.path;
                          });
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: greyColor,
                        radius: 70,
                        backgroundImage: pickedImage.isEmpty
                            ? NetworkImage(
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShyZWYPEncWdEfHARCCc_DcvFFf1f1qcAgxQ&s')
                            : FileImage(File(pickedImage)) as ImageProvider,
                      ),
                    ),
                  ),
                  if (photoRequiredError)
                    Text(
                      'Photo is required',
                      style: TextStyle(color: redColor),
                    ),
                  kheight20,
                  CustomTextformField(
                    controller: nameController,
                    labelText: 'Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      }
                      if (RegExp(r'\d').hasMatch(value)) {
                        return 'Numbers are not allowed';
                      }
                      if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                        return 'Special characters are not allowed';
                      }
                      return null;
                    },
                  ),
                  kheight10,
                  CustomTextformField(
                    controller: ageController,
                    labelText: 'Age',
                    keyBoardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Age required';
                      }
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Only numbers are allowed';
                      }
                      if (value.length >= 3 || value.length <= 1) {
                        return 'Enter valid age';
                      }
                      return null;
                    },
                  ),
                  kheight10,
                  CustomTextformField(
                    controller: placeController,
                    labelText: 'Place',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Place is required';
                      }
                      if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                        return 'Special characters are not allowed';
                      }
                      return null;
                    },
                  ),
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
                      if (value.length != 10) {
                        return 'Enter valid phone number';
                      }
                      return null;
                    },
                  ),
                  kheight10,
                  CustomTextformField(
                    controller: courseController,
                    labelText: 'Course',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Course required';
                      }
                      if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                        return 'Special characters are not allowed';
                      }
                      return null;
                    },
                  ),
                  kheight10,
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (pickedImage.isEmpty) {
                          setState(() {
                            photoRequiredError = true;
                          });
                        } else {
                          StudentModel updatedStudent =
                              widget.student.copyStudentModel(
                            name: nameController.text,
                            age: int.parse(ageController.text),
                            place: placeController.text,
                            course: courseController.text,
                            image: pickedImage,
                            phone: phoneController.text,
                          );

                          // Update the student in the provider
                          homeProvider.updateStudent(updatedStudent);

                          // Navigate back to the home screen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ScreenHome(),
                            ),
                          );
                        }
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          greyColor), // Background color
                      foregroundColor:
                          MaterialStateProperty.all(whiteColor), // Text color
                    ),
                    child: const Text('Submit'),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
