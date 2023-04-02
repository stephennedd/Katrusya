import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/api/my_api.dart';
import 'package:frontend/models/categories/category_model.dart';
import 'package:frontend/models/courses/course_model.dart';
import 'package:frontend/models/loading_status_model.dart';
import 'package:frontend/models/quizzes/question_paper_model.dart';
import 'package:frontend/models/users/user_model.dart';
import 'package:frontend/screens/homescreens/MyCourses.dart';
import 'package:frontend/storage/secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../models/courses/favorite_course_model.dart';
import '../../models/users/login_model.dart';
import '../marketplace/courses/course_controller.dart';

class UsersController extends GetxController {
  List<CategoryModel> categories = <CategoryModel>[];

  // RxList<FavoriteCourseModel> userFavoriteCourses =
  //   RxList<FavoriteCourseModel>([]);

  RxList<CourseModel> userFavoriteCourses = RxList<CourseModel>([]);

  RxBool isUserLoggedIn = false.obs;

  final loadingStatus = LoadingStatus.loading.obs;
  final GetStorage _getStorage = GetStorage();

  CourseController courseController = Get.put(CourseController());

  @override
  void onReady() async {
    super.onReady();
    isUserLoggedIn.value =
        await SecureStorage.getAccessToken() != null ? true : false;
    if (isUserLoggedIn.value) {
      getUserFavoriteCourses(_getStorage.read('userId'));
    }
  }

  Future<http.Response> registerUser(UserModel user) async {
    loadingStatus.value = LoadingStatus.loading;
    var response = await CallApi().addUser(user);
    loadingStatus.value = LoadingStatus.completed;
    return response;
  }

  Future<http.Response> loginUser(LoginModel loginnedUser) async {
    loadingStatus.value = LoadingStatus.loading;
    var response = await CallApi().loginUser(loginnedUser);
    loadingStatus.value = LoadingStatus.completed;
    return response;
    // var responseBody = response.body;
    // var decodedBody = json.decode(responseBody);
    // print(decodedBody);
  }

  Future<bool> hasUserPurchasedTheCourse(int userId, int courseId) async {
    loadingStatus.value = LoadingStatus.loading;
    var response = await CallApi().hasUserPurchasedTheCourse(userId, courseId);
    loadingStatus.value = LoadingStatus.completed;
    var responseBody = response.body;
    var hasCoursePurchased = json.decode(responseBody);
    return hasCoursePurchased;
  }

  Future<List<CourseModel>> getUserFavoriteCourses(int userId) async {
    loadingStatus.value = LoadingStatus.loading;

    RxList<FavoriteCourseModel> favoriteCourses =
        await CallApi().getUserFavoriteCourses(userId);

    print(favoriteCourses);

    addUserFavoriteCoursesDetails(favoriteCourses);
    print(userFavoriteCourses);
    return userFavoriteCourses;
  }

  Future<List<CourseModel>> addUserFavoriteCoursesDetails(
      List<FavoriteCourseModel> favoriteCourses) async {
    for (int i = 0; i < favoriteCourses.length; i++) {
      CourseModel course = courseController.courses
          .firstWhere((course) => course.id == favoriteCourses[i].courseId);
      userFavoriteCourses.add(course);
    }
    print("HEy");
    print(userFavoriteCourses);
    return userFavoriteCourses;
  }

  Future<RxList<CourseModel>> addUserFavoriteCourseDetails(
      FavoriteCourseModel favoriteCourse) async {
    CourseModel course = courseController.courses
        .firstWhere((course) => course.id == favoriteCourse.courseId);
    userFavoriteCourses.add(course);

    return userFavoriteCourses;
  }

  Future<RxList<CourseModel>> removeUserFavoriteCourseDetails(
      FavoriteCourseModel favoriteCourse) async {
    print("Liza");
    print(favoriteCourse);
    CourseModel course = courseController.courses
        .firstWhere((course) => course.id == favoriteCourse.courseId);
    print("Course:");
    print(course);
    userFavoriteCourses
        .removeWhere((course) => course.id == favoriteCourse.courseId);
    print("User favorite courses:");
    print(userFavoriteCourses);
    return userFavoriteCourses;
  }

  Future<List<CourseModel>> addCourseToUserFavorites(
      int userId, int courseId) async {
    loadingStatus.value = LoadingStatus.loading;
    FavoriteCourseModel addedfavoriteCourse =
        await CallApi().addCourseToUserFavorites(userId, courseId);
    addUserFavoriteCourseDetails(addedfavoriteCourse);
    loadingStatus.value = LoadingStatus.completed;
    return userFavoriteCourses;
  }

  Future<List<CourseModel>> deleteCourseFromUserFavorites(
      int userId, int courseId) async {
    loadingStatus.value = LoadingStatus.loading;
    FavoriteCourseModel deletedFavoriteCourse =
        await CallApi().deleteCourseFromUserFavorites(userId, courseId);
    removeUserFavoriteCourseDetails(deletedFavoriteCourse);
    loadingStatus.value = LoadingStatus.completed;
    return userFavoriteCourses;
  }

  bool isCourseFavoriteForTheUser(courseId) {
    bool isCourseFavorite = false;
    for (int i = 0; i < userFavoriteCourses.length; i++) {
      if (userFavoriteCourses[i].id == courseId) {
        isCourseFavorite = true;
      }
    }
    return isCourseFavorite;
  }
}
