class Item {
  final String name;
  final String quantity;
  final int type;

  Item({required this.name, required this.quantity, required this.type});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'],
      quantity: json['quantity'],
      type: json['type'],
    );
  }
}
