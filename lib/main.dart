import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_provider_try1/Presentation/Home/home.dart';
import 'package:student_provider_try1/Provider/addscreenprovider.dart';
import 'package:student_provider_try1/Provider/details_provider.dart';
import 'package:student_provider_try1/Provider/home_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AddPageProvider()),
        ChangeNotifierProvider(create: (_) => HomePageProvider()),
        ChangeNotifierProvider(create: (_) => StudentDetailProvider())
      ],
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor:
              Colors.white, // Set default scaffold background
        ),
        debugShowCheckedModeBanner: false,
        home: ScreenHome(),
      ),
    );
  }
}
