import 'package:flutter/material.dart';
import 'package:frontend/Screens/quiz/quizcomponents/AnswerCard.dart';
import 'package:frontend/Screens/components/BackgroundDecoration.dart';
import 'package:frontend/Screens/components/ContentArea.dart';
import 'package:frontend/Screens/components/CustomAppBar.dart';
import 'package:frontend/Screens/components/MainButton.dart';
import 'package:frontend/Screens/quiz/quizcomponents/QuestionNumberCard.dart';
import 'package:frontend/Screens/quiz/quizcomponents/CountdownTimer.dart';
import 'package:frontend/Screens/quiz/quizscreens/resultScreen.dart';
import 'package:frontend/Themes/custom_text_styles.dart';
import 'package:frontend/Themes/ui_parameters.dart';
import 'package:frontend/controllers/question_paper/questions_controller.dart';
import 'package:get/get.dart';

class TestOverviewScreen extends GetView<QuestionsController> {
  const TestOverviewScreen({super.key});
  static const String routeName = "/testoverview";

  //String getCompletedTest{}

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: PreferredSize(
//           preferredSize: Size.fromHeight(60.0),
//           child: AppBar(
//               backgroundColor: Colors.white,
//               leading: IconButton(
//                 icon: Icon(Icons.arrow_back_ios,
//                     color: Colors.black), // Set the color of the back button
//                 onPressed: () {
//                   Navigator.pop(context); // Go back to the previous screen
//                 },
//               ),
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Question 1',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.w800,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ))),
//       body: BackgroundDecoration(
//         child: Center(child: Text("Test ")),
//       ),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: controller.completedTest,
      ),
      body: BackgroundDecoration(
        child: Column(
          children: [
            Expanded(
                child: ContentArea(
              addPadding: true,
              child: Column(
                children: [
                  Row(
                    children: [
                      CountdownTimer(
                        color: Theme.of(context).primaryColor,
                        time: '',
                      ),
                      Obx(() => Text(
                            '${controller.time} Remaining',
                            style: countDownTimerTs(),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      child: GridView.builder(
                          itemCount: controller.allQuestions.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: Get.width ~/ 75,
                                  childAspectRatio: 1,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8),
                          itemBuilder: (_, index) {
                            AnswerStatus? _answerStatus;
                            if (controller.allQuestions[index].selectedAnswer !=
                                null) {
                              _answerStatus = AnswerStatus.answered;
                            }
                            return QuestionNumberCard(
                                index: index + 1,
                                status: _answerStatus,
                                onTap: () => controller.jumpToQuestion(index));
                          })),
                  ColoredBox(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Row(
                        children: [
                          Expanded(
                              child: MainButton(
                            onTap: () {
                              controller.complete();
                            },
                            title: 'Complete',
                          ))
                        ],
                      ))

                  // Expanded(
                  //   child: MainButton(
                  //     onTap: () {
                  //       controller.complete();
                  //     },
                  //     title: 'Complete',
                  //   ),
                  // ),
                  // ColoredBox(
                  //   color: Colors.white,
                  //   child: Padding(
                  //     padding: UIParameters.mobileScreenPadding,
                  //     child: MainButton(
                  //       onTap: () {
                  //         // Get.toNamed(ResultScreen.routeName);
                  //         controller.complete();
                  //       },
                  //       title: 'Complete',
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
