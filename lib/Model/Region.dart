class Region {
  Region({
    required this.region,
    required this.regionId,
  });
  late final String region;
  late final int regionId;

  Region.fromJson(Map<String, dynamic> json){
    region = json['region'];
    regionId = json['region_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['region'] = region;
    _data['region_id'] = regionId;
    return _data;
  }
}