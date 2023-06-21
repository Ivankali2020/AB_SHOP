class Cart {
  Cart({
    required this.productId,
    required this.quantity,
    required this.bannerId,
  });
  late final int productId;
  late final int quantity;
  late final String bannerId;

  Cart.fromJson(Map<String, dynamic> json){
    productId = json['product_id'];
    quantity = json['quantity'];
    bannerId = json['banner_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['product_id'] = productId;
    _data['quantity'] = quantity;
    _data['banner_id'] = bannerId;
    return _data;
  }
}