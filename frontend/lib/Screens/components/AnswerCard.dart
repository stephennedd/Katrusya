import 'package:flutter/material.dart';
import 'package:frontend/Themes/app_colors.dart';
import 'package:frontend/Themes/ui_parameters.dart';

enum AnswerStatus { correct, wrong, answered, notanswered }

class AnswerCard extends StatefulWidget {
  final String answer;
  final VoidCallback onTap;
  final bool isSelected;

  const AnswerCard({
    Key? key,
    required this.answer,
    this.isSelected = false,
    required this.onTap,
  }) : super(key: key);

  @override
  _AnswerCardState createState() => _AnswerCardState();
}

class _AnswerCardState extends State<AnswerCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: UIParameters.cardBorderRadius,
      onTap: () {
        widget.onTap();
      },
      child: Ink(
        child: Container(
          decoration: BoxDecoration(
            color: widget.isSelected ? Colors.red : Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(13.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Text(
              widget.answer,
              style: TextStyle(
                color: widget.isSelected ? Colors.white : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
