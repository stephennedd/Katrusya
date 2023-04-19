class UserModel {
  String username;
  String phone;
  String email;
  String password;
  DateTime? createdAt;
  int? balanceOfTokens;
  List<dynamic>? userRoles;

  UserModel(
      {required this.username,
      required this.phone,
      required this.email,
      required this.password,
      this.balanceOfTokens,
      this.createdAt,
      this.userRoles});

  UserModel.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        phone = json['phone'] as String,
        email = json['email'] as String,
        password = json['password'] as String,
        balanceOfTokens = json['balance_of_tokens'] as int,
        createdAt = json['created_at'] as DateTime,
        userRoles = json['roles'] as List<dynamic>;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['phone'] = phone;
    data['email'] = email;
    data['password'] = password;
    data['created_at'] = createdAt;
    data['balance_of_tokens'] = balanceOfTokens;
    data['roles'] = userRoles;
    return data;
  }

  @override
  String toString() {
    return '{\n'
        '    "username": $username,\n'
        '    "phone": "$phone",\n'
        '    "email": "$email",\n'
        '    "password": "$password",\n'
        '    "createdAt": "$createdAt",\n'
        '    "balanceOfTokens": "$balanceOfTokens",\n'
        '    "userRoles": "$userRoles",\n'
        '}';
  }
}
