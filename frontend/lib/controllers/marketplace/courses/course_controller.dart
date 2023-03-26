import 'package:frontend/api/my_api.dart';
import 'package:frontend/models/course_query_params_model.dart';
import 'package:frontend/models/courses/course_model.dart';
import 'package:frontend/models/loading_status_model.dart';
import 'package:frontend/models/question_paper_model.dart';
import 'package:frontend/screens/homescreens/MyCourses.dart';
import 'package:get/get.dart';

class CourseController extends GetxController {
  RxList<CourseModel> recommendedCourses = RxList<CourseModel>([]);
  RxList<CourseModel> featuredCourses = RxList<CourseModel>([]);
  RxList<CourseModel> courses = RxList<CourseModel>([]);

  final loadingStatus = LoadingStatus.loading.obs;

  @override
  void onReady() async {
    getRecommendedCourses(null);
    getFeaturedCourses(null);
    getCourses(null);
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

  Future<RxList<CourseModel>> getCourses(String? category) async {
    loadingStatus.value = LoadingStatus.loading;
    RxList<CourseModel> data = await CallApi()
        .getCourses(new CourseQueryParamsModel(category: category));
    courses.value = data;
    loadingStatus.value = LoadingStatus.completed;
    return courses;
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
