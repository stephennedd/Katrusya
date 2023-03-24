import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/Themes/app_colors.dart';
import 'package:frontend/utils/data.dart';
import 'package:frontend/widgets/course_item.dart';
import 'package:frontend/widgets/searchcategory_item.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, this.onTap}) : super(key: key);
  final GestureTapCallback? onTap;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: appBarColor,
            pinned: true,
            elevation: 0.5,
            title: getAppBar(),
          ),
          SliverToBoxAdapter(
            child: getSearchBox(),
          ),
          SliverToBoxAdapter(
            child: getCategories(),
          ),
          SliverList(delegate: getCourses())
        ],
      ),
    );
  }

  getAppBar() {
    return Row(
      children: const [
        Text(
          "Search",
          style: TextStyle(
          fontFamily: 'Nexa-Trial',
          fontSize: 24,
          color: textColor,
          fontWeight: FontWeight.w800
          ),
        )
      ],
    );
  }

  getSearchBox() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              padding: const EdgeInsets.only(bottom: 3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor.withOpacity(.05),
                    spreadRadius: .5,
                    blurRadius: .5,
                    offset: const Offset(0, 0),
                  )
                ]),
              // TODO filter results based on search query
              child: const TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey
                  ),
                  border: InputBorder.none,
                  hintText: "Search",
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontSize: 15
                  )
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: (){
              print("filter Pressed");
          },
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(7),
              ),
              child: SvgPicture.asset(
                "assets/icons/filter.svg",
                colorFilter: const ColorFilter.mode(primaryDark, BlendMode.srcIn),
              ),
            ),
          )
        ],
      ),
    );
  }

  int selectedItemIndex = 0;
  getCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 15, top: 10, bottom: 5),
      child: Row(
        // TODO get categories from database
        children: List.generate(categories.length,
            (index) => CategoryItem(
                data: categories[index],
                isSelected: selectedItemIndex == index,
                onTap: () {
                  setState(() {
                    selectedItemIndex = index;
                  });
                },
            ))
      ),
    );
  }
  
  getCourses() {
    return SliverChildBuilderDelegate(
      childCount: courses.length,
          (context, index) {
      return Padding(
        padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
        child: CourseItem(
          // TODO get courses from database
          data: courses[index],
          onFavorite: () {
            setState(() {
              courses[index]["is_favorited"] = !courses[index]["is_favorited"];
            });
          },
        )
      );
    });
  }


}
