class LoginModel {
  String email;
  String password;

  LoginModel({required this.email, required this.password});

  LoginModel.fromJson(Map<String, dynamic> json)
      : email = json['email'] as String,
        password = json['password'] as String;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }

  @override
  String toString() {
    return '{\n'
        '    "email": "$email",\n'
        '    "password": "$password",\n'
        '}';
  }
}
