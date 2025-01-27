// ignore_for_file: avoid_print

import 'dart:async';

import 'package:naturepix/services/api_calls.dart';
import 'package:naturepix/utils/json_util.dart';
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
  // variables for facts
  List<Fact> shuffledFacts = [];
  int currentFactIndex = 0;
  Timer? timer;
  //vast of the variables are imported from api_calls package

  //randomly generated index
  var qIndex = Random().nextInt(qList.length - 1);

  //variables for loading page text animation
  List<Color> colorizeColors = [
    const Color.fromARGB(255, 238, 243, 240),
    const Color.fromARGB(255, 103, 126, 112),
    const Color.fromARGB(255, 21, 181, 202),
    const Color.fromARGB(255, 177, 124, 10),
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
    Future.delayed(const Duration(milliseconds: 10000), () {
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
    loadFacts().then(
      (factList) {
        // shuffle list and limit to 3 elements
        shuffledFacts = factList.facts..shuffle(Random());
        shuffledFacts = shuffledFacts.take(2).toList();
        setState(() {});
      },
    );

    // Start timer to rotate facts
    // timer = Timer.periodic(const Duration(seconds: 7), (timer) {
    //   setState(() {
    //     currentFactIndex = (currentFactIndex + 1) % shuffledFacts.length;
    //   });
    // });
    firstApiCall();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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
                  color: Colors.white, size: 100.0),
              const SizedBox(
                height: 2.0,
              ),
              SizedBox(
                width: 400,
                child: Center(
                  child: AnimatedTextKit(animatedTexts: [
                    ColorizeAnimatedText(
                      'amazing mother Earth',
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                    ),
                    ColorizeAnimatedText(
                      "beautiful....",
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                    ),
                    ColorizeAnimatedText(
                      'nature in its splendour....',
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                    ),
                    ColorizeAnimatedText(
                      'explore....',
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                    ),
                  ]),
                ),
              ),
              const SizedBox(
                height: 150,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: shuffledFacts.isEmpty
                    ? Text(
                        "Loading facts...",
                        style: colorizeTextStyle.copyWith(
                            fontStyle: FontStyle.italic, color: Colors.white),
                        textAlign: TextAlign.center,
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            shuffledFacts[currentFactIndex].fact,
                            style: colorizeTextStyle.copyWith(
                                fontSize: 13, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "[${shuffledFacts[currentFactIndex].source}]",
                            style: colorizeTextStyle.copyWith(
                                fontStyle: FontStyle.italic,
                                fontSize: 10,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
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
