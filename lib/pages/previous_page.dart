import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:naturepix/services/api_calls.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:naturepix/services/connectivity_wrapper.dart';

class PreviousPage extends StatefulWidget {
  const PreviousPage({super.key});

  @override
  State<PreviousPage> createState() => _PreviousPageState();
}

class _PreviousPageState extends State<PreviousPage> {
  // List prevImages = [];
  // late int prevIndex;
  // late int prevPage;

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

  void previousPage(
      {required int index,
      required int pageNumber,
      required List imageList}) async {
    if (pageNumber > 1) {
      Map<String, String> pparams = {
        'key': key,
        'q': qList[index],
        'per_page': perPage,
        'orientation': orientation,
        'page': '${pageNumber - 1}',
        'pretty': pretty
      };
      MakeApiCall instance =
          MakeApiCall(domain: url, path: path, qparams: pparams);
      var newImages = await instance.getImages();
      // ignore: avoid_print
      //print("imgsL: $newImages");

      //delay some seconds before home page
      Future.delayed(const Duration(milliseconds: 10000), () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home', arguments: {
            'imgs': newImages,
            'index': index,
            'pageNumber': pageNumber - 1,
          });
        }
      });
    } else {
      //delay some seconds before home page
      Future.delayed(const Duration(milliseconds: 4000), () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home', arguments: {
            'imgs': imageList,
            'index': index,
            'pageNumber': pageNumber,
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>?;

    // previousPage(
    //     index: data?['index'],
    //     pageNumber: data?['pageNumber'],
    //     imageList: data?['imgs']);

    return ConnectivityWrapper(
      onConnectionRestored: [
        () {
          previousPage(
              index: data?['index'],
              pageNumber: data?['pageNumber'],
              imageList: data?['imgs']);
        }
      ],
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
                        'Reloading....',
                        textStyle: colorizeTextStyle,
                        colors: colorizeColors,
                      ),
                      ColorizeAnimatedText(
                        "This may take some seconds....",
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
