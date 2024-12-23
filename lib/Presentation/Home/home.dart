import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_provider_try1/Presentation/AddStudent/add_student.dart';
import 'package:student_provider_try1/Presentation/search/search.dart';
import 'package:student_provider_try1/Provider/home_provider.dart';
import 'package:student_provider_try1/core/colors.dart';
import 'package:student_provider_try1/core/constants.dart';
import 'package:student_provider_try1/widgets/dialoge.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  Future<bool> _onwillpop(BuildContext context) async {
    return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Confirm Exit'),
                  content: const Text('Do you want to exit the app?'),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('No')),
                    TextButton(
                        onPressed: () => exit(0), child: const Text('Yes')),
                  ],
                ))) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomePageProvider>(context, listen: false);
    homeProvider.refreshStudentList();

    return WillPopScope(
      onWillPop: () => _onwillpop(context),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'Student List',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          backgroundColor: greyColor,
          actions: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScreenSearch(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.search,
                  size: 28,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        body: Consumer<HomePageProvider>(
          builder: (context, homeProvider, _) {
            return ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: homeProvider.students.length,
              itemBuilder: (context, index) {
                var student = homeProvider.students[index];

                return InkWell(
                  onTap: () {
                    StudentDialog.showStudentDialog(context, student);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: greyColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 4,
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(File(student.image)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        kwidth20,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                student.name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: whiteColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Course: ${student.course}',
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Age: ${student.age}',
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: greyColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddStudent(),
              ),
            ).then((value) => homeProvider.refreshStudentList());
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
