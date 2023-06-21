class User {
  User({
    required this.id,
    required this.name,
     this.email,
     this.phone,
    required this.credentials,
     this.emailVerifiedAt,
    required this.role,
    required this.photo,
     this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late  String name;
  late final String? email;
  late final String? phone;
  late  String credentials;
  late final String? emailVerifiedAt;
  late final String role;
  late  String photo;
  late final String? deletedAt;
  late final String createdAt;
  late final String updatedAt;

  User.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    email = json['email'] == null ? '-' : '0';
    phone = json['phone'] == null ? '-' : '0';
    credentials = json['credentials'];
    emailVerifiedAt = json['emailVerifiedAt'] == null ? '-' : '0';
    role = json['role'];
    photo = json['photo'];
    deletedAt = json['deletedAt'] == null ? '-' : '0';
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['email'] = email;
    _data['phone'] = phone;
    _data['credentials'] = credentials;
    _data['email_verified_at'] = emailVerifiedAt;
    _data['role'] = role;
    _data['photo'] = photo;
    _data['deleted_at'] = deletedAt;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}