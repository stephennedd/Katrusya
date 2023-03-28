class UserModel {
  String username;
  String phone;
  String email;
  String password;

  UserModel(
      {required this.username,
      required this.phone,
      required this.email,
      required this.password});

  UserModel.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        phone = json['phone'] as String,
        email = json['email'] as String,
        password = json['password'] as String;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }

  @override
  String toString() {
    return '{\n'
        '    "username": $username,\n'
        '    "phone": "$phone",\n'
        '    "email": "$email",\n'
        '    "password": "$password",\n'
        '}';
  }
}
