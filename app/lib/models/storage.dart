import 'package:app/models/item.dart';

class Storage {
  int id;
  String name;
  List<Item> items;
  DateTime updatedAt;

  Storage({
    required this.id,
    required this.name,
    required this.items,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'updatedAt': updatedAt.toString(),
    };
  }

  Storage.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        name = json['name'] as String,
        items = List<Item>.from(json['items'].map((itemsJson) {
          return Item.fromJson(itemsJson);
        })),
        updatedAt = DateTime.parse(json['updatedAt']);
}
