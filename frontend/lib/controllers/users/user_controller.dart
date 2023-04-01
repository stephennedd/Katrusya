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

class UsersController extends GetxController {
  List<CategoryModel> categories = <CategoryModel>[];

  RxList<FavoriteCourseModel> userFavoriteCourses =
      RxList<FavoriteCourseModel>([]);

  RxBool isUserLoggedIn = false.obs;

  final loadingStatus = LoadingStatus.loading.obs;
  final GetStorage _getStorage = GetStorage();

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

  Future<List<FavoriteCourseModel>> getUserFavoriteCourses(int userId) async {
    loadingStatus.value = LoadingStatus.loading;
    RxList<FavoriteCourseModel> favoriteCourses =
        await CallApi().getUserFavoriteCourses(userId);
    userFavoriteCourses.value = favoriteCourses;
    return userFavoriteCourses;
  }

  Future<List<FavoriteCourseModel>> addCourseToUserFavorites(
      int userId, int courseId) async {
    loadingStatus.value = LoadingStatus.loading;
    RxList<FavoriteCourseModel> updatedfavoriteCourses =
        await CallApi().addCourseToUserFavorites(userId, courseId);
    userFavoriteCourses.value = updatedfavoriteCourses;
    loadingStatus.value = LoadingStatus.completed;
    return userFavoriteCourses;
  }

  Future<List<FavoriteCourseModel>> deleteCourseFromUserFavorites(
      int userId, int courseId) async {
    loadingStatus.value = LoadingStatus.loading;
    RxList<FavoriteCourseModel> updatedfavoriteCourses =
        await CallApi().deleteCourseFromUserFavorites(userId, courseId);
    userFavoriteCourses.value = updatedfavoriteCourses;
    loadingStatus.value = LoadingStatus.completed;
    return userFavoriteCourses;
  }

  bool isCourseFavoriteForTheUser(courseId) {
    bool isCourseFavorite = false;
    for (int i = 0; i < userFavoriteCourses.value.length; i++) {
      if (userFavoriteCourses.value[i].courseId == courseId) {
        isCourseFavorite = true;
      }
    }
    return isCourseFavorite;
  }
}
