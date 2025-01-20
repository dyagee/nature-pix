import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:naturepix/services/api_calls.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Refresh extends StatefulWidget {
  const Refresh({super.key});

  @override
  State<Refresh> createState() => _RefreshState();
}

class _RefreshState extends State<Refresh> {
  //variables for loading page text animation
  List<Color> colorizeColors = [
    const Color(0xFFFF00FF),
    const Color(0xFF00AEEF),
    const Color(0xFFFF0000),
    const Color(0xFF4B0082),
  ];

  TextStyle colorizeTextStyle = TextStyle(
    fontSize: 10.0,
    fontFamily: GoogleFonts.oswald().fontFamily,
    fontWeight: FontWeight.w600,
  );

  void refresh() async {
    //randomly generated index
    var rIndex = Random().nextInt(qList.length - 1);

    Map<String, String> rparams = {
      'key': key,
      'q': qList[rIndex],
      'per_page': perPage,
      'orientation': orientation,
      'page': '$page',
      'pretty': pretty
    };
    MakeApiCall instance =
        MakeApiCall(domain: url, path: path, qparams: rparams);
    var newImages = await instance.getImages();

    //delay some seconds before home page
    Future.delayed(const Duration(milliseconds: 10000), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home', arguments: {
          'imgs': newImages,
          'index': rIndex,
          'pageNumber': page,
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(117, 76, 0, 130),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LoadingAnimationWidget.flickr(
                leftDotColor: const Color(0xFFFF00FF),
                rightDotColor: const Color(0xFF00AEEF),
                size: 58,
              ),
              const SizedBox(
                height: 80.0,
              ),
              SizedBox(
                width: 400,
                child: Center(
                  child: AnimatedTextKit(animatedTexts: [
                    ColorizeAnimatedText(
                      'Loading....',
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                    ),
                    ColorizeAnimatedText(
                      "Images can be refreshed after 30mins....",
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                    ),
                    ColorizeAnimatedText(
                      'Waiting....',
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                    ),
                    ColorizeAnimatedText(
                      'Stay Jiggy....',
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ));
  }
}
