class Order {
  Order({
    required this.orderId,
    required this.orderData,
  });
  late final String orderId;
  late final OrderData orderData;

  Order.fromJson(Map<String, dynamic> json){
    orderId = json['order_id'];
    orderData = OrderData.fromJson(json['order_data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['order_id'] = orderId;
    _data['order_data'] = orderData.toJson();
    return _data;
  }
}

class OrderData {
  OrderData({
    required this.status,
    required this.totalPrice,
    required this.quantity,
    required this.date,
  });
  late final String status;
  late final int totalPrice;
  late final int quantity;
  late final String date;

  OrderData.fromJson(Map<String, dynamic> json){
    status = json['status'];
    totalPrice = json['total_price'];
    quantity = json['quantity'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['total_price'] = totalPrice;
    _data['quantity'] = quantity;
    _data['date'] = date;
    return _data;
  }
}