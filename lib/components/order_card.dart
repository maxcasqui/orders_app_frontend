import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:orders_app/models/order_model.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  Function(BuildContext)? deleteFunction;
  Function(BuildContext)? editFunction;
  OrderCard({super.key, required this.order, required this.deleteFunction, required this.editFunction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Slidable(
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
        startActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
              SlidableAction(
              borderRadius: BorderRadius.circular(12),
              onPressed: editFunction,
              icon: Icons.edit,
              backgroundColor: Colors.green,
            )
          ]
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(flex: 3, child: Row(
                      children: [
                        const Text('Order ID: '),
                        Text(order.id.toString(), style: const TextStyle(fontWeight: FontWeight.bold))
                      ],
                    )),
                    Flexible(
                      flex: 1,
                      child: Text(
                        order.orderDate.toString().split(" ")[0],
                        style: const TextStyle(fontWeight: FontWeight.bold)
                        )
                      )
                  ],
                ),
                Row(
                  children: [
                    const Text('Order Number: '),
                    Text(order.orderNumber.toString(), style: const TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
                Row(
                  children: [
                    const Text('Products Qty: '),
                    Text(order.numProducts.toString(), style: const TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
                Row(
                  children: [
                    const Text('Final Price: '),
                    Text("S/. ${order.finalPrice}", style: const TextStyle(fontWeight: FontWeight.bold))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}