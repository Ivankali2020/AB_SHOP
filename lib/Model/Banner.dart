class Banner {
  Banner({
    required this.id,
    required this.name,
    required this.discountPrice,
    required this.discountPercentage,
    required this.photo,
  });
  late final int id;
  late final String name;
  late final int discountPrice;
  late final int discountPercentage;
  late final String photo;

  Banner.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    discountPrice = json['discount_price'];
    discountPercentage = json['discount_percentage'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['discount_price'] = discountPrice;
    _data['discount_percentage'] = discountPercentage;
    _data['photo'] = photo;
    return _data;
  }
}