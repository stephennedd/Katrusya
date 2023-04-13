import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../Themes/app_colors.dart';

class CategoryBox extends StatelessWidget {
  const CategoryBox(
      {Key? key,
      required this.data,
      this.onTap,
      this.isSelected = false,
      this.activeColor = primaryDark,
      this.color = Colors.white})
      : super(key: key);
  final data;
  final bool isSelected;
  final Color activeColor;
  final Color color;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: isSelected ? activeColor : color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: shadowColor.withOpacity(.05),
                    spreadRadius: 0.5,
                    blurRadius: 0.5,
                    offset: const Offset(0, 0))
              ],
            ),
            child: SvgPicture.asset(
              data.icon,
              width: 30,
              height: 30,
              colorFilter: ColorFilter.mode(
                  isSelected ? primary : activeColor, BlendMode.srcIn),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            data.name,
            maxLines: 1,
            overflow: TextOverflow.fade,
            style: const TextStyle(
              fontFamily: 'Nexa-Trial',
              color: textColor,
              fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
