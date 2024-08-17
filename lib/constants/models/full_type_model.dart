class FullTypeModel {
  final String name;
  final String url;

  FullTypeModel({required this.name, required this.url});

  factory FullTypeModel.fromJson(Map<String, dynamic> json) {
    return FullTypeModel(name: json['name'], url: json['url']);
  }
}
