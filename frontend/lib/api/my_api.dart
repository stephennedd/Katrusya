import 'dart:convert';

import 'package:frontend/models/categories/category_model.dart';
import 'package:frontend/models/course_query_params_model.dart';
import 'package:frontend/models/courses/completed_lesson_model.dart';
import 'package:frontend/models/courses/completed_section_model.dart';
import 'package:frontend/models/courses/course_details_model.dart';
import 'package:frontend/models/courses/course_model.dart';
import 'package:frontend/models/courses/favorite_course_model.dart';
import 'package:frontend/models/courses/my_course_model.dart';
import 'package:frontend/models/quizzes/question_paper_model.dart';
import 'package:frontend/models/quizzes/quiz_model.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/courses/purchase_model.dart';
import '../models/users/login_model.dart';
import '../models/users/user_model.dart';

class CallApi {
  // final String _baseUrl = 'http://172.22.240.1:3000';

<<<<<<< HEAD
  final String _baseUrl = 'http://localhost:3000';
  //final String _baseUrl = 'http://192.168.178.151:3000';
=======
  //final String _baseUrl = 'http://localhost:3000';
  final String _baseUrl = 'http://192.168.178.151:3000';
>>>>>>> 84a2dbe3441a0266cf0901df8cdad74a6b6c1123

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

  getTestBasedOnSectionId(int sectionId) async {
    http.Response response = await http.get(
        Uri.parse(_baseUrl + "/sections/${sectionId}/test"),
        headers: _setHeaders());

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
  }

  addPurchasedCourse(PurchaseModel purchase) async {
    var fullUrl = _baseUrl + "/courses/purchasedCourses";

    var response = await http.post(Uri.parse(fullUrl),
        body: jsonEncode(purchase), headers: _setHeaders());

    return response;
  }

