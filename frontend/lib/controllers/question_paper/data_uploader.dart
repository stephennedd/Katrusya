import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/Services/data_services.dart';
import 'package:frontend/models/LoadingStatus.dart';
import 'package:frontend/models/question_paper_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DataUpLoader extends GetxController {
  final service = new DataServices();
  String _baseUsl = 'http://localhost:3000';
  @override
  void onReady() {
    getTestsBasedOnSectionId(1);
    super.onReady();
  }

  late QuestionPaperModel questionsData;
  final loadingStatus = LoadingStatus.loading.obs;

  Future<QuestionPaperModel> getTestsBasedOnSectionId(sectionId) async {
    QuestionPaperModel test = await service.getTestBasedOnSectionId(sectionId);
    questionsData = test;
    loadingStatus.value = LoadingStatus.completed;
    print(test);
    return test;

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
  }

  Future<void> sendTheUserResultsPerTest(
      userId, testId, numberOfHpPoints) async {
    await service.addUserResultsPerTest(testId, userId, numberOfHpPoints);
  }
}
