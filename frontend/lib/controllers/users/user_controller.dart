import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/api/my_api.dart';
import 'package:frontend/models/categories/category_model.dart';
import 'package:frontend/models/courses/completed_section_model.dart';
import 'package:frontend/models/courses/course_model.dart';
import 'package:frontend/models/loading_status_model.dart';
import 'package:frontend/models/quizzes/question_paper_model.dart';
import 'package:frontend/models/users/user_model.dart';
import 'package:frontend/screens/homescreens/MyCourses.dart';
import 'package:frontend/storage/secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../models/courses/completed_lesson_model.dart';
import '../../models/courses/favorite_course_model.dart';
import '../../models/courses/my_course_model.dart';
import '../../models/users/login_model.dart';
import '../marketplace/courses/course_controller.dart';

class UsersController extends GetxController {
  List<CategoryModel> categories = <CategoryModel>[];

  // RxList<FavoriteCourseModel> userFavoriteCourses =
  //   RxList<FavoriteCourseModel>([]);

  RxList<FavoriteCourseModel> userFavoriteCourses =
      RxList<FavoriteCourseModel>([]);
  RxList<MyCourseModel> userCourses = RxList<MyCourseModel>([]);
  RxList<CompletedLessonModel> userCompletedLessonsForCetainCourse =
      RxList<CompletedLessonModel>([]);
  RxList<CompletedSectionModel> userCompletedSections =
      RxList<CompletedSectionModel>([]);

  RxBool isUserLoggedIn = false.obs;
  RxInt balanceOfTokens = 0.obs;

  final loadingStatus = LoadingStatus.loading.obs;
  final GetStorage _getStorage = GetStorage();

  CourseController courseController = Get.put(CourseController());

