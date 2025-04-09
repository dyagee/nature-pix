extractUrls(hr) {
  ///This function takes List<dynamic>
  ///of images from api call.
  ///Certain info is added to Map<String, dynamic>
  ///The queryResults each is added to List<Map> and returned

  //a collection to hold returned key info
  List<Map> listviewUrls = [];

  // List of tags to avoid
  final List tagsToAvoid = [
    'illustration',
    'cartoon',
    'sketch',
    'drawing',
    'painting',
    'art',
    'digital art',
    'outline',
    'vector',
    'anime',
    'ai generated',
    'watercolor',
    'funny',
    'draw',
  ];

  for (dynamic element in hr) {
    final tags = (element['tags'] ?? '').toString().toLowerCase();

    // Check if any tagToAvoid exists in the image tags
    final containsUnwantedTag = tagsToAvoid.any((tag) => tags.contains(tag));
    if (containsUnwantedTag) continue;
    // ignore: avoid_print
    // print(tags);

    Map<String, dynamic> queryResults = {
      'webformatURL': element["webformatURL"],
      'userId': element["user_id"],
      'user': element["user"],
      'previewURL': element["previewURL"],
      'largeImageURL': element["largeImageURL"],
    };

    listviewUrls.add(queryResults);
  }
  return listviewUrls;
}
