import 'package:frontend/api/my_api.dart';
import 'package:frontend/models/courses/course_model.dart';
import 'package:frontend/models/loading_status_model.dart';
import 'package:frontend/models/question_paper_model.dart';
import 'package:frontend/screens/homescreens/MyCourses.dart';
import 'package:get/get.dart';

class CourseController extends GetxController {
  List<CourseModel> recommendedCourses = <CourseModel>[];
  List<CourseModel> featuredCourses = <CourseModel>[];

  final loadingStatus = LoadingStatus.loading.obs;

  @override
  void onReady() async {
    getRecommendedCourses();
    getFeaturedCourses();
    super.onReady();
  }

  Future<List<CourseModel>> getRecommendedCourses() async {
    loadingStatus.value = LoadingStatus.loading;
    List<CourseModel> data = await CallApi().getRecommendedCourses();
    recommendedCourses = data;
    loadingStatus.value = LoadingStatus.completed;
    return recommendedCourses;
  }

  Future<List<CourseModel>> getFeaturedCourses() async {
    loadingStatus.value = LoadingStatus.loading;
    List<CourseModel> data = await CallApi().getFeaturedCourses();
    featuredCourses = data;
    loadingStatus.value = LoadingStatus.completed;
    return featuredCourses;
  }
}
