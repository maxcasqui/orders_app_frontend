class Order {
  final int id;
  String orderNumber;
  final DateTime orderDate;
  final int? numProducts;
  final double? finalPrice;

  Order({
    required this.id,
    required this.orderNumber,
    required this.orderDate,
    this.numProducts,
    this.finalPrice,
  });

  factory Order.fromJson(List<dynamic> json) {
    return Order(
      id: json[0],
      orderNumber: json[1],
      orderDate: DateTime.parse(json[2]),
      numProducts: json[3],
      finalPrice: json[4]?.toDouble(),
    );
  }
}
