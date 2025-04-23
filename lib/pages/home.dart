// ignore_for_file: avoid_print, unused_import

import 'package:flutter_media_downloader/flutter_media_downloader.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:image_downloader/image_downloader.dart';
import 'package:naturepix/services/appname.dart';
import 'package:flutter/material.dart';
import 'package:drop_shadow_image/drop_shadow_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ///api-call variables are imported from
  ///api_calls package

  //Map  to hold imgUrls list & other info
  //from api call after loading
  List imgUrls = [];
  final _flutterMediaDownloaderPlugin = MediaDownload();

  //randomly generated index
  late int qIndex;
  late int pageNumber;

  bool _isVisible = false;
  bool _isDownload = false;
  String _message = "";

  // svg widget for error
  static String assetName = 'lib/assets/images/not_found.svg';
  final Widget errorSvg = SvgPicture.asset(
    assetName,
    semanticsLabel: 'Error SVG',
  );

  void _enableDownload() {
    if (!_isDownload) {
      if (mounted) {
        setState(() => _isDownload = true);
      }
    }
  }

  Future<void> _downloadImage(String url) async {
    //using flutter_media_downloader
    try {
      _message = "Downloading photo.... in /downloads folder";
      _flutterMediaDownloaderPlugin.downloadMedia(context, url);
      _message = "Downloaded successfully";
    } catch (e) {
      _message = e.toString();
    }

    // using image_dowloader package
    // _message = "Downloading photo.... in /downloads folder";
    // try {
    //   // Saved with this method.
    //   var imageId = await ImageDownloader.downloadImage(url);
    //   if (imageId == null) {
    //     _message = "App Denied Download access; Allow Acess PERMISSIONS";
    //     return;
    //   }
    //   _message = "Downloaded successfully";
    // } on PlatformException catch (error) {
    //   print(error);
    //   _message = "ERROR: ${error.toString()}";
    // }
  }

  void _disableDownload() {
    if (_isDownload) {
      if (mounted) {
        setState(() => _isDownload = false);
      }
    }
  }

  void _show() {
    if (!_isVisible) {
      if (mounted) {
        setState(() => _isVisible = true);
      }
    }
  }

  void _hide() {
    if (_isVisible) {
      if (mounted) {
        setState(() => _isVisible = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>?;

    setState(() {
      imgUrls = data?['imgs'];
      qIndex = data?['index'];
      pageNumber = data?['pageNumber'];
    });

    // show navigation
    if (imgUrls.isEmpty) {
      setState(() {
        _isVisible = true;
      });
    }

    //print(imgUrls);

    return Scaffold(
      backgroundColor: const Color(0xFF808080),
      appBar: AppBar(
        title: appName(),
        //backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
        backgroundColor: const Color(0xFF37474F),
        centerTitle: true,
      ),
      body: SafeArea(
        child: imgUrls.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: errorSvg),
                    Expanded(
                      child: Text(
                        'Something went; \ntry again.... ',
                        style: TextStyle(
                          letterSpacing: 1.5,
                          color: Colors.red,
                          fontSize: 18.0,
                          fontFamily: GoogleFonts.allertaStencil().fontFamily,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              )
            : PageView.builder(
                itemCount: imgUrls.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 2.0),
                    child: Center(
                      child: Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children: <Widget>[
                            DropShadowImage(
                              offset: const Offset(8.0, 8.0),
                              scale: 3.0,
                              blurRadius: 16.0,
                              borderRadius: 8.0,
                              image: Image.network(
                                imgUrls[index]['largeImageURL'],
                                fit: BoxFit.cover,
                              ),
                            ),
                            //overlay interactive image
                            Positioned.fill(
                              child: InteractiveViewer(
                                panEnabled: true,
                                minScale: 1.0,
                                maxScale: 5.0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    imgUrls[index]['largeImageURL'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              //left: (MediaQuery.of(context).size.width / 2),
                              left: 10.0,
                              bottom: 1.0,
                              child: _isDownload
                                  ? FloatingActionButton(
                                      mini: true,
                                      tooltip: 'Download',
                                      backgroundColor:
                                          const Color.fromARGB(192, 30, 44, 37),
                                      splashColor: Colors.cyan[50],
                                      onPressed: () async {
                                        _downloadImage(
                                            imgUrls[index]['largeImageURL']);

                                        showToast(
                                          _message,
                                          context: context,
                                          animation: StyledToastAnimation
                                              .slideFromBottom,
                                          duration: const Duration(seconds: 2),
                                        );
                                      },
                                      child: const Icon(
                                        FontAwesomeIcons.download,
                                        size: 24.0,
                                        color: Color(0xFFBCC6CC),
                                      ),
                                    )
                                  : Container(),
                            ),
                          ]),
                    ),
                  );
                }),
      ),

      //show caretup if no bottomBar
      //show caretdown if bottomBar displayed
      floatingActionButton: _isVisible
          ? SizedBox(
              width: 24.0,
              height: 24.0,
              child: RawMaterialButton(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
                fillColor: Colors.transparent,
                elevation: 2.5,
                onPressed: () {
                  _hide();
                },
                child: const Icon(
                  FontAwesomeIcons.caretDown,
                  size: 22.0,
                  color: Color(0xFFBCC6CC),
                ),
              ),
            )
          : SizedBox(
              width: 28.0,
              height: 28.0,
              child: RawMaterialButton(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
                fillColor: Colors.transparent,
                elevation: 2.5,
                onPressed: () {
                  _show();
                },
                child: const Icon(
                  FontAwesomeIcons.bars,
                  size: 16.0,
                  color: Color(0xFFBCC6CC),
                ),
              ),
            ),

      //dock the floatingButton to not cover app content
      floatingActionButtonLocation: _isVisible
          ? FloatingActionButtonLocation.endDocked
          : FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: _isVisible ? 60.0 : 0.0,
        child: BottomAppBar(
          // color: Theme.of(context).primaryColor.withAlpha((0.8 * 255).toInt()),
          color: const Color(0xFF37474F),
          elevation: 2.5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                tooltip: 'Enable Download',
                color: const Color(0xFFBCC6CC),
                splashColor: const Color(0xFF00AEEF),
                onPressed: () => showDialog<String>(
                  context: context,
                  barrierColor: const Color.fromARGB(162, 57, 105, 103),
                  builder: (BuildContext context) => AlertDialog(
                    //title: const Text('AlertDialog Title'),
                    icon: const Icon(
                      FontAwesomeIcons.gears,
                      size: 30.0,
                    ),
                    actionsAlignment: MainAxisAlignment.spaceEvenly,
                    content: const Text(
                      'Enable Images Download?',
                      textAlign: TextAlign.center,
                    ),
                    actions: <Widget>[
                      _isDownload
                          ? TextButton(
                              onPressed: () {
                                _disableDownload();
                                Navigator.of(context).pop();
                              },
                              child: const Text('Disable'),
                            )
                          : TextButton(
                              onPressed: () {
                                _enableDownload();
                                Navigator.of(context).pop();
                              },
                              child: const Text('Enable'),
                            ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ),
                icon: const Icon(
                    // FontAwesomeIcons.gear,
                    Icons.settings_rounded),
                iconSize: 30.0,
              ),
              IconButton(
                tooltip: 'Previous Page',
                color: const Color(0xFFBCC6CC),
                splashColor: const Color(0xFF00AEEF),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/previous-page',
                      arguments: {
                        'imgs': imgUrls,
                        'index': qIndex,
                        'pageNumber': pageNumber,
                      });
                },
                icon: const Icon(Icons.rotate_left_rounded),
                iconSize: 30.0,
              ),
              IconButton(
                tooltip: 'Refresh',
                color: const Color(0xFFBCC6CC),
                splashColor: const Color(0xFF00AEEF),
                onPressed: () {
                  setState(() {
                    imgUrls = [];
                  });
                  Navigator.pushReplacementNamed(
                    context,
                    '/refresh',
                  );
                },
                icon: const Icon(Icons.autorenew_outlined),
                iconSize: 30.0,
              ),
              IconButton(
                tooltip: 'Next Page',
                color: const Color(0xFFBCC6CC),
                splashColor: const Color(0xFF00AEEF),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/next-page',
                      arguments: {
                        'imgs': imgUrls,
                        'index': qIndex,
                        'pageNumber': pageNumber,
                      });
                },
                icon: const Icon(Icons.rotate_right_rounded),
                iconSize: 30.0,
              ),
              IconButton(
                tooltip: 'About App',
                color: const Color(0xFFBCC6CC),
                splashColor: const Color(0xFF00AEEF),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/about-app',
                  );
                },
                icon: const Icon(Icons.more_vert_outlined),
                iconSize: 30.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//class handle bottomBar display
// class _BottomBarClass extends StatelessWidget {
//   const _BottomBarClass({required this.isVisible});

//   final bool isVisible;

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 250),
//       height: isVisible ? 60.0 : 0.0,
//       child: BottomAppBar(
//         color: const Color.fromARGB(255, 34, 1, 58),
//         elevation: 2.5,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: <Widget>[
//             IconButton(
//               tooltip: 'Previous Page',
//               color: const Color(0xFFFF00FF),
//               splashColor: const Color(0xFF00AEEF),
//               onPressed: () {},
//               icon: const Icon(FontAwesomeIcons.rotateLeft),
//               iconSize: 18.0,
//             ),
//             IconButton(
//               tooltip: 'Refresh',
//               color: const Color(0xFFFF00FF),
//               splashColor: const Color(0xFF00AEEF),
//               onPressed: () {},
//               icon: const Icon(FontAwesomeIcons.rotate),
//               iconSize: 18.0,
//             ),
//             IconButton(
//               tooltip: 'Next Page',
//               color: const Color(0xFFFF00FF),
//               splashColor: const Color(0xFF00AEEF),
//               onPressed: () {},
//               icon: const Icon(FontAwesomeIcons.rotateRight),
//               iconSize: 18.0,
//             ),
//             IconButton(
//               tooltip: 'About',
//               color: const Color(0xFFFF00FF),
//               splashColor: const Color(0xFF00AEEF),
//               onPressed: () {},
//               icon: const Icon(FontAwesomeIcons.ellipsisVertical),
//               iconSize: 18.0,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
