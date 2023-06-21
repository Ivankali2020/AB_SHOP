class OrderDetail {
  OrderDetail({
    required this.deliveryName,
    required this.deliveryPhone,
    required this.shippingAddress,
    required this.deliveryFees,
    required this.couponAmount,
    required this.status,
    required this.paymentMethod,
    required this.cancelRefund,
    required this.totalPrice,
    required this.quantity,
    required this.date,
    required this.note,
    required this.products,
  });
  late final String deliveryName;
  late final String deliveryPhone;
  late final String shippingAddress;
  late final int deliveryFees;
  late final int couponAmount;
  late final String status;
  late final PaymentMethod paymentMethod;
  late final CancelRefund cancelRefund;
  late final int totalPrice;
  late final int quantity;
  late final String date;
  late final String note;
  late final List<Products> products;

  OrderDetail.fromJson(Map<String, dynamic> json){
    deliveryName = json['delivery_name'];
    deliveryPhone = json['delivery_phone'];
    shippingAddress = json['shipping_address'];
    deliveryFees = json['delivery_fees'];
    couponAmount = json['coupon_amount'];
    status = json['status'];
    paymentMethod = PaymentMethod.fromJson(json['payment_method']);
    cancelRefund = CancelRefund.fromJson(json['cancel_refund']);
    totalPrice = json['total_price'];
    quantity = json['quantity'];
    date = json['date'];
    note = json['note'];
    products = List.from(json['products']).map((e)=>Products.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['delivery_name'] = deliveryName;
    _data['delivery_phone'] = deliveryPhone;
    _data['shipping_address'] = shippingAddress;
    _data['delivery_fees'] = deliveryFees;
    _data['coupon_amount'] = couponAmount;
    _data['status'] = status;
    _data['payment_method'] = paymentMethod.toJson();
    _data['cancel_refund'] = cancelRefund.toJson();
    _data['total_price'] = totalPrice;
    _data['quantity'] = quantity;
    _data['date'] = date;
    _data['note'] = note;
    _data['products'] = products.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class PaymentMethod {
  PaymentMethod({
    required this.name,
    required this.photo,
  });
  late final String? name;
  late final String? photo;

  PaymentMethod.fromJson(Map<String, dynamic> json){
    name = json['name'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['photo'] = photo;
    return _data;
  }
}

class CancelRefund {
  CancelRefund({
     this.message,
     this.photo,
  });
  late final Null message;
  late final Null photo;

  CancelRefund.fromJson(Map<String, dynamic> json){
    message = null;
    photo = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['photo'] = photo;
    return _data;
  }
}

class Products {
  Products({
    required this.name,
    required this.photo,
    required this.brand,
    required this.category,
    required this.quantity,
    required this.price,
    required this.presentDiscountPrice,
    required this.totalPrice,
    required this.unit,
    required this.discountPrice,
    required this.discountPercentage,
  });
  late final String name;
  late final String photo;
  late final String brand;
  late final String category;
  late final int quantity;
  late final int price;
  late final int presentDiscountPrice;
  late final int totalPrice;
  late final String unit;
  late final int discountPrice;
  late final int discountPercentage;

  Products.fromJson(Map<String, dynamic> json){
    name = json['name'];
    photo = json['photo'];
    brand = json['brand'];
    category = json['category'];
    quantity = json['quantity'];
    price = json['price'];
    presentDiscountPrice = json['present_discount_price'];
    totalPrice = json['total_price'];
    unit = json['unit'];
    discountPrice = json['discount_price'];
    discountPercentage = json['discount_percentage'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['photo'] = photo;
    _data['brand'] = brand;
    _data['category'] = category;
    _data['quantity'] = quantity;
    _data['price'] = price;
    _data['present_discount_price'] = presentDiscountPrice;
    _data['total_price'] = totalPrice;
    _data['unit'] = unit;
    _data['discount_price'] = discountPrice;
    _data['discount_percentage'] = discountPercentage;
    return _data;
  }
}