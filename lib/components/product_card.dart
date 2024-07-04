import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:orders_app/models/product_from_order.dart';

class ProductCard extends StatelessWidget {
  final ProductFromOrder product;
  final Function(BuildContext)? deleteFunction;
  const ProductCard({super.key, required this.product, required this.deleteFunction});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            borderRadius: BorderRadius.circular(12),
            onPressed: deleteFunction,
            icon: Icons.delete,
            backgroundColor: Colors.red,
          )
        ]
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade200,
          borderRadius: BorderRadius.circular(12)
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Product: '),
                Text(product.productName, style: const TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
            Row(
              children: [
                const Text('Quantity: '),
                Text(product.quantity.toString(), style: const TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
            Row(
              children: [
                const Text('Total Price: '),
                Text("S/. ${product.totalPrice}", style: const TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
          ],
        ),
      ),
    );
  }
}