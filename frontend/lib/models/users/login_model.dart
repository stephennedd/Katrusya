class LoginModel {
  String email;
  String password;

  LoginModel({required this.email, required this.password});

  LoginModel.fromJson(Map<String, dynamic> json)
      : email = json['email'] as String,
        password = json['password'] as String;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
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
