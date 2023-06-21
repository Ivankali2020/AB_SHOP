class Township {
  Township({
    required this.townshipId,
    required this.regionId,
    required this.regionName,
    required this.townshipName,
    required this.cod,
    required this.fees,
    required this.duration,
    required this.remark,
  });
  late final int townshipId;
  late final int regionId;
  late final String regionName;
  late final String townshipName;
  late final bool cod;
  late final int fees;
  late final int duration;
  late final String remark;

  Township.fromJson(Map<String, dynamic> json){
    townshipId = json['township_id'];
    regionId = json['region_id'];
    regionName = json['region_name'];
    townshipName = json['township_name'];
    cod = json['cod'];
    fees = json['fees'];
    duration = json['duration'];
    remark = json['remark'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['township_id'] = townshipId;
    _data['region_id'] = regionId;
    _data['region_name'] = regionName;
    _data['township_name'] = townshipName;
    _data['cod'] = cod;
    _data['fees'] = fees;
    _data['duration'] = duration;
    _data['remark'] = remark;
    return _data;
  }
}