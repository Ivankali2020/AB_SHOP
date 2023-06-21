class Notification {
  Notification({
    required this.orderId,
    required this.orderUniqueId,
    required this.message,
    required this.date,
  });
  late final int orderId;
  late final String orderUniqueId;
  late final String message;
  late final String date;

  Notification.fromJson(Map<String, dynamic> json){
    orderId = json['order_id'];
    orderUniqueId = json['order_unique_id'];
    message = json['message'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['order_id'] = orderId;
    _data['order_unique_id'] = orderUniqueId;
    _data['message'] = message;
    _data['date'] = date;
    return _data;
  }
}