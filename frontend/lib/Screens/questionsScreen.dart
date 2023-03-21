import 'dart:convert';
import 'dart:html';
import 'dart:js';

import 'package:flutter/material.dart';
import 'package:frontend/Screens/components/AnswerCard.dart';
import 'package:frontend/Screens/components/BackgroundDecoration.dart';
import 'package:frontend/Screens/components/QuestionPlaceHolder.dart';
import 'package:get/get.dart';

class QuestionsScreen extends StatelessWidget {
  const QuestionsScreen({super.key});
  static const String routeName = "/questionsscreen";

  // int? _selectedIndex;

  // void _onAnswerCardTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    List questionsInfo = [];

    _initData() {
      DefaultAssetBundle.of(context)
          .loadString("json/questions.json")
          .then((value) {
        questionsInfo = json.decode(value);
      });
    }

    Future<List<dynamic>> _loadQuestionsInfo() async {
      String jsonString = await DefaultAssetBundle.of(context)
          .loadString('json/questions.json');
      return json.decode(jsonString);
    }

    return Scaffold(
      body: BackgroundDecoration(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //if (isLoading) const Expanded(child: QuestionScreenHolder()),
              Text(
                "I am here",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              FutureBuilder<List<dynamic>>(
                future: _loadQuestionsInfo(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.hasData) {
                    List<dynamic> questionsInfo = snapshot.data!;
                    return Expanded(
                      child: ListView.builder(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                        itemCount: questionsInfo[0]["answers"].length,
                        itemBuilder: (_, int index) {
                          final answer = questionsInfo[0]["answers"][index];
                          debugPrint(answer);
                          return Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: AnswerCard(
                              answer: answer,
                              onTap: () {},
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
