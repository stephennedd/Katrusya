import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/themes/app_colors.dart';
import 'package:frontend/widgets/app_bar_box.dart';
import 'package:frontend/widgets/file_upload_box.dart';
import 'package:frontend/widgets/uploaded_file_box.dart';
import '../themes/app_colors.dart';
import '../widgets/button.dart';
import '../widgets/text_input.dart';

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({Key? key}) : super(key: key);

  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  int _currentPageIndex = 0;
  final PageController _pageController = PageController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController topicsController = TextEditingController();
  final TextEditingController requirementsController = TextEditingController();
  final TextEditingController sectionController = TextEditingController();
  PlatformFile? imageFile;
  String imagePath = "";
  String courseTitle = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        hasBackButton: false,
        title: 'Add Course',
      ),
      body: buildBody(),
      bottomNavigationBar: _currentPageIndex == 0 
        ? buildBottomBar(_pageController)
        : _currentPageIndex == 3
          ? getBottomBarWithSubmitButton(_pageController)
          : getBottomBarWithBackButton(_pageController)
    );
  }

  late int pageCount;
  List<UploadedItem> uploadedItems = [];
  Widget buildBody() {
    pageCount = 4;
    return FutureBuilder(
      future: Future.value(true),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildPageIndicator(),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPageIndex = index;
                  });
                },
                children: [
                  //Page 1
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Enter course title and description',
                              style: TextStyle(
                                fontFamily: 'Nexa-Trial',
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Form(
                          child: Column(children: [
                            FormInput(
                              text: 'title',
                              type: TextInputType.text,
                              validatorText: "a title",
                              textController: nameController,
                            ),
                            const SizedBox(height: 16.0),
                            FormInput(
                              text: 'description',
                              type: TextInputType.text,
                              validatorText: "a description",
                              textController: descriptionController,
                              maxLines: 13,
                              minLines: 12,
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),

                  // Page 2
                  Container(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Enter the course category, topics, requirements and choose a course image',
                          style: TextStyle(
                            fontFamily: 'Nexa-Trial',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Form(
                          child: Column(children: [
                            FormInput(
                              text: 'category',
                              type: TextInputType.text,
                              validatorText: "a category",
                              textController: categoryController,
                            ),
                            const SizedBox(height: 16.0),
                            FormInput(
                              text: 'topics',
                              type: TextInputType.text,
                              validatorText: "topics",
                              textController: topicsController,
                            ),
                            const SizedBox(height: 16.0),
                            FormInput(
                              text: 'requirements',
                              type: TextInputType.text,
                              validatorText: "requirements",
                              textController: requirementsController,
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Upload a course Image",
                                  style: TextStyle(
                                      fontFamily: 'Nexa-Trial',
                                      fontWeight: FontWeight.w600,
                                      color: textColor),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            FileUploadBox(
                              onUploadPressed: () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                      allowMultiple: false,
                                      type: FileType.image,
                                    );
                                if (result != null) {
                                  PlatformFile imageFile = result.files.first;
                                  setState(() {
                                      imagePath = imageFile.path.toString();
                                  });
                                  // TODO upload the file to the firestore then update the user's image url to the saved image url
                                } else {
                                  // User canceled the picker
                                }
                              },
                            ),
                            const SizedBox(height: 16,),
                              if (imagePath.isNotEmpty)
                              Image.file(
                                File(imagePath),
                                height: 120,
                            )
                          ]),
                        ),
                      ],
                    ),
                  ),

                  // Page 3
                  Container(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Add at least 1 section',
                            style: TextStyle(
                              fontFamily: 'Nexa-Trial',
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                        ),
                        const SizedBox(height: 16.0),
                        Form(
                          child: Column(children: [
                            FormInput(
                              text: 'section title',
                              type: TextInputType.text,
                              validatorText: "a section",
                              textController: sectionController,
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Add lessons",
                                  style: TextStyle(
                                      fontFamily: 'Nexa-Trial',
                                      fontWeight: FontWeight.w500,
                                      color: textColor),
                                ),
                              ],
                            ),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Upload a lesson",
                                  style: TextStyle(
                                      fontFamily: 'Nexa-Trial',
                                      fontWeight: FontWeight.w600,
                                      color: textColor),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            FileUploadBox(
                              onUploadPressed: () async {
                                FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                                  type: FileType.video,
                                );

                                if (result != null) {
                                  PlatformFile file = result.files.first;
                                  UploadedItem item = UploadedItem(file.name, file.path);
                                  setState(() {
                                    uploadedItems.add(item);
                                  });
                                } else {
                                  // User canceled the picker
                                }
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              height: 200,
                              width: double.infinity,
                              child: ListView.builder(
                                itemCount: uploadedItems.length,
                                itemBuilder: (BuildContext context, int index) {
                                  UploadedItem item = uploadedItems[index];
                                  return UploadedFilesItem(
                                    data: item,
                                    onTap: () {
                                      setState(() {
                                        uploadedItems.removeAt(index);
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                            ButtonSimple(
                              text: "add section",
                              color: appBarColor
                            )
                          ]),
                        ),
                      ],
                    ),
                  ),


                  // Page 4
                  SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Confirm course details',
                                style: TextStyle(
                                  fontFamily: 'Nexa-Trial',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ]
                          ),
                          const SizedBox(height: 16,),
                          const Text(
                            "title",
                            style: TextStyle(
                                fontFamily: 'Nexa-Trial',
                                fontWeight: FontWeight.w500,
                                color: textColor),
                          ),
                          Text(
                            nameController.value.text,
                            style: const TextStyle(
                                fontFamily: 'Nexa-Trial',
                                fontWeight: FontWeight.w600,
                                color: textColor),
                          ),
                          const SizedBox(height: 16,),
                          const Text(
                            "description",
                            style: TextStyle(
                                fontFamily: 'Nexa-Trial',
                                fontWeight: FontWeight.w500,
                                color: textColor),
                          ),
                          Text(
                            descriptionController.value.text,
                            style: const TextStyle(
                                fontFamily: 'Nexa-Trial',
                                fontWeight: FontWeight.w600,
                                color: textColor),
                          ),
                          const SizedBox(height: 16,),
                          const Text(
                            "category",
                            style: TextStyle(
                                fontFamily: 'Nexa-Trial',
                                fontWeight: FontWeight.w500,
                                color: textColor),
                          ),
                          Text(
                            categoryController.value.text,
                            style: const TextStyle(
                                fontFamily: 'Nexa-Trial',
                                fontWeight: FontWeight.w600,
                                color: textColor),
                          ),
                          const SizedBox(height: 16,),
                          const Text(
                            "topics",
                            style: TextStyle(
                                fontFamily: 'Nexa-Trial',
                                fontWeight: FontWeight.w500,
                                color: textColor),
                          ),
                          Text(
                            topicsController.value.text,
                            style: const TextStyle(
                                fontFamily: 'Nexa-Trial',
                                fontWeight: FontWeight.w600,
                                color: textColor),
                          ),
                          const SizedBox(height: 16,),
                          const Text(
                            "requirements",
                            style: TextStyle(
                                fontFamily: 'Nexa-Trial',
                                fontWeight: FontWeight.w500,
                                color: textColor),
                          ),
                          Text(
                            requirementsController.value.text,
                            style: const TextStyle(
                                fontFamily: 'Nexa-Trial',
                                fontWeight: FontWeight.w600,
                                color: textColor),
                          ),
                          const SizedBox(height: 16,),
                          if (imagePath.isNotEmpty)
                            const Text(
                              "course image",
                              style: TextStyle(
                                  fontFamily: 'Nexa-Trial',
                                  fontWeight: FontWeight.w500,
                                  color: textColor),
                            ),
                            Image.file(
                              File(imagePath),
                              height: 120,
                            ),
                          const SizedBox(height: 16,),

                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < pageCount; i++) {
      indicators.add(
        i == _currentPageIndex ? _indicator(true) : _indicator(false),
      );
    }
    return indicators;
  }

}

class UploadedItem {
  String fileName;
  String? filePath;

  UploadedItem(this.fileName, this.filePath);
}


Widget buildBottomBar(PageController pageController) {
  return Padding(
    padding: const EdgeInsets.only(left: 25, right: 25, bottom: 10),
    child: SizedBox(
      height: 50,
      child: ButtonSimple(
        width: 180,
        text: "next",
        color: primary,
        textColor: primaryDark,
        onPressed: () {
          pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        },
      ),
    ),
  );
}

Widget getBottomBarWithBackButton(PageController pageController) {
  return Padding(
    padding: const EdgeInsets.only(left: 25, right: 25, bottom: 10),
    child: SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ButtonSimple(
            width: 170,
            text: "previous",
            color: primaryDark,
            textColor: primary,
            onPressed: () {
              pageController.previousPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
              );
            },
          ),
          const SizedBox(
            width: 15,
          ),
          ButtonSimple(
            width: 170,
            text: "next",
            color: primary,
            textColor: primaryDark,
            onPressed: () {
              pageController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
              );
            },
          ),
        ],
      ),
    ),
  );
}

Widget getBottomBarWithSubmitButton(PageController pageController) {
  return Padding(
    padding: const EdgeInsets.only(left: 25, right: 25, bottom: 10),
    child: SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ButtonSimple(
            width: 170,
            text: "edit",
            color: primaryDark,
            textColor: primary,
            onPressed: () {
              pageController.previousPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
              );
            },
          ),
          const SizedBox(
            width: 15,
          ),
          ButtonSimple(
            width: 170,
            text: "submit",
            color: primary,
            textColor: primaryDark,
            onPressed: () {
              // TODO create course model object and make api call to database
              print("upload");
            },
          ),
        ],
      ),
    ),
  );
}

Widget _indicator(bool isActive) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        height: 8.0,
        decoration: BoxDecoration(
          color: isActive ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
    ),
  );
}
