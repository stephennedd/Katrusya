import 'dart:convert';

import 'package:frontend/models/question_paper_model.dart';
import 'package:http/http.dart' as http;

class DataServices {
  String _baseUsl = 'http://145.2.226.196:3000';
  Future<List<QuestionPaperModel>> getTestsBasedOnSectionId(sectionId) async {
    var apiUrl = '/sections/${sectionId}/test';

    http.Response response = await http.get(Uri.parse(_baseUsl + apiUrl),
        headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*"
        });

    try {
      if (response.statusCode == 200) {
        dynamic decoded = await json.decode(response.body);
        List<dynamic> list = [decoded];
        return list.map((e) => new QuestionPaperModel.fromJson(e)).toList();
      } else {
        print("Something went wrong");
        return <QuestionPaperModel>[];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
