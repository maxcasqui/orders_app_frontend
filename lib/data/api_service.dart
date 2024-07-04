import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:orders_app/models/order_model.dart';
import 'package:orders_app/models/product_from_order.dart';
import 'package:orders_app/models/product_model.dart';

class ApiService {
  static const String baseUrl = "http://192.168.1.8:8080/api/v1";

  Future<List<Order>> listOrders() async {
    final response = await http.get(Uri.parse('$baseUrl/orders/list'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((orderJson) => Order.fromJson(orderJson)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<List<Product>> listProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/product/list'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      List<Product> products = list.map((model) => Product.fromJson(model)).toList();
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<ProductFromOrder>> listProductsFromOrder(int orderId) async {
    final response = await http.get(Uri.parse('$baseUrl/product/listProductsFromOrder/$orderId'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      List<ProductFromOrder> products = list.map((model) => ProductFromOrder.fromJson(model)).toList();
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<String> createOrder(String orderNumber, String orderDate) async {
    final url = Uri.parse('$baseUrl/orders/add');

    final body = jsonEncode({
      'orderNumber': orderNumber,
      'orderDate': orderDate,
    });

    final response = await http.post(url, body: body, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      return 'Order created';
    }

    return 'Error creting order';
  }

  Future<String> deleteOrder(int orderId) async {
    final response = await http.put(Uri.parse('$baseUrl/orders/delete/$orderId'));

    if (response.statusCode == 200) {
      return 'Order deleted';
    }

    return 'Error deleting';
  }

  Future<String> deleteItemFromOrder(int orderItemId) async {
    final response = await http.delete(Uri.parse('$baseUrl/orders/deleteItem/$orderItemId'));

    if (response.statusCode == 200) {
      return 'Item deleted';
    }

    return 'Error deleting item';
  }

  Future<String> addProductToOrder(int orderId, int productId, int quantity) async {
    final url = Uri.parse('$baseUrl/orders/addProductToOrder');
    final body = jsonEncode({
      'orderId': orderId,
      'productId': productId,
      'quantity': quantity,
    });

    final response = await http.post(url, body: body, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      return 'Product added to order';
    }

    return 'Error adding product';
  }

  Future<String> updateOrderStatus(int orderId, String status) async {
    final url = Uri.parse('$baseUrl/orders/updateStatus');
    final body = jsonEncode({
      'orderId': orderId,
      'status': status,
    });

    final response = await http.post(url, body: body, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      return 'Status updated';
    }

    return 'Error updating status';
  }
}
