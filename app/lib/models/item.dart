class Item {
  int id;
  String name;
  int quantity;
  int storageID;

  int targetQuantity;
  String details;
  String barCode;

  Item({
    required this.id,
    required this.name,
    required this.quantity,
    required this.storageID,
    required this.targetQuantity,
    required this.details,
    required this.barCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'storageID': storageID,
      'targetQuantity': targetQuantity,
      'details': details,
      'barCode': barCode,
    };
  }

  Item.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        name = json['name'] as String,
        quantity = json['quantity'] as int,
        storageID = json['storageID'] as int,
        targetQuantity = json['targetQuantity'] != null ? json['targetQuantity'] as int : 0,
        details = json['details'] != null ? json['details'] as String : "",
        barCode = json['barCode'] != null ? json['barCode'] as String : "";
}
