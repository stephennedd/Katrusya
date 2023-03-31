import 'package:frontend/api/my_api.dart';
import 'package:frontend/models/course_query_params_model.dart';
import 'package:frontend/models/courses/course_details_model.dart';
import 'package:frontend/models/courses/course_model.dart';
import 'package:frontend/models/loading_status_model.dart';
import 'package:frontend/models/quizzes/question_paper_model.dart';
import 'package:frontend/screens/homescreens/MyCourses.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../models/courses/purchase_model.dart';
import '../../../models/quizzes/quiz_model.dart';

class CourseController extends GetxController {
  RxList<CourseModel> recommendedCourses = RxList<CourseModel>([]);
  RxList<CourseModel> featuredCourses = RxList<CourseModel>([]);
  RxList<QuizModel> courseQuizzes = RxList<QuizModel>([]);
  RxList<CourseModel> courses = RxList<CourseModel>([]);
  final currentCourseId = 0.obs;
  final isCurrentCoursePurchased = false.obs;

  Rxn<CourseDetailsModel> currentCourseDetails = Rxn<CourseDetailsModel>();

  final loadingStatus = LoadingStatus.loading.obs;

  @override
  void onReady() async {
    getRecommendedCourses(null);
    getFeaturedCourses(null);
    getCourses(null, null);
    //  super.onReady();
  }

  Future<List<CourseModel>> getRecommendedCourses(String? category) async {
    loadingStatus.value = LoadingStatus.loading;
    RxList<CourseModel> data = await CallApi().getCourses(
        new CourseQueryParamsModel(isRecommended: true, category: category));
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

  Future<RxList<CourseModel>> getCourses(
      String? category, String? search) async {
    loadingStatus.value = LoadingStatus.loading;
    RxList<CourseModel> data = await CallApi().getCourses(
        new CourseQueryParamsModel(category: category, search: search));
    courses.value = data;
    loadingStatus.value = LoadingStatus.completed;
    return courses;
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
        new CourseQueryParamsModel(isFeatured: true, category: category));
    featuredCourses.value = data;
    loadingStatus.value = LoadingStatus.completed;
    return featuredCourses;
  }
}
