import 'package:frontend/api/my_api.dart';
import 'package:frontend/models/course_query_params_model.dart';
import 'package:frontend/models/courses/course_details_model.dart';
import 'package:frontend/models/courses/course_model.dart';
import 'package:frontend/models/loading_status_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../models/courses/purchase_model.dart';
import '../../../models/quizzes/quiz_model.dart';

class CourseController extends GetxController {
  RxList<CourseModel> recommendedCourses = RxList<CourseModel>([]);
  RxList<CourseModel> featuredCourses = RxList<CourseModel>([]);
  RxList<CourseModel> searchedCourses = RxList<CourseModel>([]);
  RxList<QuizModel> courseQuizzes = RxList<QuizModel>([]);
  RxList<QuizModel> sectionQuizzes = RxList<QuizModel>([]);
  RxList<CourseModel> courses = RxList<CourseModel>([]);
  final currentCourseId = 0.obs;
  final currentSectionId = 0.obs;
  final isCurrentCoursePurchased = false.obs;

  Rxn<CourseDetailsModel> currentCourseDetails = Rxn<CourseDetailsModel>();

  final loadingStatus = LoadingStatus.loading.obs;

  @override
  void onReady() async {
    getRecommendedCourses(null);
    getFeaturedCourses(null);
    getCourses();
    getSearchedCourses("All", null);
    //  super.onReady();
  }

  Future<List<CourseModel>> getRecommendedCourses(String? category) async {
    loadingStatus.value = LoadingStatus.loading;
    RxList<CourseModel> data = await CallApi().getCourses(
        CourseQueryParamsModel(isRecommended: true, category: category));
    recommendedCourses.value = data;
    loadingStatus.value = LoadingStatus.completed;
    return recommendedCourses;
  }

  Future<List<QuizModel>> getCourseQuizzes(int courseId) async {
    loadingStatus.value = LoadingStatus.loading;
    RxList<QuizModel> data = await CallApi().getCourseQuizzes(courseId);
    courseQuizzes.value = data;
    loadingStatus.value = LoadingStatus.completed;
    return courseQuizzes;
  }

  RxList<QuizModel> getSectionQuizzes(int sectionId) {
    loadingStatus.value = LoadingStatus.loading;
    sectionQuizzes.value = [];
    for (int i = 0; i < courseQuizzes.value.length; i++) {
      if (courseQuizzes.value[i].sectionId == sectionId) {
        sectionQuizzes.value.add(courseQuizzes.value[i]);
      }
    }
    loadingStatus.value = LoadingStatus.completed;
    return sectionQuizzes;
  }

  Future<RxList<CourseModel>> getCourses() async {
    loadingStatus.value = LoadingStatus.loading;
    RxList<CourseModel> data = await CallApi()
        .getCourses(CourseQueryParamsModel(category: null, search: null));
    courses.value = data;
    // if (category == null && search == null) {
    //   for (int i = 0; i < courses.value.length; i++) {
    //     if (courses.value[i].isRecommended) {
    //       recommendedCourses.value.add(courses.value[i]);
    //     } else if (courses.value[i].isFeatured) {
    //       featuredCourses.value.add(courses.value[i]);
    //     }
    //   }
    // }
    loadingStatus.value = LoadingStatus.completed;
    return courses;
  }

  CourseModel? getMyCourse(int courseId) {
    CourseModel? course;
    for (int i = 0; i < courses.length; i++) {
      if (courses[i].id == courseId) {
        course = courses[i];
      }
    }
    return course;
  }

  Future<Rxn<CourseDetailsModel>> getCourseDetails(int courseId) async {
    loadingStatus.value = LoadingStatus.loading;
    currentCourseDetails.value = await CallApi().getCourseDetails(courseId);
    loadingStatus.value = LoadingStatus.completed;
    return currentCourseDetails;
  }

  Future<http.Response> buyCourse(PurchaseModel purchase) async {
    loadingStatus.value = LoadingStatus.loading;
    var response = await CallApi().addPurchasedCourse(purchase);
    loadingStatus.value = LoadingStatus.completed;
    return response;
  }

  // Future<RxList<CourseModel>> getCoursesBasedOnCategoryName(category) async {
  //   loadingStatus.value = LoadingStatus.loading;
  //   RxList<CourseModel> data =
  //       await CallApi().
  //   courses.value = data;
  //   loadingStatus.value = LoadingStatus.completed;
  //   return courses;
  // }

  Future<List<CourseModel>> getFeaturedCourses(String? category) async {
    loadingStatus.value = LoadingStatus.loading;
    RxList<CourseModel> data = await CallApi().getCourses(
        CourseQueryParamsModel(isFeatured: true, category: category));
    featuredCourses.value = data;
    loadingStatus.value = LoadingStatus.completed;
    return featuredCourses;
  }

  Future<List<CourseModel>> getSearchedCourses(
      String? category, String? search) async {
    loadingStatus.value = LoadingStatus.loading;
    RxList<CourseModel> data = await CallApi().getCourses(
        CourseQueryParamsModel(category: category, search: search));
    searchedCourses.value = data;
    loadingStatus.value = LoadingStatus.completed;
    return courses;
  }
}
