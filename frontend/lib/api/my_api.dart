import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:frontend/models/categories/category_model.dart';
import 'package:frontend/models/courses/course_model.dart';
import 'package:frontend/models/question_paper_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  final String _baseUrl = 'http://localhost:3000';

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return '?token=$token';
  }

  postData(data, apiUrl) async {
    var fullUrl = _baseUrl + apiUrl + await _getToken();
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiUrl) async {
    var fullUrl = _baseUrl + apiUrl + await _getToken();
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

  addUserResultsPerTest(apiUrl, data) async {
    return await http.post(Uri.parse(_baseUrl + apiUrl),
        body: jsonEncode(data), headers: _setHeaders());
  }

  getTestBasedOnSectionId(apiUrl) async {
    http.Response response =
        await http.get(Uri.parse(_baseUrl + apiUrl), headers: _setHeaders());

    try {
      if (response.statusCode == 200) {
        dynamic decoded = await json.decode(response.body);
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

  getRecommendedCourses() async {
    String apiUrl = "/courses/?is_recommended=true";
    http.Response response =
        await http.get(Uri.parse(_baseUrl + apiUrl), headers: _setHeaders());

    try {
      if (response.statusCode == 200) {
        dynamic decoded = await json.decode(response.body);
        List<dynamic> coursesJson = decoded as List<dynamic>;
        List<CourseModel> courses = coursesJson
            .map((courseJson) => CourseModel.fromJson(courseJson))
            .toList();
        return courses;
      } else {
        print("Something went wrong");
        throw Error();
      }
    } catch (e) {
      print(e);
      throw Error();
    }
  }

  getFeaturedCourses() async {
    String apiUrl = "/courses/?is_featured=true";
    http.Response response =
        await http.get(Uri.parse(_baseUrl + apiUrl), headers: _setHeaders());

    try {
      if (response.statusCode == 200) {
        dynamic decoded = await json.decode(response.body);
        List<dynamic> coursesJson = decoded as List<dynamic>;
        List<CourseModel> courses = coursesJson
            .map((courseJson) => CourseModel.fromJson(courseJson))
            .toList();
        return courses;
      } else {
        print("Something went wrong");
        throw Error();
      }
    } catch (e) {
      print(e);
      throw Error();
    }
  }

  getCourses() async {
    String apiUrl = "/courses";
    http.Response response =
        await http.get(Uri.parse(_baseUrl + apiUrl), headers: _setHeaders());

    try {
      if (response.statusCode == 200) {
        dynamic decoded = await json.decode(response.body);
        List<dynamic> coursesJson = decoded as List<dynamic>;
        List<CourseModel> courses = coursesJson
            .map((courseJson) => CourseModel.fromJson(courseJson))
            .toList();
        return courses;
      } else {
        print("Something went wrong");
        throw Error();
      }
    } catch (e) {
      print(e);
      throw Error();
    }
  }

  getCategories() async {
    String apiUrl = "/categories";
    http.Response response =
        await http.get(Uri.parse(_baseUrl + apiUrl), headers: _setHeaders());

    try {
      if (response.statusCode == 200) {
        dynamic decoded = await json.decode(response.body);
        List<dynamic> categoriesJson = decoded as List<dynamic>;
        List<CategoryModel> categories = categoriesJson
            .map((categoryJson) => CategoryModel.fromJson(categoryJson))
            .toList();
        return categories;
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
