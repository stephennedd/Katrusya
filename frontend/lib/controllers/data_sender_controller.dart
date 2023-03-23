import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/Services/data_services.dart';
import 'package:frontend/api/my_api.dart';
import 'package:frontend/models/LoadingStatus.dart';
import 'package:frontend/models/question_paper_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DataSenderController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  Future<void> sendTheUserResultsPerTest(apiUrl, data) async {
    await CallApi().addUserResultsPerTest(apiUrl, data);
  }
}
