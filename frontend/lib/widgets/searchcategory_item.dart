import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../Themes/app_colors.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem(
      {Key? key, required this.data, this.isSelected = false, this.onTap})
      : super(key: key);

  final dynamic data;
  final bool isSelected;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
            color: isSelected ? primaryDark : Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                  color: shadowColor.withOpacity(.05),
                  blurRadius: .05,
                  spreadRadius: .05,
                  offset: const Offset(1, 1)),
            ]),
        child: Row(
          children: [
            SvgPicture.asset(
              data.icon,
              colorFilter: ColorFilter.mode(
                  isSelected ? primary : primaryDark, BlendMode.srcIn),
              width: 16,
              height: 16,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              data.name,
              style: TextStyle(
                  color: isSelected ? primary : primaryDark,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
