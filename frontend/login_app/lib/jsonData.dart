class Data {
  final String name;
  final int quantity;
  final String type;

  Data({required this.name, required this.quantity, required this.type});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      name: json['name'],
      quantity: json['quantity'],
      type: json['type'],
    );
  }
}