  @override
  void onReady() async {
    super.onReady();
    isUserLoggedIn.value =
        await SecureStorage.getAccessToken() != null ? true : false;
    if (isUserLoggedIn.value) {
      await getUserFavoriteCourses(_getStorage.read('userId'));
      await getUserCourses(_getStorage.read('userId'));
      await getUserCompletedSections(_getStorage.read('userId'));
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
    userFavoriteCourses.value = await CallApi().getUserFavoriteCourses(userId);
    loadingStatus.value = LoadingStatus.completed;
    return userFavoriteCourses;
  }

  Future<List<CompletedLessonModel>> getUserCompletedLessonsForCertainCourse(
      int userId, int courseId) async {
    loadingStatus.value = LoadingStatus.loading;
    userCompletedLessonsForCetainCourse.value = await CallApi()
        .getCompletedByUserLessonsForCertainCourse(userId, courseId);
    loadingStatus.value = LoadingStatus.completed;
    return userCompletedLessonsForCetainCourse;
  }

  Future<List<CompletedSectionModel>> getUserCompletedSections(
      int userId) async {
    loadingStatus.value = LoadingStatus.loading;
    userCompletedSections.value =
        await CallApi().getCompletedByUserSections(userId);
    loadingStatus.value = LoadingStatus.completed;
    return userCompletedSections;
  }

  Future<List<MyCourseModel>> getUserCourses(int userId) async {
    loadingStatus.value = LoadingStatus.loading;
    userCourses.value = await CallApi().getUserCourses(userId);
    await getUserCompletedSections(userId);
    loadingStatus.value = LoadingStatus.completed;
    return userCourses;
  }

  Future<List<FavoriteCourseModel>> addCourseToUserFavorites(
      int userId, int courseId) async {
    loadingStatus.value = LoadingStatus.loading;
    FavoriteCourseModel addedfavoriteCourse =
        await CallApi().addCourseToUserFavorites(userId, courseId);
    userFavoriteCourses.add(addedfavoriteCourse);
    loadingStatus.value = LoadingStatus.completed;
    return userFavoriteCourses;
  }

  Future<List<FavoriteCourseModel>> deleteCourseFromUserFavorites(
      int userId, int courseId) async {
    loadingStatus.value = LoadingStatus.loading;
    FavoriteCourseModel deletedFavoriteCourse =
        await CallApi().deleteCourseFromUserFavorites(userId, courseId);
    userFavoriteCourses.removeWhere(
        (course) => course.courseId == deletedFavoriteCourse.courseId);
    loadingStatus.value = LoadingStatus.completed;
    return userFavoriteCourses;
  }

  Future<List<CompletedLessonModel>> addCompletedLessonByUser(
      int userId, int lessonId, int sectionId, int courseId) async {
    loadingStatus.value = LoadingStatus.loading;
    CompletedLessonModel addedCompletedLesson = await CallApi()
        .addCompletedByUserLesson(userId, courseId, sectionId, lessonId);
    userCompletedLessonsForCetainCourse.add(addedCompletedLesson);
    await getUserCompletedSections(userId);
    loadingStatus.value = LoadingStatus.completed;
    return userCompletedLessonsForCetainCourse;
  }

  Future<List<CompletedLessonModel>> deleteCompletedLessonByUser(
      int userId, int lessonId, int sectionId, int courseId) async {
    loadingStatus.value = LoadingStatus.loading;
    CompletedLessonModel deletedCompletedLesson = await CallApi()
        .deleteCompletedByUserLesson(userId, courseId, sectionId, lessonId);
    userCompletedLessonsForCetainCourse.removeWhere((course) =>
        course.courseId == deletedCompletedLesson.courseId &&
        course.lessonId == deletedCompletedLesson.lessonId &&
        course.sectionId == deletedCompletedLesson.sectionId &&
        course.userId == deletedCompletedLesson.userId);
    bool wasSectionCompleted =
        userCompletedSections.any((section) => section.sectionId == sectionId);
    if (wasSectionCompleted) {
      await getUserCompletedSections(userId);
    }
    loadingStatus.value = LoadingStatus.completed;
    return userCompletedLessonsForCetainCourse;
  }

  bool isCourseFavoriteForTheUser(courseId) {
    bool isCourseFavorite = false;
    for (int i = 0; i < userFavoriteCourses.length; i++) {
      if (userFavoriteCourses[i].courseId == courseId) {
        isCourseFavorite = true;
      }
    }
    return isCourseFavorite;
  }

  int getNumberOfCompleteByUserCourses() {
    int numberOfCompleteCourses = 0;
    for (int i = 0; i < userCourses.length; i++) {
      if (userCourses[i].isComplete) {
        numberOfCompleteCourses++;
      }
    }
    return numberOfCompleteCourses;
  }

  int getNumberOfIncompleteByUserCourses() {
    int numberOfIncompleteCourses = 0;
    for (int i = 0; i < userCourses.length; i++) {
      if (!userCourses[i].isComplete) {
        numberOfIncompleteCourses++;
      }
    }
    return numberOfIncompleteCourses;
  }

  double getCompletionRateOfSection(
      int sectionId, int numberOfLessonsPerSection) {
    int numberOfCompletedLessonsPerSection = 0;
    for (int i = 0; i < userCompletedLessonsForCetainCourse.length; i++) {
      if (userCompletedLessonsForCetainCourse[i].sectionId == sectionId) {
        numberOfCompletedLessonsPerSection++;
      }
    }
    double completionRate =
        numberOfCompletedLessonsPerSection / numberOfLessonsPerSection;

    return completionRate;
  }

  double getCompletionRateOfCourse(
      int courseId, int numberOfSectionsPerCourse) {
    int numberOfCompletedSectionsPerCourse = 0;
    for (int i = 0; i < userCompletedSections.length; i++) {
      if (userCompletedSections[i].courseId == courseId) {
        numberOfCompletedSectionsPerCourse++;
      }
    }
    double completionRate =
        numberOfCompletedSectionsPerCourse / numberOfSectionsPerCourse;

    return completionRate;
  }

  bool hasUserCompletedLesson(int sectionId, int lessonId, int courseId) {
    bool hasUserCompletedLesson = false;
    for (int i = 0; i < userCompletedLessonsForCetainCourse.length; i++) {
      if (userCompletedLessonsForCetainCourse[i].sectionId == sectionId &&
          userCompletedLessonsForCetainCourse[i].lessonId == lessonId &&
          userCompletedLessonsForCetainCourse[i].courseId == courseId) {
        hasUserCompletedLesson = true;
      }
    }
    return hasUserCompletedLesson;
  }
}
