import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/Screens/components/AnswerCard.dart';
import 'package:frontend/Screens/components/BackgroundDecoration.dart';
import 'package:frontend/Screens/components/QuestionPlaceHolder.dart';
import 'package:frontend/Screens/testOverviewScreen.dart';
import 'package:frontend/Screens/watchCourseScreen.dart';
import 'package:frontend/model/LoadingStatus.dart';
import 'package:frontend/controllers/question_paper/data_uploader.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
  static const String routeName = "/quizscreen";

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

int remainSeconds = 1;

class _QuizScreenState extends State<QuizScreen> {
  DataUpLoader controller = Get.put(DataUpLoader());
  @override
  void initState() {
    super.initState();
    _startTimer(900);
  }

  int? _selectedIndex;
  int currentQuestionIndex = 0;

  void _onAnswerCardTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _nextQuestion() {
    setState(() {
      _selectedIndex = null;
      currentQuestionIndex++;
    });
  }

  void _prevQuestion() {
    setState(() {
      _selectedIndex = null;
      currentQuestionIndex--;
    });
  }

  String time = "00:00";

  void _startTimer(int seconds) {
    const duration = Duration(seconds: 1);
    int remainSeconds = seconds;
    Timer.periodic(duration, (Timer timer) {
      if (remainSeconds == 0) {
        timer.cancel();
      } else {
        int minutes = remainSeconds ~/ 60;
        int seconds = remainSeconds % 60;
        if (mounted) {
          setState(() {
            time =
                '${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}';
          });
        }
        remainSeconds--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List questionsInfo = [];

    // _startTimer(900);

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
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: Colors.black), // Set the color of the back button
            onPressed: () {
              Get.offAllNamed(
                  WatchCourse.routeName); // Go back to the previous screen
            },
          ),
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              Text(
                'Question ${currentQuestionIndex + 1}',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              IconButton(
                onPressed: () {
                  debugPrint(controller.questionsData[0].title);
                  // Navigator.push(
                  //   context,
                  //   PageTransition(
                  //       child: EmptyPage(
                  //         time: time,
                  //         currentQuestionIndex: currentQuestionIndex,
                  //       ),
                  //       type: PageTransitionType.leftToRightWithFade),
                  // );
                  Get.to(() => TestOverviewScreen());
                },
                icon: Icon(Icons.menu, color: Colors.black),
              ),
            ],
          )),
      body: BackgroundDecoration(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
              ),
              // if (controller.loadingStatus.value != LoadingStatus.completed)
              //  const Expanded(child: QuestionScreenHolder()),
              FutureBuilder<List<dynamic>>(
                future: _loadQuestionsInfo(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.hasData) {
                    List<dynamic> questionsInfo = snapshot.data!;
                    if (controller.loadingStatus.value !=
                        LoadingStatus.completed)
                      return const Expanded(child: QuestionScreenHolder());
                    else if (questionsInfo == null)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    else if (currentQuestionIndex >= questionsInfo!.length)
                      return Text(
                        "Quiz completed",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800),
                      );
                    else
                      return SingleChildScrollView(
                          physics: ScrollPhysics(),
                          child: Column(children: [
                            Text(
                              questionsInfo[currentQuestionIndex]["question"],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w800),
                            ),
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 8),
                              itemCount: questionsInfo![currentQuestionIndex]
                                      ["answers"]
                                  .length,
                              itemBuilder: (_, int index) {
                                final answer =
                                    questionsInfo![currentQuestionIndex]
                                        ["answers"][index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 8.0),
                                  child: AnswerCard(
                                    answer: answer,
                                    isSelected: index == _selectedIndex,
                                    onTap: () => _onAnswerCardTapped(index),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 20),
                          ]));
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (currentQuestionIndex > 0)
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: SizedBox(
                          width: 55,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary:
                                  Colors.white, // Set the button color to white
                            ),
                            onPressed: () => {_prevQuestion()},
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    FutureBuilder<List<dynamic>>(
                      future: _loadQuestionsInfo(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<dynamic>> snapshot) {
                        if (snapshot.hasData) {
                          List<dynamic> questionsInfo = snapshot.data!;
                          // if (controller.loadingStatus.value !=
                          //    LoadingStatus.completed)
                          //  return const Expanded(
                          //     child: QuestionScreenHolder());
                          // else
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: SizedBox(
                                height: 55,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                  ),
                                  onPressed: () => {
                                    if (currentQuestionIndex >=
                                        questionsInfo.length - 1)
                                      {Get.to(() => TestOverviewScreen())}
                                    else
                                      {_nextQuestion()}
                                  },
                                  child: Text(
                                    currentQuestionIndex >=
                                            questionsInfo.length - 1
                                        ? "Complete"
                                        : "Next",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                    // Expanded(
                    //   child: Padding(
                    //     padding: EdgeInsets.symmetric(horizontal: 16),
                    //     child: SizedBox(
                    //       height: 55,
                    //       child: // if (currentQuestionIndex >= questionsInfo!.length){}
                    //           ElevatedButton(
                    //         style: ElevatedButton.styleFrom(
                    //           primary:
                    //               Colors.white, // Set the button color to white
                    //         ),
                    //         onPressed: () => _nextQuestion(),
                    //         child: Text(
                    //           currentQuestionIndex >= questionsInfo.length - 1
                    //               ? "Complete"
                    //               : "Next",
                    //           style: TextStyle(
                    //             color:
                    //                 Colors.black, // Set the text color to black
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
