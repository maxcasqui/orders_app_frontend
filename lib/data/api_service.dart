import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order_model.dart';
import '../models/product_model.dart';

class ApiService {
  static const String baseUrl = "http://192.168.1.9:8080/api/v1";

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

  Future<void> deleteOrder(int orderId) async {
    await http.put(Uri.parse('$baseUrl/orders/delete/$orderId'));
  }

  Future<void> addProductToOrder(int orderId, int productId, int quantity) async {
    final url = Uri.parse('$baseUrl/orders/addProductToOrder');

    await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int>{
        'orderId': orderId,
        'productId': productId,
        'quantity': quantity,
      }),
    );
  }

  Future<void> addOrder(String orderNumber, DateTime orderDate) async {
    await http.post(
      Uri.parse('$baseUrl/orders/add'),
      body: {
        'orderNumber': orderNumber,
        'orderDate': orderDate.toIso8601String(),
      },
    );
  }
}
