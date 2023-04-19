class CategoryModel {
  int id;
  String name;
  String icon;

  CategoryModel({required this.id, required this.name, required this.icon});

  CategoryModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'] as String,
        icon = json['icon'] as String;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['icon'] = icon;
    return data;
  }

  @override
  String toString() {
    return '{\n'
        '    "id": $id,\n'
        '    "name": "$name",\n'
        '    "icon": "$icon",\n'
        '}';
  }
}
