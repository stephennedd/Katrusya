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
  String _baseUsl = 'http://145.2.226.196:3000';
  @override
  void onReady() {
    getTestsBasedOnSectionId(1);
    super.onReady();
  }

  List<QuestionPaperModel> questionsData = [];
  final loadingStatus = LoadingStatus.loading.obs;

  Future<List<dynamic>> getTestsBasedOnSectionId(sectionId) async {
    List<QuestionPaperModel> tests =
        await service.getTestsBasedOnSectionId(sectionId);
    questionsData = tests;
    loadingStatus.value = LoadingStatus.completed;
    print(tests);
    return tests;

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
}
