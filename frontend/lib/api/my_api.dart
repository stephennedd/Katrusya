import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:frontend/models/categories/category_model.dart';
import 'package:frontend/models/course_query_params_model.dart';
import 'package:frontend/models/courses/course_model.dart';
import 'package:frontend/models/question_paper_model.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/users/login_model.dart';
import '../models/users/user_model.dart';

class CallApi {
  // final String _baseUrl = 'http://172.22.240.1:3000';
   final String ip = "192.168.178.151";

  final String _baseUrl = 'http://192.168.178.151:3000';

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

  addUser(UserModel user) async {
    var fullUrl = _baseUrl + "/auth/register";

    var response = await http.post(Uri.parse(fullUrl),
        body: jsonEncode(user), headers: _setHeaders());

    return response;
  }

  loginUser(LoginModel loginnedUser) async {
    var fullUrl = _baseUrl + "/auth/login";

    var response = await http.post(Uri.parse(fullUrl),
        body: jsonEncode(loginnedUser), headers: _setHeaders());

    return response;

    //if (response.statusCode == 201) {
    // Login was successful, return true
    //  return true;
    // } else {
    // Login failed, return false
    //   return false;
    // }
  }

  getCourses(CourseQueryParamsModel queryParams) async {
    Uri apiUrl = Uri(
      scheme: 'http',
      host: ip,
      port: 3000,
      path: '/courses',
      queryParameters: {
        if (queryParams.category != null) 'category': queryParams.category,
        if (queryParams.isFeatured != null)
          'is_featured': queryParams.isFeatured.toString(),
        if (queryParams.isRecommended != null)
          'is_recommended': queryParams.isRecommended.toString(),
        if (queryParams.search != null && queryParams.search != "")
          'search': queryParams.search.toString(),
      },
    );

    http.Response response =
        await http.get(Uri.parse(apiUrl.toString()), headers: _setHeaders());

    try {
      if (response.statusCode == 200) {
        dynamic decoded = await json.decode(response.body);
        List<dynamic> coursesJson = decoded as List<dynamic>;
        // List<CourseModel> courses = coursesJson
        //     .map((courseJson) => CourseModel.fromJson(courseJson))
        //     .toList();
        RxList<CourseModel> courses = RxList<CourseModel>.from(
            coursesJson.map((courseJson) => CourseModel.fromJson(courseJson)));
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

  getCoursesBasedOnCategory(category) async {
    String apiUrl = "/courses?category=${category}";
    http.Response response =
        await http.get(Uri.parse(_baseUrl + apiUrl), headers: _setHeaders());

    try {
      if (response.statusCode == 200) {
        dynamic decoded = await json.decode(response.body);
        List<dynamic> coursesJson = decoded as List<dynamic>;
        RxList<CourseModel> courses = RxList<CourseModel>.from(
            coursesJson.map((courseJson) => CourseModel.fromJson(courseJson)));
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
