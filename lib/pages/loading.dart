// ignore_for_file: avoid_print

import 'package:naturepix/services/api_calls.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:math';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  //vast of the variables are imported from api_calls package

  //randomly generated index
  var qIndex = Random().nextInt(qList.length - 1);

  //variables for loading page text animation
  List<Color> colorizeColors = [
    const Color.fromARGB(255, 238, 243, 240),
    const Color.fromARGB(255, 103, 126, 112),
    const Color.fromARGB(255, 21, 181, 202),
    const Color.fromARGB(255, 236, 201, 3),
  ];

  TextStyle colorizeTextStyle = TextStyle(
      fontSize: 12.0,
      fontFamily: GoogleFonts.oswald().fontFamily,
      fontWeight: FontWeight.w400,
      letterSpacing: 2.0);

  void firstApiCall() async {
    print(qList);

    Map<String, String> params = {
      'key': key,
      'q': qList[qIndex],
      'per_page': perPage,
      'orientation': orientation,
      'page': '$page',
      'pretty': pretty
    };
    MakeApiCall instance =
        MakeApiCall(domain: url, path: path, qparams: params);
    var images = await instance.getImages();
    images.shuffle();

    //delay some seconds before home page
    Future.delayed(const Duration(milliseconds: 19000), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home', arguments: {
          'imgs': images,
          'index': qIndex,
          'pageNumber': page,
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    firstApiCall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 130, 43),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LoadingAnimationWidget.bouncingBall(
                  color: Colors.white, size: 60.0),
              const SizedBox(
                height: 80.0,
              ),
              SizedBox(
                width: 400,
                child: Center(
                  child: AnimatedTextKit(animatedTexts: [
                    ColorizeAnimatedText(
                      'Amazing mother Earth',
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                    ),
                    ColorizeAnimatedText(
                      "Beautiful....",
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                    ),
                    ColorizeAnimatedText(
                      'Nature in its splendour....',
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                    ),
                    ColorizeAnimatedText(
                      'Explore....',
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                    ),
                  ]),
                ),
              ),
            ],
          ),
          // child: SpinKitWanderingCubes(
          //   color: Color(0xFF808080),
          //   size: 100.0,
          // ),
        ));
  }
}
