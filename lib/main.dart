import 'package:naturepix/pages/home.dart';
import 'package:naturepix/pages/info_page.dart';
import 'package:naturepix/pages/loading.dart';
import 'package:naturepix/pages/next_page.dart';
import 'package:naturepix/pages/previous_page.dart';
import 'package:naturepix/pages/refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  //load env variables
  await dotenv.load(fileName: ".env");

  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => const Loading(),
      '/home': (context) => const HomePage(),
      '/refresh': (context) => const Refresh(),
      '/next-page': (context) => const NextPage(),
      '/previous-page': (context) => const PreviousPage(),
      '/about-app': (context) => const AboutApp(),
    },
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.green,
      primaryColor: const Color.fromARGB(255, 0, 130, 43),
      secondaryHeaderColor: Colors.white,
      useMaterial3: true,
      iconTheme: const IconThemeData(
        color: Color.fromARGB(255, 0, 130, 43),
      ),
    ),
  ));
}
