class Coupon {
  Coupon({
    required this.id,
    required this.name,
    required this.isUsed,
    required this.code,
    required this.amount,
    required this.couponName,
    required this.expireDate,
    required this.status,
  });
  late final int id;
  late final String name;
  late final bool isUsed;
  late final String code;
  late final int amount;
  late final String couponName;
  late final String expireDate;
  late final String status;

  Coupon.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    isUsed = json['is_used'];
    code = json['code'];
    amount = json['amount'];
    couponName = json['coupon_name'];
    expireDate = json['expire_date'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['is_used'] = isUsed;
    _data['code'] = code;
    _data['amount'] = amount;
    _data['coupon_name'] = couponName;
    _data['expire_date'] = expireDate;
    _data['status'] = status;
    return _data;
  }
}