extractUrls(hr) {
  ///This function takes List<dynamic>
  ///of images from api call.
  ///Certain info is added to Map<String, dynamic>
  ///The queryResults each is added to List<Map> and returned

  //a collection to hold returned key info
  List<Map> listviewUrls = [];

  for (dynamic element in hr) {
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
