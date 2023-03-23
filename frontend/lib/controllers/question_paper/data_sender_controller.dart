import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/Services/data_services.dart';
import 'package:frontend/models/LoadingStatus.dart';
import 'package:frontend/models/question_paper_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DataSenderController extends GetxController {
  final service = new DataServices();
  String _baseUsl = 'http://145.2.226.196:3000';
  @override
  void onReady() {
    super.onReady();
  }

  Future<void> sendTheUserResultsPerTest(
      userId, testId, numberOfHpPoints) async {
    debugPrint(userId.toString());
    debugPrint(testId.toString());
    debugPrint(numberOfHpPoints.toString());
    await service.addUserResultsPerTest(userId, testId, numberOfHpPoints);
  }
}
