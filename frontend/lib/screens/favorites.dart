import 'package:flutter/material.dart';
import 'package:frontend/widgets/app_bar_box.dart';
import 'package:frontend/widgets/favorites_item.dart';
import '../models/courses/course_model.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);
  static const String routeName = "/favorites";

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Wishlist",
        centerTitle: false,
        hasBackButton: false,
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    // TODO get list of actually favorited courses and add them to 'items'
    final items = <dynamic>[];
    items.add(CourseModel(
        id: 1,
        name: 'UX/UI Design',
        image: 'https://images.unsplash.com/photo-1586717791821-3f44a563fa4c?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=900&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTY3OTEwMTA4Nw&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1600',
        price: '\$100.00',
        durationInHours: 10,
        numberOfLessons: 6,
        review: '4.5',
        isFavorited: true,
        description: 'This is a test description',
        isFeatured: true,
        isRecommended: true
    ));
    items.add(CourseModel(
        id: 1,
        name: 'UX/UI Design',
        image: 'https://images.unsplash.com/photo-1586717791821-3f44a563fa4c?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=900&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTY3OTEwMTA4Nw&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1600',
        price: '\$100.00',
        durationInHours: 10,
        numberOfLessons: 6,
        review: '4.5',
        isFavorited: true,
        description: 'This is a test description',
        isFeatured: true,
        isRecommended: true
    ));
    items.add(CourseModel(
        id: 1,
        name: 'UX/UI Design',
        image: 'https://images.unsplash.com/photo-1586717791821-3f44a563fa4c?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=900&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTY3OTEwMTA4Nw&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1600',
        price: '\$100.00',
        durationInHours: 10,
        numberOfLessons: 6,
        review: '4.5',
        isFavorited: true,
        description: 'This is a test description',
        isFeatured: true,
        isRecommended: true
    ));
    items.add(CourseModel(
        id: 1,
        name: 'UX/UI Design',
        image: 'https://images.unsplash.com/photo-1586717791821-3f44a563fa4c?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=900&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTY3OTEwMTA4Nw&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1600',
        price: '\$100.00',
        durationInHours: 10,
        numberOfLessons: 6,
        review: '4.5',
        isFavorited: true,
        description: 'This is a test description',
        isFeatured: true,
        isRecommended: true
    ));
    items.add(CourseModel(
        id: 1,
        name: 'UX/UI Design',
        image: 'https://images.unsplash.com/photo-1586717791821-3f44a563fa4c?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=900&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTY3OTEwMTA4Nw&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1600',
        price: '\$100.00',
        durationInHours: 10,
        numberOfLessons: 6,
        review: '4.5',
        isFavorited: true,
        description: 'This is a test description',
        isFeatured: true,
        isRecommended: true
    ));
    items.add(CourseModel(
        id: 1,
        name: 'UX/UI Design',
        image: 'https://images.unsplash.com/photo-1586717791821-3f44a563fa4c?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=900&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTY3OTEwMTA4Nw&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1600',
        price: '\$100.00',
        durationInHours: 10,
        numberOfLessons: 6,
        review: '4.5',
        isFavorited: true,
        description: 'This is a test description',
        isFeatured: true,
        isRecommended: true
    ));
    items.add(CourseModel(
        id: 1,
        name: 'UX/UI Design',
        image: 'https://images.unsplash.com/photo-1586717791821-3f44a563fa4c?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=900&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTY3OTEwMTA4Nw&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1600',
        price: '\$100.00',
        durationInHours: 10,
        numberOfLessons: 6,
        review: '4.5',
        isFavorited: true,
        description: 'This is a test description',
        isFeatured: true,
        isRecommended: true
    ));
    items.add(CourseModel(
        id: 1,
        name: 'UX/UI Design',
        image: 'https://images.unsplash.com/photo-1586717791821-3f44a563fa4c?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=900&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTY3OTEwMTA4Nw&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1600',
        price: '\$100.00',
        durationInHours: 10,
        numberOfLessons: 6,
        review: '4.5',
        isFavorited: true,
        description: 'This is a test description',
        isFeatured: true,
        isRecommended: true
    ));
    items.add(CourseModel(
        id: 1,
        name: 'UX/UI Design',
        image: 'https://images.unsplash.com/photo-1586717791821-3f44a563fa4c?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=900&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTY3OTEwMTA4Nw&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1600',
        price: '\$100.00',
        durationInHours: 10,
        numberOfLessons: 6,
        review: '4.5',
        isFavorited: true,
        description: 'This is a test description',
        isFeatured: true,
        isRecommended: true
    ));
    items.add(CourseModel(
        id: 1,
        name: 'UX/UI Design',
        image: 'https://images.unsplash.com/photo-1586717791821-3f44a563fa4c?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=900&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTY3OTEwMTA4Nw&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1600',
        price: '\$100.00',
        durationInHours: 10,
        numberOfLessons: 6,
        review: '4.5',
        isFavorited: true,
        description: 'This is a test description',
        isFeatured: true,
        isRecommended: true
    ));
    items.add(CourseModel(
        id: 1,
        name: 'UX/UI Design',
        image: 'https://images.unsplash.com/photo-1586717791821-3f44a563fa4c?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=900&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTY3OTEwMTA4Nw&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1600',
        price: '\$100.00',
        durationInHours: 10,
        numberOfLessons: 6,
        review: '4.5',
        isFavorited: true,
        description: 'This is a test description',
        isFeatured: true,
        isRecommended: true
    ));

    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return FavoritesItem(
            data: items[index],
            onTap: () {
              // TODO navigate to course
            },
          );
        }
      ),
    );
  }
}
