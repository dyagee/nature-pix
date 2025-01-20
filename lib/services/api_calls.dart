import 'package:naturepix/models/images_model.dart';
import 'package:naturepix/models/query_model.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//replace this with your API KEY
//OR load from .env file
String key = dotenv.get('API_KEY');

//variables for loading page api call
String url = 'pixabay.com';
String path = '/api';
String perPage = '199';
String orientation = 'all';
int page = 1;
String pretty = 'true';

//load query list from .env file
List qList = dotenv.get('QUERY_LIST').split(',');

class MakeApiCall {
  /// This module depends solely on http package to query
  /// check dependencies file for package version.

  late QueryModel queryModel;
  late String domain;
  late String path;
  late Map<String, String> qparams;

  MakeApiCall(
      {required this.domain, required this.path, required this.qparams});

  // var url = Uri.https('pixabay.com', '/api', {
  //   'key': '43667839-34dc3617cc0531ad065f7ce0a',
  //   'q': 'anime+ai+generated+girls+sexy',
  //   'per_page': '199',
  //   'orientation': 'all',
  //   'page': '1',
  //   'pretty': 'true'
  // });

  getImages() async {
    var url = Uri.https(domain, path, qparams);

    Response response = await get(url);

    Map<String, dynamic> data = jsonDecode(response.body);

    //The section of the Response containing img URLS and
    //othe informations
    List hts = extractUrls(data['hits']);

    //instance of a queryModel
    queryModel = QueryModel(
        total: data['total'], totalHits: data['totalHits'], hits: hts);

    // ignore: avoid_print
    //print(queryModel.hits.forEach((item) => item['largeImageURL']));

    //print out for debuggging
    // for (Map item in queryModel.hits) {
    //   // ignore: avoid_print
    //   print(item['largeImageURL']);
    //   // ignore: avoid_print
    //   print(queryModel.hits.length);
    // }
    return queryModel.hits;
  }
}
