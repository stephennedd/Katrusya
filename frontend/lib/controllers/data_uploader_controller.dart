
import 'package:frontend/Services/data_services.dart';
import 'package:frontend/api/my_api.dart';
import 'package:frontend/models/loading_status_model.dart';
import 'package:get/get.dart';

import '../models/quizzes/question_paper_model.dart';

class DataUpLoader extends GetxController {
  late QuestionPaperModel questionsData;
  final loadingStatus = LoadingStatus.loading.obs;

  final service = DataServices();
  @override
  void onReady() {
    getTestsBasedOnSectionId(1);
    super.onReady();
  }

  // Future<QuestionPaperModel> getTestsBasedOnSectionId(sectionId) async {
  //   loadingStatus.value = LoadingStatus.loading;
  //   QuestionPaperModel test = await service.getTestBasedOnSectionId(sectionId);
  //   questionsData = test;
  //   loadingStatus.value = LoadingStatus.completed;
  //   print(test);
  //   return test;

  // final manifestoContent = await DefaultAssetBundle.of(Get.context!)
  //     .loadString("AssetManifest.json");
  // final Map<String, dynamic> manifestMap = json.decode(manifestoContent);
  // final papersInAssets = manifestMap.keys
  //     .where((path) => path.startsWith("DB/paper") && path.contains(".json"))
  //     .toList();
  // List<QuestionPaperModel> questionPapers = [];
  // for (var paper in papersInAssets) {
  //   String stringPaperContent = await rootBundle.loadString(paper);
  //   print(stringPaperContent);
  //   questionPapers
  //       .add(QuestionPaperModel.fromJson(json.decode(stringPaperContent)));
  // }
  // questionsData = questionPapers;
  // loadingStatus.value = LoadingStatus.completed;
  //}

  Future<QuestionPaperModel> getTestsBasedOnSectionId(sectionId) async {
    loadingStatus.value = LoadingStatus.loading;
    QuestionPaperModel test =
        await CallApi().getTestBasedOnSectionId(sectionId);
    questionsData = test;
    loadingStatus.value = LoadingStatus.completed;
    return test;
  }
}
