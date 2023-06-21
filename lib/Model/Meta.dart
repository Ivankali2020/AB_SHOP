class Meta {
  Meta({
    required this.totalProduct,
    required this.currentPage,
    required this.lastPage,
    required this.hasMorePage,
  });
  late final int totalProduct;
  late final int currentPage;
  late final int lastPage;
  late final bool hasMorePage;

  Meta.fromJson(Map<String, dynamic> json){
    totalProduct = json['total_product'];
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    hasMorePage = json['has_more_page'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['total_product'] = totalProduct;
    _data['current_page'] = currentPage;
    _data['last_page'] = lastPage;
    _data['has_more_page'] = hasMorePage;
    return _data;
  }
}