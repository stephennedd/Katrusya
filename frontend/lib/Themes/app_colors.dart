import 'package:flutter/material.dart';
import 'package:frontend/Themes/ui_parameters.dart';
import 'package:get/get.dart';

Color answerSelectedColor() => Theme.of(Get.context!).primaryColor;

Color answerBorderColor() => const Color.fromARGB(255, 221, 221, 221);

const Color correctAnswerColor = Color(0xFF3ac3cb);
const Color wrongAnswerColor = Color(0xFFf85187);
const Color notAnsweredColor = Color(0xFF2a3c65);
