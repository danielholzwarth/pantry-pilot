class Item {
  int id;
  String name;
  int quantity;
  int? targetQuantity;
  String? details;
  String? barCode;

  Item({
    required this.id,
    required this.name,
    required this.quantity,
    this.targetQuantity,
    this.details,
    this.barCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'targetQuantity': targetQuantity,
      'details': details,
      'barCode': barCode,
    };
  }

  Item.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        name = json['name'] as String,
        quantity = json['quantity'] as int,
        targetQuantity = json['targetQuantity'],
        details = json['details'],
        barCode = json['barCode'];
}
