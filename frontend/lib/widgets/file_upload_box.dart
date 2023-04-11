import 'package:flutter/material.dart';
import 'package:frontend/Themes/app_colors.dart';

class FileUploadBox extends StatelessWidget {
  FileUploadBox({Key? key, this.onUploadPressed}) : super(key: key);
  GestureTapCallback? onUploadPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: appBarColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: shadowColor.withOpacity(.1),
              spreadRadius: .5,
              blurRadius: .5,
              offset: const Offset(0, 0)
          )
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            highlightColor: Colors.grey,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.grey)
            ),
            icon: const Icon(
              Icons.file_upload_outlined,
              color: lightGrey,
            ),
            onPressed: onUploadPressed,
          ),
          const SizedBox(width: 15,),
          const Text(
            "Click to upload",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }
}
