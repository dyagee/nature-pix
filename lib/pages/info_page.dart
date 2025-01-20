import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({super.key});

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Uri devUrl =
        Uri(scheme: 'https', host: 'www.twitter.com', path: '/Engr_Agee');

    final Uri flutterUrl = Uri(scheme: 'https', host: 'www.flutter.dev');
    final Uri pixabayUrl = Uri(scheme: 'https', host: 'www.pixabay.com');

    return SelectionArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF808080),
        appBar: AppBar(
          title: const Text(
            'About App',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor:
              Theme.of(context).primaryColor.withAlpha((0.8 * 255).toInt()),
          centerTitle: true,
        ),
        body: SafeArea(
            child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Icon(FontAwesomeIcons.dev),
                              const Text(
                                'NaturePix is developed and maintained by DyAgee Labs. Stay in touch with the Developer',
                                textAlign: TextAlign.center,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Center(
                                      child: ElevatedButton(
                                          onPressed: () {
                                            _launchInBrowser(devUrl);
                                          },
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Icon(FontAwesomeIcons.twitter),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              Text('Follow on Twitter'),
                                            ],
                                          ))),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  const Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(FontAwesomeIcons.envelope),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(
                                          'ageeaondo45@gmail.com',
                                          style: TextStyle(fontSize: 10.0),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const FlutterLogo(),
                              const Text(
                                'This app was built with Dart programming language using Flutter frameWork.',
                                textAlign: TextAlign.center,
                              ),
                              Center(
                                  child: ElevatedButton(
                                      onPressed: () {
                                        _launchInBrowser(flutterUrl);
                                      },
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text('Visit'),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Icon(
                                            FontAwesomeIcons
                                                .arrowUpRightFromSquare,
                                            size: 14.0,
                                          ),
                                        ],
                                      ))),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: 25.0,
                                height: 25.0,
                                child: Image.asset(
                                    'lib/assets/images/pixabay.jpg'),
                              ),
                              const Text(
                                'The amizing images used; Credit to PIXABAY and team.',
                                textAlign: TextAlign.center,
                              ),
                              Center(
                                  child: ElevatedButton(
                                      onPressed: () {
                                        _launchInBrowser(pixabayUrl);
                                      },
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text('Visit'),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Icon(
                                            FontAwesomeIcons
                                                .arrowUpRightFromSquare,
                                            size: 14.0,
                                          ),
                                        ],
                                      ))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ))),
      ),
    );
  }
}
