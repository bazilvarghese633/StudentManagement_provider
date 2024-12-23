import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_provider_try1/Model/model.dart';
import 'package:student_provider_try1/Provider/home_provider.dart';
import 'package:student_provider_try1/core/colors.dart';
import 'package:student_provider_try1/core/constants.dart';
import 'package:student_provider_try1/widgets/dialoge.dart';

class ScreenSearch extends StatelessWidget {
  const ScreenSearch({super.key});

  get whitecolor => null;

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomePageProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: greyColor,
        centerTitle: true,
        title: const Text(
          'Search Students',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: CupertinoSearchTextField(
              onChanged: (value) {
                homeProvider.filterStudents(value);
              },
            ),
          ),
          Expanded(
              child: Selector<HomePageProvider, bool>(
                  selector: (context, provider) => provider.noResult,
                  builder: (context, noResult, child) {
                    if (noResult) {
                      return const Center(
                        child: Text(
                          'No items found',
                          style: TextStyle(fontSize: 18, color: greyColor),
                        ),
                      );
                    }
                    return Selector<HomePageProvider, List<StudentModel>>(
                        selector: (context, provider) =>
                            provider.filteredStudents,
                        builder: (context, filteredStudents, child) {
                          return ListView.separated(
                              separatorBuilder: (context, index) => kheight10,
                              itemCount: filteredStudents.length,
                              itemBuilder: (context, index) {
                                var student = filteredStudents[index];
                                return GestureDetector(
                                  onTap: () {
                                    StudentDialog.showStudentDialog(
                                        context, student);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8.0),
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                        color: greyColor,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: greyColor,
                                              spreadRadius: 2,
                                              blurRadius: 10)
                                        ]),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Container(
                                                width: 120,
                                                height: 120,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: FileImage(File(
                                                            student.image)),
                                                        fit: BoxFit.cover)),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 36,
                                            ),
                                            Expanded(
                                                child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  student.name,
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                    color: whiteColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'Course:${student.course}',
                                                  style: const TextStyle(
                                                      color: whiteColor,
                                                      fontSize: 19),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'Age:${student.age}',
                                                  style: const TextStyle(
                                                      color: whiteColor,
                                                      fontSize: 19),
                                                )
                                              ],
                                            ))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        });
                  }))
        ],
      ),
    );
  }
}
