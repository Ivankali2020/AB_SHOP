class Category {
  Category({
    required this.id,
    required this.name,
    required this.photo,
    required this.brands,
  });
  late final int id;
  late final String name;
  late final String photo;
  late final List<Brands> brands;
  late  bool isSelected = false;

  void changeSelected() {
    isSelected = false;
  }

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    photo = json['photo'];
    brands = List.from(json['brands']).map((e) => Brands.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['photo'] = photo;
    _data['brands'] = brands.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Brands {
  Brands({
    required this.id,
    required this.name,
    required this.photo,
  });
  late final int id;
  late final String name;
  late final String photo;

  Brands.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['photo'] = photo;
    return _data;
  }
}
