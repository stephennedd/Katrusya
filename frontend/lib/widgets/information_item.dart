import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InformationItem extends StatelessWidget {
  InformationItem({Key? key, required this.icon, required this.text, required this.type}) : super(key: key);
  Icon icon;
  String type;
  String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              icon,
              const SizedBox(width: 5,),
              Text(
                type,
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w400
                ),
              ),
            ],
          ),

          Text(
            text,
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600
            ),
          )
        ],
      ),
    );
  }
}
