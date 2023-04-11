import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

class UploadedFilesItem extends StatelessWidget {
  UploadedFilesItem({Key? key, required this.data, this.onTap}) : super(key: key);
  final data;
  GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0,4,0,4),
      decoration: BoxDecoration(
          color: appBarColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.1),
              blurRadius: 0.5,
              spreadRadius: 0.5,
              offset: const Offset(0,0),
            )
          ]
      ),
      child: ListTile(
        leading: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              color: uploadedItemImageBackground,
              borderRadius: BorderRadius.circular(8)
          ),
          child: const Icon(
            Icons.slideshow_rounded,
            color: Colors.red,
          ),
        ),
        title: Text(
          data.fileName,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14
          ),
        ),
        trailing: GestureDetector(
          onTap: onTap,
          child: const Icon(
              Icons.close_rounded
          ),
        ),
      ),
    );
  }
}
