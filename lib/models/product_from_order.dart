class ProductFromOrder {
  final int orderItemId;
  final int orderId;
  final String productName;
  final int quantity;
  final double totalPrice;

  ProductFromOrder({
    required this.orderItemId,
    required this.orderId,
    required this.productName,
    required this.quantity,
    required this.totalPrice,
  });

  factory ProductFromOrder.fromJson(Map<String, dynamic> json) {
    return ProductFromOrder(
      orderItemId: json['orderItemId'],
      orderId: json['orderId'],
      productName: json['productName'],
      quantity: json['quantity'],
      totalPrice: json['totalPrice'].toDouble(),
    );
  }
}