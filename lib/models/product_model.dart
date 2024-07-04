class Product {
  final int productId;
  final String productName;
  final double unitPrice;

  Product({
    required this.productId,
    required this.productName,
    required this.unitPrice,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'],
      productName: json['productName'],
      unitPrice: json['unitPrice'].toDouble(),
    );
  }
}