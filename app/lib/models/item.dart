class Item {
  int id;
  String name;
  int quantity;
  String? details;
  String? barCode;
  int? targetQuantity;

  Item({
    required this.id,
    required this.name,
    required this.quantity,
    this.details,
    this.barCode,
    this.targetQuantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'details': details,
      'barCode': barCode,
      'targetQuantity': targetQuantity,
    };
  }

  Item.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        name = json['name'] as String,
        quantity = json['quantity'] as int,
        details = json['details'],
        barCode = json['barCode'],
        targetQuantity = json['targetQuantity'];
}
