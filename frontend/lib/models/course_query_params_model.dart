class CourseQueryParamsModel {
  String? category;
  bool? isRecommended;
  bool? isFeatured;
  String? search;

  CourseQueryParamsModel(
      {this.category, this.isRecommended, this.isFeatured, this.search});

  CourseQueryParamsModel.fromJson(Map<String, dynamic> json)
      : category = json['category_name'] as String,
        isRecommended = json['is_recommended'],
        isFeatured = json['is_featured'],
        search = json['search'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_name'] = category;
    data['is_recommended'] = isRecommended;
    data['search'] = search;
    return data;
  }

  @override
  String toString() {
    return '{\n'
        '    "category": "$category",\n'
        '    "is_recommended": "$isRecommended",\n'
        '    "is_featured": "$isFeatured",\n'
        '    "search": "$search",\n'
        '}';
  }
}
