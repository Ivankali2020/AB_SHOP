class Payment {
  Payment({
    required this.id,
    required this.name,
    required this.account,
    required this.photo,
    required this.qrPhoto,
  });
  late final int id;
  late final String name;
  late final String account;
  late final String photo;
  late final String qrPhoto;

  Payment.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    account = json['account'];
    photo = json['photo'];
    qrPhoto = json['qr_photo'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['account'] = account;
    _data['photo'] = photo;
    _data['qr_photo'] = qrPhoto;
    return _data;
  }
}