  //final String ip = "192.168.178.151";
  getCourses(CourseQueryParamsModel queryParams) async {
    Uri apiUrl = Uri(
      scheme: 'http',
      host: 'localhost',
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

  getCourseDetails(int courseId) async {
    String apiUrl = "/courses/${courseId}/details";

    http.Response response =
        await http.get(Uri.parse(_baseUrl + apiUrl), headers: _setHeaders());

    try {
      if (response.statusCode == 200) {
        dynamic decoded = await json.decode(response.body);
        return CourseDetailsModel.fromJson(decoded);
      } else {
        print("Something went wrong");
        throw Error();
      }
    } catch (e) {
      print(e);
      throw Error();
    }
  }

  getCourseQuizzes(int courseId) async {
    String apiUrl = "/courses/${courseId}/quizzes";

    http.Response response =
        await http.get(Uri.parse(_baseUrl + apiUrl), headers: _setHeaders());

    try {
      if (response.statusCode == 200) {
        dynamic decoded = await json.decode(response.body);
        List<dynamic> quizzesJson = decoded as List<dynamic>;
        RxList<QuizModel> quizzes = RxList<QuizModel>.from(
            quizzesJson.map((quizJson) => QuizModel.fromJson(quizJson)));
        return quizzes;
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

  getUserFavoriteCourses(int userId) async {
    String apiUrl = "/users/${userId}/favoriteCourses";
    http.Response response =
        await http.get(Uri.parse(_baseUrl + apiUrl), headers: _setHeaders());

    if (response.statusCode == 200) {
      dynamic decoded = await json.decode(response.body);
      List<dynamic> favoriteCoursesJson = decoded as List<dynamic>;
      RxList<FavoriteCourseModel> favoriteCourses =
          RxList<FavoriteCourseModel>.from(favoriteCoursesJson.map(
              (favoriteCourseJson) =>
                  FavoriteCourseModel.fromJson(favoriteCourseJson)));
      return favoriteCourses;
    } else {
      print("Something went wrong");
      throw Error();
    }
  }

  getUserCourses(int userId) async {
    String apiUrl = "/users/${userId}/courses";
    http.Response response =
        await http.get(Uri.parse(_baseUrl + apiUrl), headers: _setHeaders());

    if (response.statusCode == 200) {
      dynamic decoded = await json.decode(response.body);
      List<dynamic> userCoursesJson = decoded as List<dynamic>;
      RxList<MyCourseModel> userCourses = RxList<MyCourseModel>.from(
          userCoursesJson
              .map((userCourseJson) => MyCourseModel.fromJson(userCourseJson)));
      return userCourses;
    } else {
      print("Something went wrong");
      // final GetStorage _getStorage = GetStorage();
      // await SecureStorage.deleteAccessToken();
      // _getStorage.erase();
      throw Error();
    }
  }

  getCompletedByUserLessonsForCertainCourse(int userId, int courseId) async {
    String apiUrl = "/users/${userId}/courses/${courseId}/completedLessons";
    http.Response response =
        await http.get(Uri.parse(_baseUrl + apiUrl), headers: _setHeaders());

    if (response.statusCode == 200) {
      dynamic decoded = await json.decode(response.body);
      List<dynamic> completedLessonsJson = decoded as List<dynamic>;
      RxList<CompletedLessonModel> completedLessonsForCertainCourse =
          RxList<CompletedLessonModel>.from(completedLessonsJson.map(
              (completedLessonJson) =>
                  CompletedLessonModel.fromJson(completedLessonJson)));
      return completedLessonsForCertainCourse;
    } else {
      print("Something went wrong");
      // final GetStorage _getStorage = GetStorage();
      // await SecureStorage.deleteAccessToken();
      // _getStorage.erase();
      throw Error();
    }
  }

  getCompletedByUserSections(int userId) async {
    String apiUrl = "/users/${userId}/completedSections";
    http.Response response =
        await http.get(Uri.parse(_baseUrl + apiUrl), headers: _setHeaders());

    if (response.statusCode == 200) {
      dynamic decoded = await json.decode(response.body);
      List<dynamic> completedSectionsJson = decoded as List<dynamic>;
      RxList<CompletedSectionModel> completedSectionsForCertainCourse =
          RxList<CompletedSectionModel>.from(completedSectionsJson.map(
              (completedSectionJson) =>
                  CompletedSectionModel.fromJson(completedSectionJson)));
      return completedSectionsForCertainCourse;
    } else {
      print("Something went wrong");
      throw Error();
    }
  }

  addCourseToUserFavorites(int userId, int courseId) async {
    //CHANGE
    final favoriteCourse = {'course_id': courseId};
    String apiUrl = "/users/${userId}/favoriteCourses";
    http.Response response = await http.post(Uri.parse(_baseUrl + apiUrl),
        body: jsonEncode(favoriteCourse), headers: _setHeaders());
    if (response.statusCode == 201) {
      dynamic decoded = await json.decode(response.body);
      FavoriteCourseModel addedFavoriteCourse =
          FavoriteCourseModel.fromJson(decoded);
      return addedFavoriteCourse;
    } else {
      print("Something went wrong");
      throw Error();
    }
  }

  deleteCourseFromUserFavorites(int userId, int courseId) async {
    String apiUrl = "/users/${userId}/favoriteCourses/${courseId}";
    http.Response response =
        await http.delete(Uri.parse(_baseUrl + apiUrl), headers: _setHeaders());
    if (response.statusCode == 200) {
      dynamic decoded = await json.decode(response.body);
      FavoriteCourseModel deletedFavoriteCourse =
          FavoriteCourseModel.fromJson(decoded);
      return deletedFavoriteCourse;
    } else {
      print("Something went wrong");
      throw Error();
    }
  }

  addCompletedByUserLesson(
      int userId, int courseId, int sectionId, int lessonId) async {
    //CHANGE
    final completedByUserLesson = {
      'course_id': courseId,
      'section_id': sectionId,
      'lesson_id': lessonId
    };
    String apiUrl = "/users/${userId}/completedLessons";
    http.Response response = await http.post(Uri.parse(_baseUrl + apiUrl),
        body: jsonEncode(completedByUserLesson), headers: _setHeaders());
    if (response.statusCode == 201) {
      dynamic decoded = await json.decode(response.body);
      CompletedLessonModel addedCompletedLessson =
          CompletedLessonModel.fromJson(decoded);
      return addedCompletedLessson;
    } else {
      print("Something went wrong");
      throw Error();
    }
  }

  deleteCompletedByUserLesson(
      int userId, int courseId, int sectionId, int lessonId) async {
    //CHANGE
    final completedByUserLesson = {
      'course_id': courseId,
      'section_id': sectionId,
      'lesson_id': lessonId
    };
    String apiUrl = "/users/${userId}/completedLessons";
    http.Response response = await http.delete(Uri.parse(_baseUrl + apiUrl),
        body: jsonEncode(completedByUserLesson), headers: _setHeaders());
    if (response.statusCode == 200) {
      dynamic decoded = await json.decode(response.body);
      CompletedLessonModel deletedCompletedLessson =
          CompletedLessonModel.fromJson(decoded);
      return deletedCompletedLessson;
    } else {
      print("Something went wrong");
      throw Error();
    }
  }

  hasUserPurchasedTheCourse(int userId, int courseId) async {
    String apiUrl = "/users/$userId/isCoursePurchased?course_id=$courseId";
    http.Response response =
        await http.get(Uri.parse(_baseUrl + apiUrl), headers: _setHeaders());
    return response;
  }

  flipTeacherMode(int userId) async {
    String apiUrl = "/users/$userId/roles";
    http.Response response =
        await http.put(Uri.parse(_baseUrl + apiUrl), headers: _setHeaders());
    if (response.statusCode == 200) {
      dynamic decoded = await json.decode(response.body);
      List<dynamic> updatedRoles = decoded as List<dynamic>;
      return updatedRoles;
    } else {
      print("Something went wrong");
      throw Error();
    }
  }
}
