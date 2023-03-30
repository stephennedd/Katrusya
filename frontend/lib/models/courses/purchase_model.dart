class PurchaseModel {
  int userId;
  int courseId;

  PurchaseModel({
    required this.userId,
    required this.courseId,
  });

  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    return PurchaseModel(userId: json['userId'], courseId: json['courseId']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['courseId'] = this.courseId;
    return data;
  }

  @override
  String toString() {
    return '{\n'
        '    "userId": $userId,\n'
        '    "courseId": "$courseId",\n'
        '}';
  }
}
