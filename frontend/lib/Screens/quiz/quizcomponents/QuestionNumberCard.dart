import 'package:flutter/material.dart';
import 'package:frontend/Screens/quiz/quizcomponents/AnswerCard.dart';
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
    Color _backgroundColor = Theme.of(context).primaryColor;
    switch (status) {
      case AnswerStatus.answered:
        _backgroundColor = Theme.of(context).primaryColor;
        break;

      case AnswerStatus.correct:
        _backgroundColor = correctAnswerColor;
        break;

      case AnswerStatus.wrong:
        _backgroundColor = wrongAnswerColor;
        break;

      case AnswerStatus.notanswered:
        _backgroundColor = Theme.of(context).primaryColor.withOpacity(0.1);
        break;

      default:
        _backgroundColor = Theme.of(context).primaryColor.withOpacity(0.1);
    }
    return InkWell(
      borderRadius: UIParameters.cardBorderRadius,
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: UIParameters.cardBorderRadius),
        child: Center(
          child: Text(
            '$index',
            style: TextStyle(
                color: status == AnswerStatus.notanswered
                    ? Theme.of(context).primaryColor
                    : null),
          ),
        ),
      ),
    );
  }
}