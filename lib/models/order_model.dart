class Order {
  final int id;
  String orderNumber;
  final String orderDate;
  final int? numProducts;
  final double? finalPrice;
  final String status;

  Order({
    required this.id,
    required this.orderNumber,
    required this.orderDate,
    required this.numProducts,
    required this.finalPrice,
    required this.status
  });

  factory Order.fromJson(List<dynamic> json) {
    return Order(
      id: json[0],
      orderNumber: json[1],
      orderDate: json[2],
      numProducts: json[3] ?? 0,
      finalPrice: json[4]?.toDouble() ?? 0.0,
      status: json[5]
    );
  }
}
