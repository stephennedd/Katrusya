class UserModel {
  String username;
  String phone;
  String email;
  String password;
  DateTime? createdAt;
  int? balanceOfTokens;

  UserModel(
      {required this.username,
      required this.phone,
      required this.email,
      required this.password,
      this.balanceOfTokens,
      this.createdAt});

  UserModel.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        phone = json['phone'] as String,
        email = json['email'] as String,
        password = json['password'] as String,
        balanceOfTokens = json['balance_of_tokens'] as int,
        createdAt = json['created_at'] as DateTime;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['password'] = this.password;
    data['created_at'] = this.createdAt;
    data['balance_of_tokens'] = this.balanceOfTokens;
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
        '}';
  }
}
