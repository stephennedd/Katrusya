import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:frontend/widgets/app_bar_box.dart';
import 'package:frontend/widgets/file_upload_box.dart';

import '../Themes/app_colors.dart';
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Add Course',
      ),
      body: buildBody(),
      bottomNavigationBar:_pageController.page! > 1 ? getBottomBarWithBackButton(_pageController) : buildBottomBar(_pageController),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildPageIndicator(_currentPageIndex),
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
              // Page 1
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Enter course title and description',
                      style: TextStyle(
                        fontFamily: 'Nexa-Trial',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 16.0),
                    Form(
                      child:
                      Column(
                        children : [
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

                        ]
                      ),
                    ),
                  ],
                ),
              ),

              // Page 2
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Enter the course category, topics, requirements and choose a course image',
                      style: TextStyle(
                        fontFamily: 'Nexa-Trial',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Form(
                      child:
                      Column(
                          children : [
                            FormInput(
                              text: 'category',
                              type: TextInputType.text,
                              validatorText: "a category",
                              textController: nameController,
                            ),
                            const SizedBox(height: 16.0),
                            FormInput(
                              text: 'topics',
                              type: TextInputType.text,
                              validatorText: "a description",
                              textController: descriptionController,
                            ),
                            const SizedBox(height: 16.0),
                            FormInput(
                              text: 'requirements',
                              type: TextInputType.text,
                              validatorText: "requirements",
                              textController: descriptionController,
                            ),
                            const SizedBox(height: 16.0,),
                            FileUploadBox(
                              onUploadPressed: () async {
                                FilePickerResult? result = await FilePicker.platform.pickFiles(
                                  type: FileType.image,
                                );

                                if (result != null) {
                                  PlatformFile file = result.files.first;
                                  // TODO upload the file to the firestore then update the user's image url to the saved image url
                                } else {
                                  // User canceled the picker
                                }
                              },
                            )
                          ]
                      ),
                    ),
                  ],
                ),
              ),

              // Page 3
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Confirm your information',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Text('Name: John Doe'),
                    const SizedBox(height: 16.0),
                    const Text('Age: 25'),
                    const SizedBox(height: 16.0),
                    TextButton(
                      child: const Text('Submit'),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirmation'),
                              content: const Text(
                                  'Your information has been submittedsuccessfully.'),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }
}

Widget buildBottomBar(PageController _pageController) {
  return Padding(
    padding: const EdgeInsets.only(left: 25, right: 25),
    child: SizedBox(
      height: 50,
      child: ButtonSimple(
        width: double.infinity,
        text: "next",
        color: primary,
        textColor: primaryDark,
        onPressed: () {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        },
      ),
    ),
  );
}
Widget getBottomBarWithBackButton(PageController _pageController) {
  return Padding(
    padding: const EdgeInsets.only(left: 25, right: 25),
    child: SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ButtonSimple(
            width: 160,
            text: "previous",
            color: primaryDark,
            textColor: primary,
            onPressed: () {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
              );
            },
          ),
          const SizedBox(width: 15,),
          ButtonSimple(
            width: 160,
            text: "next",
            color: primary,
            textColor: primaryDark,
            onPressed: () {
              _pageController.nextPage(
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

List<Widget> _buildPageIndicator(int _currentPageIndex) {
  List<Widget> indicators = [];
  for (int i = 0; i < 3; i++) {
    indicators.add(
      i == _currentPageIndex ? _indicator(true) : _indicator(false),
    );
  }
  return indicators;
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
