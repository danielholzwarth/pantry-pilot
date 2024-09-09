class UserAccount {
  int id;
  String email;
  DateTime createdAt;

  UserAccount({
    required this.id,
    required this.email,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'createdAt': createdAt.toString(),
    };
  }

  UserAccount.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        email = json['email'] as String,
        createdAt = DateTime.parse(json['createdAt']);
}
