import 'package:flutter/material.dart';
import 'package:frontend/screens/quiz/quizcomponents/AnswerCard.dart';
import 'package:frontend/Themes/app_colors.dart';
import 'package:frontend/Themes/ui_parameters.dart';

class QuestionNumberCard extends StatelessWidget {
  final int index;
  final AnswerStatus? status;
  final VoidCallback onTap;

  const QuestionNumberCard(
      {super.key,
      required this.index,
      required this.status,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).primaryColor;
    switch (status) {
      case AnswerStatus.answered:
        backgroundColor = primaryDark;
        break;

      case AnswerStatus.correct:
        backgroundColor = primary;
        break;

      case AnswerStatus.wrong:
        backgroundColor = primaryDark;
        break;

      case AnswerStatus.notanswered:
        backgroundColor = primaryDark.withOpacity(0.1);
        break;

      default:
        backgroundColor = primaryDark.withOpacity(0.1);
    }
    return InkWell(
      borderRadius: UIParameters.cardBorderRadius,
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: UIParameters.cardBorderRadius),
        child: Center(
          child: Text(
            '$index',
            style: TextStyle(
                color: status == AnswerStatus.notanswered
                    ? primaryDark
                    : Colors.white),
          ),
        ),
      ),
    );
  }
}
