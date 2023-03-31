import 'dart:convert';
import 'dart:ffi';

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
import 'package:http/http.dart' as http;

import '../../models/users/login_model.dart';

class UsersController extends GetxController {
  List<CategoryModel> categories = <CategoryModel>[];

  RxBool isUserLoggedIn = false.obs;

  final loadingStatus = LoadingStatus.loading.obs;

  @override
  void onReady() async {
    super.onReady();
    isUserLoggedIn.value =
        await SecureStorage.getAccessToken() != null ? true : false;
    print(isUserLoggedIn);
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
}
