class Cerror {
  Cerror({
    required this.data,
  });
  late final Data data;

  Cerror.fromJson(Map<String, dynamic> json){
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.credentials,
  });
  late final List<String> credentials;

  Data.fromJson(Map<String, dynamic> json){
    credentials = List.castFrom<dynamic, String>(json['credentials']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['credentials'] = credentials;
    return _data;
  }
}