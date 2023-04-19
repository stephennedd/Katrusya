import 'package:frontend/api/my_api.dart';
import 'package:frontend/models/categories/category_model.dart';
import 'package:frontend/models/loading_status_model.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  List<CategoryModel> categories = <CategoryModel>[];

  final loadingStatus = LoadingStatus.loading.obs;

  @override
  void onReady() async {
    getCategories();
    super.onReady();
  }

  Future<List<CategoryModel>> getCategories() async {
    loadingStatus.value = LoadingStatus.loading;
    List<CategoryModel> data = await CallApi().getCategories();
    categories = data;
    loadingStatus.value = LoadingStatus.completed;
    return categories;
  }
}
