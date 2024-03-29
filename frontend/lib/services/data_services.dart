import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/quizzes/question_paper_model.dart';

class DataServices {
  // String _baseUsl = 'http://145.2.226.196:3000';
  final String _baseUrl = 'http://172.22.240.1:3000';

  Future<void> addUserResultsPerTest(userId, testId, numberOfHpPoints) async {
    final body = jsonEncode({
      'test_id': testId,
      'user_id': userId,
      'number_of_hp_points': numberOfHpPoints
    });

    var apiUrl = '/users/testResults';

    http.Response response = await http.post(Uri.parse(_baseUrl + apiUrl),
        body: body, headers: {"Content-Type": "application/json"});
  }

  Future<QuestionPaperModel> getTestBasedOnSectionId(sectionId) async {
    var apiUrl = '/sections/$sectionId/test';

    http.Response response = await http.get(Uri.parse(_baseUrl + apiUrl),
        headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*"
        });

    try {
      if (response.statusCode == 200) {
        dynamic decoded = await json.decode(response.body);
        List<dynamic> list = [decoded];
        // return list.map((e) => new QuestionPaperModel.fromJson(e)).toList();
        return QuestionPaperModel.fromJson(decoded);
      } else {
        print("Something went wrong");
        throw Error();
      }
    } catch (e) {
      print(e);
      throw Error();
    }
  }
}
