import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:naturepix/services/api_calls.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:naturepix/services/connectivity_wrapper.dart';

class Refresh extends StatefulWidget {
  const Refresh({super.key});

  @override
  State<Refresh> createState() => _RefreshState();
}

class _RefreshState extends State<Refresh> {
  //variables for loading page text animation
  List<Color> colorizeColors = [
    const Color.fromARGB(255, 4, 125, 83),
    const Color(0xFF00AEEF),
    const Color.fromARGB(255, 78, 21, 200),
    const Color.fromARGB(255, 50, 152, 120),
  ];

  TextStyle colorizeTextStyle = TextStyle(
    fontSize: 12.0,
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
    Future.delayed(const Duration(milliseconds: 4000), () {
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
    // refresh();
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityWrapper(
      onConnectionRestored: [refresh],
      child: Scaffold(
          backgroundColor: const Color.fromARGB(117, 26, 55, 65),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LoadingAnimationWidget.flickr(
                  leftDotColor: const Color.fromARGB(255, 6, 99, 33),
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
                        'Fetching....',
                        textStyle: colorizeTextStyle,
                        colors: colorizeColors,
                      ),
                      ColorizeAnimatedText(
                        "This may take few seconds....",
                        textStyle: colorizeTextStyle,
                        colors: colorizeColors,
                      ),
                      ColorizeAnimatedText(
                        'Waiting....',
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
          )),
    );
  }
}
