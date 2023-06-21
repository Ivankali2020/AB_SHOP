class Product {
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.discountPrice,
    required this.stock,
    required this.unit,
    required this.detail,
    required this.categoryName,
    required this.subCategoryName,
    required this.categoryId,
    required this.brandName,
    required this.brandId,
    required this.photos,
    required this.isFavourite,
    required this.banner,
  });
  late final int id;
  late final String name;
  late final int price;
  late final int discountPrice;
  late final int stock;
  late final String unit;
  late final String detail;
  late final String categoryName;
  late final String subCategoryName;
  late final int categoryId;
  late final String brandName;
  late final int brandId;
  late final List<String> photos;
  late  bool isFavourite;
  late final Banner? banner;

  void favouriteToggle() {
    isFavourite = !isFavourite;
  }

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    discountPrice = json['discount_price'];
    stock = json['stock'];
    unit = json['unit'];
    detail = json['detail'];
    categoryName = json['category_name'];
    subCategoryName = json['sub_category_name'];
    categoryId = json['category_id'];
    brandName = json['brand_name'];
    brandId = json['brand_id'];
    photos = List.castFrom<dynamic, String>(json['photos']);
    isFavourite = json['is_favourite'];
    banner = json['banner'] != null ? Banner.fromJson(json['banner']) : null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['price'] = price;
    _data['discount_price'] = discountPrice;
    _data['stock'] = stock;
    _data['unit'] = unit;
    _data['detail'] = detail;
    _data['category_name'] = categoryName;
    _data['sub_category_name'] = subCategoryName;
    _data['category_id'] = categoryId;
    _data['brand_name'] = brandName;
    _data['brand_id'] = brandId;
    _data['photos'] = photos;
    _data['is_favourite'] = isFavourite;
    _data['banner'] = banner != null ? banner!.toJson() : null;
    return _data;
  }
}

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

  Banner.fromJson(Map<String, dynamic> json) {
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
