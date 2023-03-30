import 'package:flutter/material.dart';
import 'package:frontend/Themes/ui_parameters.dart';
import 'package:get/get.dart';

const questionTS = TextStyle(fontSize: 16, fontWeight: FontWeight.w800);

const appBarTS =
    TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white);
TextStyle countDownTimerTs() =>
    TextStyle(letterSpacing: 2, color: Theme.of(Get.context!).primaryColor);
