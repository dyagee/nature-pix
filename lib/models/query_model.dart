// ignore_for_file: unused_local_variable

class QueryModel {
  int? total;
  int? totalHits;
  dynamic hits;

  QueryModel({this.total, this.totalHits, this.hits});

  factory QueryModel.fromMap(Map<String, dynamic> jsonData) {
    return QueryModel(
      total: jsonData["total"],
      totalHits: jsonData["totalHits"],
      hits: jsonData["hits"],
    );
  }
}

